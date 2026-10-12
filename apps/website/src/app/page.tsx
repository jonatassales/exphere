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
    <main className="p-content">
      {/* The home logo is temporarily disabled. */}
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
