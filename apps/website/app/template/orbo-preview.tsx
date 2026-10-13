"use client";

import "orbo-voice/react-types";
import { useEffect } from "react";

interface OrboPreviewProps {
  size?: "1.5rem" | "2rem";
  appearance?: "star" | "black-hole";
}

const palettes = {
  star: {
    primary: "#F8FAFF",
    secondary: "#BDEBFF",
    accent: "#D8C4FF",
    highlight: "#FFFFFF",
    background: "#0a0a0a",
  },
  "black-hole": {
    primary: "#111111",
    secondary: "#242424",
    accent: "#333333",
    highlight: "#666666",
    background: "#0a0a0a",
  },
} as const;

export function OrboPreview(props: OrboPreviewProps) {
  const { size = "1.5rem", appearance = "black-hole" } = props;

  const palette = palettes[appearance];

  useEffect(() => {
    void import("orbo-voice/browser").catch(() => {
      console.error("The decorative Orbo preview could not load.");
    });
  }, []);

  return (
    <span
      aria-hidden="true"
      className="inline-flex size-6 translate-y-[2px] shrink-0 items-center justify-center data-[size='2rem']:size-8 data-[appearance=star]:drop-shadow-[0_0_20px_rgba(210,235,255,0.5)]"
      data-appearance={appearance}
      data-size={size}
    >
      <orb-o
        color-accent={palette.accent}
        color-background={palette.background}
        color-highlight={palette.highlight}
        color-primary={palette.primary}
        color-secondary={palette.secondary}
        reduced-motion="system"
        size={size}
        state="listening"
      />
    </span>
  );
}
