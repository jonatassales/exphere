const command = "npx exphere init";

export function CopyCommand() {
  return (
    <div className="mx-auto mt-7 [@media(max-height:600px)]:mt-3 w-full max-w-90 text-left">
      <div className="flex items-center justify-between gap-2 rounded-lg border border-site-border bg-site-soft px-3 py-1">
        <code className="min-w-0 overflow-x-auto whitespace-nowrap font-mono text-xs text-site-muted">
          {command}
        </code>
        <button
          aria-label="Copy command unavailable"
          className="inline-flex min-h-11 min-w-11 shrink-0 cursor-not-allowed items-center justify-center rounded-md bg-site-elevated text-site-muted opacity-60"
          disabled
          title="Copy unavailable"
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
    </div>
  );
}
