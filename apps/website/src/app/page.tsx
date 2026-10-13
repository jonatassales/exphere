import { CopyCommand } from "@app/template/copy-command";
import { OrboPreview } from "@app/template/orbo-preview";
import { WebsiteFooter } from "@app/template/website-footer";
import type { Metadata } from "next";
import Link from "next/link";

// import Image from "next/image";

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

export default function WebsitePage() {
  return (
    <main className="relative mx-auto flex min-h-screen w-full max-w-[1280px] flex-col px-6 py-7 text-site-ink sm:px-10 lg:px-14">
      <header className="flex flex-wrap items-center justify-between gap-4 border-b border-site-border pb-5 lg:pb-3">
        <span className="inline-flex items-center gap-2 text-xl font-bold tracking-[-0.065em] [&>span]:translate-y-0.5">
          <OrboPreview />
          exphere
        </span>
        <Link
          className="inline-flex min-h-11 items-center rounded-md font-mono text-[11px] uppercase tracking-[0.14em] text-site-body hover:text-site-ink focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-white lg:min-h-8"
          href="/docs"
        >
          Documentation
        </Link>
      </header>

      <section
        aria-labelledby="hero-heading"
        className="flex flex-1 items-center justify-center py-14 lg:py-24"
      >
        <div className="w-full max-w-[900px] rounded-xl border border-site-border bg-site-soft/85 px-6 py-10 text-center sm:p-12 lg:origin-top lg:scale-50 lg:px-16 lg:py-16">
          <p className="mb-6 font-mono text-xs font-semibold uppercase tracking-[0.17em] text-site-accent-readable">
            DevEX / FinOps Platform
          </p>
          <h1
            id="hero-heading"
            className="text-balance text-[clamp(2.25rem,5vw,4.5rem)] font-bold leading-[1.06] tracking-[-0.055em]"
          >
            Exphere - Full blast agentic{" "}
            <span className="text-site-accent-readable">FinOps runtimes</span>
          </h1>
          <p className="mx-auto mt-7 max-w-[650px] text-base leading-7 text-site-body sm:text-lg sm:leading-8">
            {description}
          </p>
          <CopyCommand />
        </div>
      </section>

      <WebsiteFooter />

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
