import { defineConfig } from "@playwright/test";
import { consumerFixture } from "./tests/consumer-fixture.js";

const fixture = consumerFixture();

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
    command:
      'tailwindcss -i tests/consumer/styles.input.css -o "$EXPHERE_SHADER_CONSUMER_DIR/src/app/fixture.css" --minify && next build "$EXPHERE_SHADER_CONSUMER_DIR" --webpack && next start "$EXPHERE_SHADER_CONSUMER_DIR" --hostname 127.0.0.1 --port 3067',
    env: {
      EXPHERE_SHADER_CONSUMER_DIR: fixture,
      NEXT_TELEMETRY_DISABLED: "1",
    },
    url: "http://127.0.0.1:3067",
    reuseExistingServer: false,
    timeout: 120000,
  },
});
