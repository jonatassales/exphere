import { OrboPreview } from "@app/template/orbo-preview";
import { WebsiteFooter } from "@app/template/website-footer";
import { Search } from "nextra/components";
import { getPageMap } from "nextra/page-map";
import { Layout, Navbar } from "nextra-theme-docs";
import type { ReactNode } from "react";

interface DocsLayoutProps {
  children: ReactNode;
}

export default async function DocsLayout(props: DocsLayoutProps) {
  const { children } = props;

  const pageMap = await getPageMap();

  return (
    <Layout
      copyPageButton={false}
      darkMode={false}
      editLink={null}
      feedback={{ content: null }}
      footer={
        <div className="mx-auto w-full max-w-[1440px] border-t border-site-border px-6 py-8 sm:px-10">
          <WebsiteFooter />
        </div>
      }
      navbar={
        <Navbar
          logo={
            <span className="inline-flex items-center gap-2 text-xl font-bold tracking-[-0.065em] [&>span]:translate-y-0.5">
              <OrboPreview />
              exphere
            </span>
          }
          logoLink="/"
          projectLink="https://github.com/jonatassales/exphere"
        />
      }
      nextThemes={{ defaultTheme: "dark", forcedTheme: "dark" }}
      pageMap={pageMap}
      search={
        <Search aria-label="Search documentation" placeholder="Search docs…" />
      }
      toc={{ title: "On this page" }}
      sidebar={{ defaultMenuCollapseLevel: 2 }}
    >
      {children}
    </Layout>
  );
}
