import "@app/globals.css";

import type { Metadata, Viewport } from "next";
import { Head } from "nextra/components";
import type { ReactNode } from "react";

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
  colorScheme: "dark",
  themeColor: "#0a0a0a",
};

interface RootLayoutProps {
  children: ReactNode;
}

export default function RootLayout(props: RootLayoutProps) {
  const { children } = props;

  return (
    <html
      lang="en-US"
      dir="ltr"
      className="dark"
      data-theme="dark"
      suppressHydrationWarning
    >
      <Head
        backgroundColor={{ dark: "#0a0a0a", light: "#0a0a0a" }}
        color={{ hue: 266, saturation: 100, lightness: 76 }}
      />
      <body className="min-h-screen supports-[height:100dvh]:min-h-dvh bg-background font-body text-foreground">
        {children}
      </body>
    </html>
  );
}
