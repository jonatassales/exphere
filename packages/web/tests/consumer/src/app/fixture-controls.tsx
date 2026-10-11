"use client";

import { type ReactNode, useState } from "react";

interface FixtureControlsProps {
  children: ReactNode;
}

export function FixtureControls(props: FixtureControlsProps) {
  const { children } = props;

  const [mounted, setMounted] = useState(true);

  return (
    <>
      <button
        className="fixed left-2 bottom-2 z-50"
        type="button"
        onClick={() => setMounted(!mounted)}
      >
        {mounted ? "Unmount surface" : "Mount surface"}
      </button>
      {mounted ? children : null}
    </>
  );
}
