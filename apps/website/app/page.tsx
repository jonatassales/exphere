import { CopyCommand } from "@app/template/copy-command";
import { OrboPreview } from "@app/template/orbo-preview";
import { WebsiteFooter } from "@app/template/website-footer";
import { ExphereShader } from "@repo/web/react/exphere-shader";
import type { Metadata } from "next";
import Link from "next/link";

const description =
  "Exphere explores FinOps principles, agent-assisted software delivery, and consumer-composed microruntimes.";

export const metadata: Metadata = {
  title: "Exphere - Full blast agentic FinOps runtimes",
  description,
  openGraph: {
    type: "website",
    siteName: "Exphere",
    title: "Exphere - Full blast agentic FinOps runtimes",
    description,
    locale: "en_US",
    // An empty list prevents file metadata from choosing a preview origin.
    images: [],
  },
  twitter: {
    card: "summary",
    title: "Exphere - Full blast agentic FinOps runtimes",
    description,
    images: [],
  },
};

const shaderPalette = {
  primary: "#36135a",
  primaryHover: "#6d0ad6",
  background: "#0a0a0a",
  surface: "#121212",
} as const;

export default function WebsitePage() {
  return (
    <ExphereShader palette={shaderPalette}>
      <main className="relative mx-auto grid h-screen supports-[height:100dvh]:h-dvh w-full max-w-7xl grid-rows-[minmax(0,1fr)_auto_minmax(0,1fr)] overflow-hidden p-4 text-site-ink sm:px-10 [@media(max-height:600px)]:py-2">
        <header className="flex items-center justify-between gap-2 self-start">
          <span className="inline-flex items-center gap-2 text-xl font-bold tracking-[-0.065em]">
            <OrboPreview appearance="star" />
            exphere
          </span>
          <div className="flex">
            <Link
              className="inline-flex min-h-11 items-center rounded-md font-mono text-base font-bold text-site-body hover:text-site-ink focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-white mr-4"
              href="/docs"
            >
              Docs
            </Link>
            <nav aria-label="Social links" className="flex items-center">
              <a
                className="inline-flex size-11 items-center justify-center rounded-md focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-white"
                href="https://github.com/jonatassales"
              >
                <span className="sr-only">Jonatas Sales on GitHub</span>
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
                className="inline-flex size-11 items-center justify-center rounded-md focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-white"
                href="https://www.linkedin.com/company/exphere"
              >
                <span className="sr-only">Exphere on LinkedIn</span>
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
          </div>
        </header>
        <section
          aria-labelledby="hero-heading"
          className="min-w-0 w-full text-center sm:px-12 lg:px-14"
        >
          <p className="mb-5 [@media(max-height:600px)]:mb-2 font-mono text-xs font-semibold tracking-[0.17em] text-site-accent-readable">
            Agentic FinOps Platform
          </p>
          <h1
            id="hero-heading"
            className="text-balance text-[clamp(2rem,5vw,4.5rem)] [@media(max-height:600px)]:text-[clamp(1.5rem,4vw,2.5rem)] font-bold leading-[1.06] tracking-[-0.055em]"
          >
            Exphere - Full blast agentic{" "}
            <span className="text-site-accent-readable">FinOps runtimes</span>
          </h1>
          <p className="mx-auto mt-6 [@media(max-height:600px)]:mt-3 [@media(max-height:500px)]:hidden max-w-162.5 text-base leading-7 text-site-body sm:text-lg sm:leading-8">
            {description}
          </p>
          <CopyCommand />
        </section>
        <WebsiteFooter />
      </main>
    </ExphereShader>
  );
}
