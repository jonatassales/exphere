import { expect, type Page, test } from "@playwright/test";

async function graphicsDrawCount(page: Page) {
  const count = await page.evaluate(
    () => performance.getEntriesByName("consumer-graphics-draw").length,
  );

  return count;
}

test("public wrapper renders server children and remains interactive", async ({
  page,
}) => {
  const errors: string[] = [];
  page.on("pageerror", (error) => errors.push(error.message));
  page.on("console", (message) => {
    if (message.type() === "error") {
      errors.push(message.text());
    }
  });

  await page.goto("/");

  await expect(
    page.getByRole("heading", { name: "Build what comes next." }),
  ).toBeVisible();

  await page.getByRole("textbox").fill("A new idea");

  await expect(page.getByRole("textbox")).toHaveValue("A new idea");

  await expect(page.locator("canvas")).toHaveCount(1);

  await page.getByRole("link", { name: "Explore" }).focus();

  await page.keyboard.press("Tab");

  await expect(page.getByRole("textbox")).toBeFocused();

  expect(errors).toEqual([]);
});

test("children are present before JavaScript or hydration runs", async ({
  browser,
}) => {
  const context = await browser.newContext({ javaScriptEnabled: false });

  const page = await context.newPage();

  await page.goto("http://127.0.0.1:3067/");

  await expect(
    page.getByRole("heading", { name: "Build what comes next." }),
  ).toBeVisible();

  await expect(page.getByRole("textbox")).toBeVisible();

  await context.close();
});

test("unmount releases the bound WebGL program immediately", async ({
  page,
}) => {
  await page.goto("/");

  await expect(page.locator("canvas")).toBeVisible();

  const resources = await page
    .locator("canvas")
    .evaluateHandle((canvas: HTMLCanvasElement) => {
      const context = canvas.getContext("webgl2");

      if (!context) {
        throw new Error("The test requires WebGL2");
      }

      return {
        context,
        program: context.getParameter(context.CURRENT_PROGRAM) as WebGLProgram,
      };
    });

  const initiallyAlive = await resources.evaluate(({ context, program }) =>
    context.isProgram(program),
  );

  expect(initiallyAlive).toBe(true);

  await page.getByRole("button", { name: "Unmount surface" }).click();

  const disposed = await resources.evaluate(({ context, program }) => ({
    current: context.getParameter(context.CURRENT_PROGRAM),
    alive: context.isProgram(program),
  }));

  expect(disposed).toEqual({ current: null, alive: false });

  await resources.dispose();
});

test("decoration preserves empty, short and long document geometry through resize", async ({
  page,
}) => {
  for (const viewport of [
    { width: 1352, height: 605 },
    { width: 390, height: 844 },
  ]) {
    await page.setViewportSize(viewport);

    for (const query of ["", "long=1", "empty=1"]) {
      await page.goto(`/?plain=1&${query}`);

      const baseline = await page.evaluate(() => ({
        width: document.documentElement.scrollWidth,
        height: document.documentElement.scrollHeight,
      }));

      await page.goto(`/?${query}`);

      const decorated = await page.evaluate(() => ({
        width: document.documentElement.scrollWidth,
        height: document.documentElement.scrollHeight,
      }));

      expect(decorated).toEqual(baseline);
      expect(decorated.width).toBe(viewport.width);
    }
  }

  await page.goto("/?long=1");

  await page.evaluate(() => window.scrollTo(0, 600));

  const positions = await page.evaluate(() => ({
    scroll: window.scrollY,
    canvasTop: document.querySelector("canvas")?.getBoundingClientRect().top,
    fixedBottom: document.querySelector("aside")?.getBoundingClientRect()
      .bottom,
    stickyTop: document.querySelectorAll("aside")[1]?.getBoundingClientRect()
      .top,
  }));

  expect(positions.scroll).toBe(600);
  expect(positions.canvasTop).toBe(0);
  expect(positions.fixedBottom).toBe(844 - 16);
  expect(positions.stickyTop).toBe(0);
});

