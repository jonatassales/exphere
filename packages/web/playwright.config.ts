import { defineConfig } from "@playwright/test";

export default defineConfig({
  testDir: "./tests",
  testMatch: "*.spec.ts",
  workers: 1,
  reporter: "list",
  outputDir: "../../.audits/evidence/runs/exphere-shader/browser",
  use: {
    baseURL: "http://127.0.0.1:3067",
    viewport: { width: 1352, height: 605 },
    launchOptions: { args: ["--enable-unsafe-swiftshader"] },
    screenshot: "only-on-failure",
  },
  webServer: {
    command: "sh scripts/serve-consumer.sh",
    url: "http://127.0.0.1:3067",
    reuseExistingServer: false,
    timeout: 30000,
  },
});
