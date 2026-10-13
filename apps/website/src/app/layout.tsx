import "@app/globals.css";

import { ExphereShader } from "@repo/web/react/exphere-shader";
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
      <body className="min-h-screen bg-background font-body text-foreground">
        <ExphereShader palette={shaderPalette}>{children}</ExphereShader>
      </body>
    </html>
  );
}
