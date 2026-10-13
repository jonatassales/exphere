import { readFile, rm } from "node:fs/promises";
import path from "node:path";
import { pathToFileURL } from "node:url";
import type { NextAdapter } from "next";
import * as pagefind from "pagefind";

// Vercel supplies its adapter at build time; preserve its configuration and packaging.
let platformAdapter: NextAdapter | undefined;
if (process.env.NEXT_ADAPTER_PATH) {
  try {
    const adapterModule = await import(
      pathToFileURL(process.env.NEXT_ADAPTER_PATH).href
    );

    platformAdapter = adapterModule.default;
  } catch (cause) {
    throw new Error("Unable to load the platform build adapter.", { cause });
  }
}

const adapter: NextAdapter = {
  name: "Exphere documentation search",
  async modifyConfig(config, context) {
    if (!platformAdapter?.modifyConfig) {
      return config;
    }
    try {
      const modifiedConfig = await platformAdapter.modifyConfig(
        config,
        context,
      );

      return modifiedConfig;
    } catch (cause) {
      throw new Error("Unable to apply the platform build configuration.", {
        cause,
      });
    }
  },
  async onBuildComplete(context) {
    try {
      const documents = new Map<string, string>();
      for (const output of [
        ...context.outputs.staticFiles,
        ...context.outputs.prerenders.map((output) => ({
          pathname: output.pathname,
          filePath: output.fallback?.filePath,
        })),
      ]) {
        const isDocumentation =
          output.pathname === "/docs" || output.pathname.startsWith("/docs/");
        const isHtml = output.filePath?.endsWith(".html");
        if (!isDocumentation || !isHtml || !output.filePath) {
          continue;
        }
        documents.set(output.pathname, output.filePath);
      }
      if (documents.size === 0) {
        throw new Error("No prerendered documentation pages found for search.");
      }

      try {
        const { index, errors } = await pagefind.createIndex();

        if (errors.length || !index) {
          throw new Error(
            `Unable to create search index: ${errors.join("; ")}`,
          );
        }
        for (const [url, filePath] of documents) {
          const content = await readFile(filePath, "utf8");

          const result = await index.addHTMLFile({ url, content });

          if (result.errors.length) {
            throw new Error(
              `Unable to index ${url}: ${result.errors.join("; ")}`,
            );
          }
        }
        const outputPath = path.join(context.projectDir, "public/_pagefind");

        await rm(outputPath, { recursive: true, force: true });

        const result = await index.writeFiles({ outputPath });

        if (result.errors.length) {
          throw new Error(
            `Unable to write search index: ${result.errors.join("; ")}`,
          );
        }
        console.info(`Search: indexed ${documents.size} documentation pages.`);
      } finally {
        await pagefind.close();
      }

      // The platform must see the generated public files before packaging the site.
      if (platformAdapter?.onBuildComplete) {
        await platformAdapter.onBuildComplete(context);
      }
    } catch (cause) {
      throw new Error(
        "Unable to build documentation search and package the website.",
        {
          cause,
        },
      );
    }
  },
};

export default adapter;
