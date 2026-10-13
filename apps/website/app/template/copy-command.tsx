"use client";

import { useState } from "react";

const command = "npx exphere init";

export function CopyCommand() {
  const [status, setStatus] = useState<"idle" | "copying" | "copied" | "error">(
    "idle",
  );

  async function copyCommand() {
    setStatus("copying");

    try {
      await navigator.clipboard.writeText(command);

      setStatus("copied");
    } catch {
      setStatus("error");
    }
  }

  return (
    <div className="mx-auto mt-7 [@media(max-height:600px)]:mt-3 w-full max-w-90 text-left">
      <div className="flex items-center justify-between gap-2 rounded-lg border border-site-border bg-site-canvas px-3 py-1">
        <code className="min-w-0 overflow-x-auto whitespace-nowrap font-mono text-xs text-site-ink">
          {command}
        </code>
        <button
          aria-label="Copy npx exphere init"
          className="inline-flex min-h-11 min-w-11 shrink-0 items-center justify-center rounded-md text-site-body transition-colors hover:bg-site-elevated hover:text-site-ink focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-white disabled:opacity-50"
          disabled={status === "copying"}
          onClick={copyCommand}
          type="button"
        >
          <svg
            aria-hidden="true"
            fill="none"
            height="20"
            stroke="currentColor"
            strokeWidth="1.5"
            viewBox="0 0 24 24"
            width="20"
          >
            <rect height="14" rx="2" width="14" x="8" y="8" />
            <path d="M16 8V4a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h4" />
          </svg>
        </button>
      </div>
      <p
        aria-live="polite"
        className="mt-1 min-h-5 text-center text-xs leading-5 text-site-body"
        role="status"
      >
        {status === "copied" && "Copied to clipboard."}
        {status === "error" &&
          "Could not copy. Select and copy the command above."}
      </p>
    </div>
  );
}
