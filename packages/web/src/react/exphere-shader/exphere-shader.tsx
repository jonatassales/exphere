"use client";

import { type CSSProperties, type ReactNode, useEffect, useRef } from "react";

import "@repo/design/tokens.css";
import "./exphere-shader.css";

import { mountSurface } from "./surface.js";

export interface ExphereShaderPalette {
  primary: string;
  primaryHover: string;
  background: string;
  surface: string;
}

interface ShaderPaletteStyle extends CSSProperties {
  "--design-color-primary": string;
  "--design-color-primary-hover": string;
  "--design-color-background": string;
  "--design-color-surface": string;
}

interface ExphereShaderProps {
  children: ReactNode;
  palette?: ExphereShaderPalette;
}

export function ExphereShader(props: ExphereShaderProps) {
  const { children, palette } = props;

  const canvasRef = useRef<HTMLCanvasElement>(null);
  const paletteStyle: ShaderPaletteStyle | undefined = palette
    ? {
        "--design-color-primary": palette.primary,
        "--design-color-primary-hover": palette.primaryHover,
        "--design-color-background": palette.background,
        "--design-color-surface": palette.surface,
      }
    : undefined;

  // biome-ignore lint/correctness/useExhaustiveDependencies: mountSurface reads the palette CSS variables from the DOM after React applies these styles.
  useEffect(() => {
    const canvas = canvasRef.current;

    if (!canvas) {
      return;
    }

    return mountSurface(canvas);
  }, [
    palette?.background,
    palette?.primary,
    palette?.primaryHover,
    palette?.surface,
  ]);

  return (
    <div className="ex:isolate">
      <div
        aria-hidden="true"
        data-theme={palette ? undefined : "light"}
        style={paletteStyle}
        className="ex:pointer-events-none ex:fixed ex:inset-0 ex:-z-10 ex:overflow-hidden ex:bg-[var(--design-color-background)] ex:bg-[radial-gradient(ellipse_at_72%_28%,color-mix(in_srgb,var(--design-color-primary)_24%,var(--design-color-surface)),transparent_60%),linear-gradient(120deg,color-mix(in_srgb,var(--design-color-primary-hover)_18%,var(--design-color-background)),var(--design-color-background)_55%,color-mix(in_srgb,var(--design-color-primary)_22%,var(--design-color-surface)))]"
      >
        <canvas
          ref={canvasRef}
          className="ex:block ex:h-full ex:w-full ex:data-[unavailable]:hidden"
        />
      </div>
      {children}
    </div>
  );
}
