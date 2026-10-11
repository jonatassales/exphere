"use client";

import { type ReactNode, useEffect, useRef } from "react";

import "@repo/design/tokens.css";
import "./exphere-shader.css";

import { mountSurface } from "./surface.js";

interface ExphereShaderProps {
  children: ReactNode;
}

export function ExphereShader(props: ExphereShaderProps) {
  const { children } = props;

  const canvasRef = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    const canvas = canvasRef.current;

    if (!canvas) {
      return;
    }

    return mountSurface(canvas);
  }, []);

  return (
    <div className="ex:isolate">
      <div
        aria-hidden="true"
        data-theme="light"
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
