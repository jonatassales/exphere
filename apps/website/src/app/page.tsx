import type { Metadata } from "next";
import Image from "next/image";

export const metadata: Metadata = {
  title: "Exphere",
};

export default function WebsitePage() {
  return (
    <main className="p-content">
      <h1 className="w-fit max-w-full">
        <Image
          alt="Exphere"
          className="h-auto w-48 max-w-full sm:w-56"
          height={128}
          loading="eager"
          src="/brand/exphere-logo.svg"
          unoptimized
          width={551}
        />
      </h1>
    </main>
  );
}
