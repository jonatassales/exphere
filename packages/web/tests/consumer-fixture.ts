import { cpSync, mkdirSync, mkdtempSync, rmSync, symlinkSync } from "node:fs";
import { tmpdir } from "node:os";
import { join, resolve } from "node:path";

/** Prepare the existing public-package consumer for Playwright's native server lifecycle. */
export function consumerFixture(): string {
  const inherited = process.env.EXPHERE_SHADER_CONSUMER_DIR;
  if (inherited) return inherited;

  const webRoot = process.cwd();
  const repoRoot = resolve(webRoot, "../..");
  const fixture = mkdtempSync(join(tmpdir(), "exphere-shader-consumer-"));
  const cleanup = () => rmSync(fixture, { recursive: true, force: true });
  process.once("exit", cleanup);

  try {
    cpSync(join(webRoot, "tests/consumer"), fixture, { recursive: true });
    mkdirSync(join(fixture, "node_modules/@repo"), { recursive: true });
    mkdirSync(join(fixture, "node_modules/@types"), { recursive: true });
    for (const name of ["web", "design"]) {
      const source = join(repoRoot, "packages", name);
      const target = join(fixture, "node_modules/@repo", name);
      mkdirSync(target);
      cpSync(join(source, "package.json"), join(target, "package.json"));
      cpSync(join(source, "dist"), join(target, "dist"), { recursive: true });
    }
    for (const name of ["next", "react", "react-dom", "typescript"]) {
      symlinkSync(
        join(webRoot, "node_modules", name),
        join(fixture, "node_modules", name),
      );
    }
    for (const name of ["node", "react", "react-dom"]) {
      symlinkSync(
        join(webRoot, "node_modules/@types", name),
        join(fixture, "node_modules/@types", name),
      );
    }
    process.env.EXPHERE_SHADER_CONSUMER_DIR = fixture;
    return fixture;
  } catch (error) {
    cleanup();
    throw error;
  }
}
