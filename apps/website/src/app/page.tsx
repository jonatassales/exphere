import type { Metadata } from "next";
// import Image from "next/image";

const description =
  "Exphere is an experimental project exploring developer experience, agent-assisted delivery, and consumer-composed microruntimes.";

export const metadata: Metadata = {
  title: "Exphere",
  description,
  openGraph: {
    type: "website",
    siteName: "Exphere",
    title: "Exphere",
    description,
    locale: "en_US",
    // An empty list prevents file metadata from choosing a preview origin.
    images: [],
  },
  twitter: {
    card: "summary",
    title: "Exphere",
    description,
    images: [],
  },
};

export default function WebsitePage() {
  return (
    <main className="relative mx-auto flex min-h-screen w-full max-w-[1280px] flex-col px-6 py-7 text-black sm:px-10 lg:px-14">
      <header className="flex flex-wrap items-center justify-between gap-4 border-b border-black/15 pb-5">
        <span className="text-xl font-bold tracking-[-0.065em]">
          exphere
        </span>
        <span className="font-mono text-[11px] uppercase tracking-[0.14em] text-neutral-700">
          Agentic software factory / experimental
        </span>
      </header>

      <section
        aria-labelledby="hero-heading"
        className="grid flex-1 items-center gap-8 py-14 lg:grid-cols-2 lg:gap-12 lg:py-24"
      >
        <div className="rounded-xl border border-black/10 bg-white/75 p-7 sm:p-10 lg:p-12">
          <p className="mb-6 font-mono text-xs font-semibold uppercase tracking-[0.17em] text-neutral-700">
            Developer experience / microruntimes
          </p>
          <h1
            id="hero-heading"
            className="max-w-[650px] text-[clamp(2.75rem,5vw,4.5rem)] font-bold leading-[1.06] tracking-[-0.055em]"
          >
            From intent to runtime.
          </h1>
          <p className="mt-7 max-w-[560px] text-base leading-7 text-neutral-800 sm:text-lg sm:leading-8">
            Exphere explores developer experience, agent-assisted software
            delivery, and consumer-composed microruntimes.
          </p>
          <p className="mt-3 max-w-[520px] text-sm leading-6 text-neutral-700">
            Early-stage tools and specifications, not a production automation
            service.
          </p>
          <div className="mt-9 flex flex-wrap items-center gap-5">
            <a
              className="inline-flex min-h-11 items-center justify-center gap-4 rounded-lg bg-black px-6 py-3 text-sm font-semibold text-white transition-colors hover:bg-neutral-800 focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-black"
              href="https://github.com/jonatassales/exphere#readme"
              rel="noopener noreferrer"
              target="_blank"
            >
              Read documentation
              <span aria-hidden="true">↗</span>
              <span className="sr-only"> (opens in a new tab)</span>
            </a>
            <span className="font-mono text-[11px] uppercase tracking-[0.12em] text-neutral-700">
              Hosted in the repository
            </span>
          </div>
        </div>

        <aside
          aria-label="Exphere CLI example"
          className="overflow-hidden rounded-xl border border-black/15 bg-white/85"
        >
          <div className="flex items-center justify-between gap-3 border-b border-black/10 px-6 py-4">
            <span className="font-mono text-xs font-semibold text-black">
              exphere / cli
            </span>
            <span className="font-mono text-[11px] uppercase tracking-[0.12em] text-neutral-600">
              Local
            </span>
          </div>
          <div className="space-y-8 px-6 py-8 sm:px-8 sm:py-10">
            <div>
              <p className="font-mono text-[11px] uppercase tracking-[0.13em] text-neutral-700">
                01 / List runtime configurations
              </p>
              <pre className="mt-3 overflow-x-auto rounded-lg border border-black/10 bg-neutral-100 px-4 py-4 font-mono text-sm leading-6 text-black">
                <code>
                  <span aria-hidden="true" className="select-none text-neutral-500">
                    {"$ "}
                  </span>
                  pnpm ex runtime list
                </code>
              </pre>
            </div>
            <div>
              <p className="font-mono text-[11px] uppercase tracking-[0.13em] text-neutral-700">
                02 / Create a runtime descriptor
              </p>
              <pre className="mt-3 overflow-x-auto rounded-lg border border-black/10 bg-neutral-100 px-4 py-4 font-mono text-sm leading-6 text-black">
                <code>
                  <span aria-hidden="true" className="select-none text-neutral-500">
                    {"$ "}
                  </span>
                  pnpm ex runtime billing init
                </code>
              </pre>
            </div>
          </div>
          <div className="border-t border-black/10 px-6 py-4 font-mono text-[11px] uppercase tracking-[0.12em] text-neutral-700">
            A local workflow · no deployment implied
          </div>
        </aside>
      </section>

      <footer className="flex flex-wrap justify-between gap-3 border-t border-black/15 pt-5 font-mono text-[11px] uppercase tracking-[0.12em] text-neutral-700">
        <span>Exphere / experimental</span>
        <span>Developer experience · agent-assisted delivery</span>
      </footer>

      {/* The supplied home SVG logo remains disabled by WEB-ID-02. */}
      {/* <h1 className="w-fit max-w-full">
        <Image
          alt="Exphere"
          className="h-auto w-48 max-w-full sm:w-56"
          height={128}
          loading="eager"
          src="/brand/exphere-logo.svg"
          unoptimized
          width={551}
        />
      </h1> */}
    </main>
  );
}
