import { fragmentSource, vertexSource } from "./shaders.js";

type Color = [number, number, number];

function readColor(styles: CSSStyleDeclaration, role: string): Color | null {
  const value = styles.getPropertyValue(`--design-color-${role}`).trim();

  if (!/^#[0-9a-f]{6}$/i.test(value)) {
    return null;
  }

  return [
    Number.parseInt(value.slice(1, 3), 16) / 255,
    Number.parseInt(value.slice(3, 5), 16) / 255,
    Number.parseInt(value.slice(5, 7), 16) / 255,
  ];
}

function compileShader(
  gl: WebGL2RenderingContext,
  type: number,
  source: string,
) {
  const shader = gl.createShader(type);

  if (!shader) {
    return null;
  }

  gl.shaderSource(shader, source);
  gl.compileShader(shader);

  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
    gl.deleteShader(shader);

    return null;
  }

  return shader;
}

function createProgram(gl: WebGL2RenderingContext) {
  const vertex = compileShader(gl, gl.VERTEX_SHADER, vertexSource);
  const fragment = compileShader(gl, gl.FRAGMENT_SHADER, fragmentSource);
  const program = gl.createProgram();

  if (!vertex || !fragment || !program) {
    gl.deleteShader(vertex);
    gl.deleteShader(fragment);
    gl.deleteProgram(program);

    return null;
  }

  gl.attachShader(program, vertex);
  gl.attachShader(program, fragment);
  gl.linkProgram(program);
  gl.deleteShader(vertex);
  gl.deleteShader(fragment);

  if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
    gl.deleteProgram(program);

    return null;
  }

  return program;
}

export function mountSurface(canvas: HTMLCanvasElement) {
  const styles = getComputedStyle(canvas);
  const primary = readColor(styles, "primary");
  const primaryHover = readColor(styles, "primary-hover");
  const background = readColor(styles, "background");
  const surface = readColor(styles, "surface");

  if (!primary || !primaryHover || !background || !surface) {
    return;
  }

  const context = canvas.getContext("webgl2", {
    alpha: true,
    antialias: false,
    depth: false,
    stencil: false,
    powerPreference: "low-power",
  });

  if (!context) {
    return;
  }

  const gl: WebGL2RenderingContext = context;
  const program = createProgram(gl);

  if (!program) {
    return;
  }

  // biome-ignore lint/correctness/useHookAtTopLevel: WebGL program binding is not a React hook.
  gl.useProgram(program);
  gl.uniform3fv(gl.getUniformLocation(program, "primary"), primary);
  gl.uniform3fv(gl.getUniformLocation(program, "primaryHover"), primaryHover);
  gl.uniform3fv(gl.getUniformLocation(program, "background"), background);
  gl.uniform3fv(gl.getUniformLocation(program, "surface"), surface);
  const resolution = gl.getUniformLocation(program, "resolution");
  const elapsed = gl.getUniformLocation(program, "elapsed");
  const motionPreference = matchMedia("(prefers-reduced-motion: reduce)");
  let frame = 0;
  let previousTime: number | null = null;
  let activeTime = 0;
  let visible = true;
  let failed = false;
  let disposed = false;
  let hasSize = false;

  function stop() {
    cancelAnimationFrame(frame);
    frame = 0;
    previousTime = null;
  }

  function canAnimate() {
    return (
      !disposed &&
      !failed &&
      hasSize &&
      visible &&
      !document.hidden &&
      !motionPreference.matches
    );
  }

  function draw() {
    if (disposed || failed || !hasSize) {
      return;
    }

    gl.uniform1f(elapsed, activeTime);
    gl.drawArrays(gl.TRIANGLES, 0, 3);
  }

  function animate(timestamp: number) {
    frame = 0;

    if (!canAnimate()) {
      previousTime = null;

      return;
    }

    if (previousTime !== null) {
      activeTime += Math.min((timestamp - previousTime) / 1000, 0.05);
    }

    previousTime = timestamp;
    draw();
    frame = requestAnimationFrame(animate);
  }

  function reconcile() {
    stop();

    if (canAnimate()) {
      frame = requestAnimationFrame(animate);

      return;
    }

    if (!document.hidden && visible) {
      draw();
    }
  }

  function resize() {
    if (disposed || failed) {
      return;
    }

    const bounds = canvas.getBoundingClientRect();
    hasSize = bounds.width > 0 && bounds.height > 0;

    if (!hasSize) {
      stop();

      return;
    }

    const pixelRatio = Math.min(window.devicePixelRatio || 1, 2);
    const scale = Math.min(
      pixelRatio,
      Math.sqrt(2073600 / (bounds.width * bounds.height)),
    );
    canvas.width = Math.max(1, Math.floor(bounds.width * scale));
    canvas.height = Math.max(1, Math.floor(bounds.height * scale));
    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.uniform2f(resolution, canvas.width, canvas.height);
    draw();
    reconcile();
  }

  function contextLost(event: Event) {
    event.preventDefault();
    failed = true;
    stop();
    canvas.dataset.unavailable = "";
  }

  const resizeObserver = new ResizeObserver(resize);
  const intersectionObserver = new IntersectionObserver(([entry]) => {
    visible = entry?.isIntersecting ?? false;
    reconcile();
  });
  delete canvas.dataset.unavailable;
  resizeObserver.observe(canvas);
  intersectionObserver.observe(canvas);
  motionPreference.addEventListener("change", reconcile);
  document.addEventListener("visibilitychange", reconcile);
  window.addEventListener("resize", resize);
  canvas.addEventListener("webglcontextlost", contextLost);
  resize();

  return () => {
    disposed = true;
    stop();
    resizeObserver.disconnect();
    intersectionObserver.disconnect();
    motionPreference.removeEventListener("change", reconcile);
    document.removeEventListener("visibilitychange", reconcile);
    window.removeEventListener("resize", resize);
    canvas.removeEventListener("webglcontextlost", contextLost);
    gl.deleteProgram(program);
    gl.clearColor(0, 0, 0, 0);
    gl.clear(gl.COLOR_BUFFER_BIT);
    canvas.width = 1;
    canvas.height = 1;
  };
}
