import { ExphereShader } from "@repo/web/react/exphere-shader";

import { FixtureControls } from "./fixture-controls";

interface PageProps {
  searchParams: Promise<{
    plain?: string;
    long?: string;
    empty?: string;
    dark?: string;
  }>;
}

const darkPalette = {
  primary: "#303030",
  primaryHover: "#484848",
  background: "#0a0a0a",
  surface: "#121212",
} as const;

export default async function Page(props: PageProps) {
  const { searchParams } = props;

  const params = await searchParams;

  const content = params.empty ? null : (
    <main className={params.long ? "min-h-[2200px] p-8" : "p-8"}>
      <header className="flex items-center justify-between">
        <strong>Exphere</strong>
        <a href="#content">Explore</a>
      </header>
      <section className="mx-auto max-w-3xl pt-36 text-center" id="content">
        <h1 className="text-5xl font-medium tracking-tight">
          Build what comes next.
        </h1>
        <p className="text-lg">Your ideas. A little more possibility.</p>
        <label>
          Project name <input aria-label="Project name" />
        </label>
        <button type="button">Create project</button>
      </section>
      <aside className="fixed bottom-4 right-4">Fixed content</aside>
      <aside className="sticky top-0">Sticky content</aside>
    </main>
  );

  if (params.plain) {
    return content;
  }

  return (
    <FixtureControls>
      <ExphereShader palette={params.dark ? darkPalette : undefined}>
        {content}
      </ExphereShader>
    </FixtureControls>
  );
}
