"use client";

import "orbo-voice/react-types";
import { useEffect } from "react";

interface OrboPreviewProps {
  size?: "1.5rem" | "2rem";
}

export function OrboPreview(props: OrboPreviewProps) {
  const { size = "1.5rem" } = props;

  useEffect(() => {
    void import("orbo-voice/browser").catch(() => {
      console.error("The decorative Orbo preview could not load.");
    });
  }, []);

  return (
    <span
      aria-hidden="true"
      className={
        size === "2rem"
          ? "inline-flex size-8 shrink-0 items-center justify-center"
          : "inline-flex size-6 shrink-0 items-center justify-center"
      }
    >
      <orb-o
        color-accent="#333333"
        color-background="#0a0a0a"
        color-highlight="#666666"
        color-primary="#111111"
        color-secondary="#242424"
        reduced-motion="system"
        size={size}
        state="listening"
      />
    </span>
  );
}
