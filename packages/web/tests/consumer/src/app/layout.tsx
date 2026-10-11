import type { ReactNode } from "react";

import "./fixture.css";

interface LayoutProps {
  children: ReactNode;
}

export default function Layout(props: LayoutProps) {
  const { children } = props;

  return (
    <html lang="en">
      <body className="m-0 font-sans">{children}</body>
    </html>
  );
}
