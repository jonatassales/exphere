import { ExphereShader } from "@repo/web/react/exphere-shader";
import type { Metadata, Viewport } from "next";
import type { ReactNode } from "react";

import "@app/globals.css";

export const metadata: Metadata = {
  applicationName: "Exphere",
  metadataBase: null,
  title: "Exphere",
  robots: { index: false, follow: true },
  // Keep file-based social assets inactive until a public origin is accepted.
  openGraph: { images: [] },
  twitter: { images: [] },
};

export const viewport: Viewport = {
  colorScheme: "light",
  themeColor: "#FFFFFF",
};

interface RootLayoutProps {
  children: ReactNode;
}

export default function RootLayout(props: RootLayoutProps) {
  const { children } = props;

  return (
    <html lang="en-US" data-theme="light">
      <body className="min-h-screen bg-background font-body text-foreground">
        <ExphereShader>{children}</ExphereShader>
      </body>
    </html>
  );
}
