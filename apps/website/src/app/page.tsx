import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Exphere",
};

export default function WebsitePage() {
  return (
    <main className="p-content">
      <h1 className="text-2xl font-semibold">Exphere</h1>
    </main>
  );
}
