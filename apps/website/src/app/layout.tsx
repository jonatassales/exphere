import type { ReactNode } from "react";

import "@app/globals.css";

interface RootLayoutProps {
  children: ReactNode;
}

export default function RootLayout(props: RootLayoutProps) {
  const { children } = props;

  return (
    <html lang="en-US" data-theme="light">
      <body className="min-h-screen bg-background font-body text-foreground">
        {children}
      </body>
    </html>
  );
}
