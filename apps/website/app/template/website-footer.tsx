import { OrboPreview } from "@app/template/orbo-preview";

export function WebsiteFooter() {
  return (
    <footer className="flex w-full items-center justify-center gap-2 self-end text-center text-xs text-site-body">
      <OrboPreview appearance="black-hole" />
      <span>Neongate © 2026</span>
    </footer>
  );
}
