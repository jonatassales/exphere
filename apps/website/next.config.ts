import path from "node:path";
import type { NextConfig } from "next";
import nextra from "nextra";

const withNextra = nextra({});

const config: NextConfig = {
  turbopack: {
    resolveAlias: {
      "next-mdx-import-source-file": "./app/components/mdx-components.tsx",
    },
  },
  webpack(config) {
    config.resolve.alias["next-mdx-import-source-file"] = path.resolve(
      process.cwd(),
      "app/components/mdx-components.tsx",
    );

    return config;
  },
};

export default withNextra(config);
