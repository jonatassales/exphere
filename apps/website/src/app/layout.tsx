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
  colorScheme: "dark",
  themeColor: "#0a0a0a",
};

// Purple-on-black website motion; shared shader defaults stay unchanged.
const shaderPalette = {
  primary: "#36135a",
  primaryHover: "#6d0ad6",
  background: "#0a0a0a",
  surface: "#121212",
} as const;

interface RootLayoutProps {
  children: ReactNode;
}

export default function RootLayout(props: RootLayoutProps) {
  const { children } = props;

  return (
    <html lang="en-US" data-theme="dark">
      <body className="min-h-screen bg-background font-body text-foreground">
        <ExphereShader palette={shaderPalette}>{children}</ExphereShader>
      </body>
    </html>
  );
}
