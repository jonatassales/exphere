import { OrboPreview } from "@app/template/orbo-preview";

export function WebsiteFooter() {
  return (
    <footer className="flex flex-wrap items-center justify-between gap-4 border-t border-site-border py-5 text-xs text-site-body">
      <span className="inline-flex items-center gap-2">
        <OrboPreview size="1.5rem" />
        <span>exphere by Grupo OLX © 2026</span>
      </span>
      <nav aria-label="Social links" className="flex items-center gap-1">
        <a
          className="inline-flex size-11 items-center justify-center rounded-md hover:bg-site-elevated hover:text-site-ink focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-white"
          href="https://github.com/jonatassales/exphere"
        >
          <span className="sr-only">Exphere on GitHub</span>
          <svg
            aria-hidden="true"
            fill="currentColor"
            height="20"
            viewBox="0 0 24 24"
            width="20"
          >
            <path d="M12 .75a11.25 11.25 0 0 0-3.558 21.923c.563.104.768-.244.768-.542 0-.267-.01-.975-.015-1.914-3.13.68-3.79-1.509-3.79-1.509-.513-1.304-1.252-1.65-1.252-1.65-1.023-.7.078-.686.078-.686 1.13.08 1.725 1.16 1.725 1.16 1.005 1.721 2.637 1.224 3.28.936.103-.728.394-1.224.715-1.505-2.499-.284-5.126-1.25-5.126-5.566 0-1.23.44-2.234 1.16-3.022-.117-.285-.503-1.43.11-2.98 0 0 .945-.303 3.095 1.154a10.8 10.8 0 0 1 5.63 0c2.15-1.457 3.093-1.154 3.093-1.154.615 1.55.229 2.695.113 2.98.723.788 1.158 1.792 1.158 3.022 0 4.326-2.631 5.279-5.139 5.557.405.35.766 1.042.766 2.1 0 1.517-.014 2.742-.014 3.115 0 .3.203.65.774.54A11.25 11.25 0 0 0 12 .75Z" />
          </svg>
        </a>
        <a
          className="inline-flex size-11 items-center justify-center rounded-md hover:bg-site-elevated hover:text-site-ink focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-white"
          href="https://www.linkedin.com/company/grupoolx/"
        >
          <span className="sr-only">Grupo OLX on LinkedIn</span>
          <svg
            aria-hidden="true"
            fill="currentColor"
            height="20"
            viewBox="0 0 24 24"
            width="20"
          >
            <path d="M20.447 2H3.553C2.695 2 2 2.677 2 3.512v16.976C2 21.323 2.695 22 3.553 22h16.894C21.305 22 22 21.323 22 20.488V3.512C22 2.677 21.305 2 20.447 2ZM7.93 18.75H4.98V9.205h2.95v9.545ZM6.455 7.9a1.71 1.71 0 1 1 0-3.42 1.71 1.71 0 0 1 0 3.42Zm12.295 10.85H15.8v-4.64c0-1.106-.022-2.53-1.542-2.53-1.543 0-1.78 1.205-1.78 2.45v4.72H9.53V9.205h2.83v1.304h.04c.395-.75 1.356-1.542 2.793-1.542 2.986 0 3.557 1.965 3.557 4.52v5.263Z" />
          </svg>
        </a>
      </nav>
    </footer>
  );
}