test("reduced motion, hidden presentation and unmount stop graphics work", async ({
  page,
}) => {
  await page.addInitScript(() => {
    const draw = WebGL2RenderingContext.prototype.drawArrays;

    WebGL2RenderingContext.prototype.drawArrays = function (
      mode,
      first,
      count,
    ) {
      performance.mark("consumer-graphics-draw");

      return draw.call(this, mode, first, count);
    };
  });

  await page.emulateMedia({ reducedMotion: "reduce" });

  await page.goto("/");

  await expect.poll(() => graphicsDrawCount(page)).toBeGreaterThan(0);

  await page.waitForTimeout(200);

  const staticCount = await graphicsDrawCount(page);

  await page.waitForTimeout(300);

  await expect.poll(() => graphicsDrawCount(page)).toBe(staticCount);

  await page.emulateMedia({ reducedMotion: "no-preference" });

  await expect
    .poll(() => graphicsDrawCount(page))
    .toBeGreaterThan(staticCount + 2);

  await page.emulateMedia({ reducedMotion: "reduce" });

  await page.waitForTimeout(200);

  const changedCount = await graphicsDrawCount(page);

  await page.waitForTimeout(300);

  await expect.poll(() => graphicsDrawCount(page)).toBe(changedCount);

  await page.emulateMedia({ reducedMotion: "no-preference" });

  await page.evaluate(() => {
    Object.defineProperty(document, "hidden", {
      configurable: true,
      value: true,
    });

    document.dispatchEvent(new Event("visibilitychange"));
  });

  const hiddenCount = await graphicsDrawCount(page);

  await page.waitForTimeout(300);

  await expect.poll(() => graphicsDrawCount(page)).toBe(hiddenCount);

  await page.evaluate(() => {
    Object.defineProperty(document, "hidden", {
      configurable: true,
      value: false,
    });

    document.dispatchEvent(new Event("visibilitychange"));
  });

  await expect
    .poll(() => graphicsDrawCount(page))
    .toBeGreaterThan(hiddenCount + 2);

  await page.getByRole("button", { name: "Unmount surface" }).click();

  await expect(page.locator("canvas")).toHaveCount(0);

  const stoppedCount = await graphicsDrawCount(page);

  await page.waitForTimeout(300);

  await expect.poll(() => graphicsDrawCount(page)).toBe(stoppedCount);

  await page.getByRole("button", { name: "Mount surface" }).click();

  await expect(page.locator("canvas")).toHaveCount(1);

  await expect
    .poll(() => graphicsDrawCount(page))
    .toBeGreaterThan(stoppedCount + 2);
});

test("WebGL unavailability preserves the static background and children", async ({
  page,
}) => {
  await page.addInitScript(() => {
    HTMLCanvasElement.prototype.getContext = () => null;
  });

  await page.goto("/");

  await expect(page.getByRole("heading")).toBeVisible();

  await page.getByRole("textbox").fill("Still usable");

  await expect(page.getByRole("textbox")).toHaveValue("Still usable");

  const fallback = await page
    .locator("[aria-hidden=true]")
    .evaluate((element) => getComputedStyle(element).backgroundImage);

  expect(fallback).toContain("gradient");
});

test("context loss keeps fallback and the graphics buffer has a fixed ceiling", async ({
  page,
}) => {
  await page.setViewportSize({ width: 3840, height: 2160 });

  await page.goto("/");

  await expect(page.locator("canvas")).toBeVisible();

  const dimensions = await page
    .locator("canvas")
    .evaluate((canvas: HTMLCanvasElement) => ({
      width: canvas.width,
      height: canvas.height,
    }));

  expect(dimensions.width * dimensions.height).toBeLessThanOrEqual(2073600);
  expect(dimensions.width).toBeGreaterThan(1000);

  await page.locator("canvas").evaluate((canvas: HTMLCanvasElement) => {
    canvas
      .getContext("webgl2")
      ?.getExtension("WEBGL_lose_context")
      ?.loseContext();
  });

  await expect(page.locator("canvas")).toBeHidden();

  await expect(page.getByRole("heading")).toBeVisible();

  await page.getByRole("textbox").fill("After context loss");

  await expect(page.getByRole("textbox")).toHaveValue("After context loss");
});

test("surface changes continuously and yields desktop and mobile review frames", async ({
  page,
}, testInfo) => {
  await page.goto("/");

  await expect(page.locator("canvas")).toBeVisible();

  await page.waitForTimeout(300);

  const first = await page.screenshot({
    path: testInfo.outputPath("desktop-0.png"),
  });

  await page.waitForTimeout(2200);

  const second = await page.screenshot({
    path: testInfo.outputPath("desktop-2.png"),
  });

  expect(first.equals(second), "the rendered background must animate").toBe(
    false,
  );

  await page.waitForTimeout(2200);

  await page.screenshot({ path: testInfo.outputPath("desktop-4.png") });

  await page.setViewportSize({ width: 390, height: 844 });

  await page.waitForTimeout(300);

  await page.screenshot({ path: testInfo.outputPath("mobile.png") });
});
