# Website identity

The owner supplied `exphere-identity-seo(1).zip` on October 13, 2026 and selected the ClickHouse design-system analysis as the website design reference. This integration preserves the supplied Exphere geometry but supersedes the earlier purple/graphite website identity with a monochrome black identity.

## Direction and source

- Source archive SHA-256: `c1a0bd65799cbcd77dbf63371984f39ea5e551d423a1d86e9b9e6d414ded61ad`.
- Design reference: `https://getdesign.md/clickhouse/design-md`.
- Local adaptation: [DESIGN.md](DESIGN.md), governed by `ADR-0002`.
- Owner override: all Exphere branding is black. ClickHouse yellow and ClickHouse marks are not used.
- The current home logo remains commented out under SPEC-WEBSITE-HOME-LOGO-VISIBILITY; changing the underlying asset does not restore it.

`public/brand/exphere-logo.svg` preserves the pack's horizontal-logo geometry while changing both the mark and outlined wordmark to `#000000`. `src/app/icon.svg` preserves the mark geometry on a white rounded canvas. No font files, external SVG references, runtime image generator, or JavaScript are required by these identity assets.

## Browser and application assets

| Destination | Size/frames | Treatment |
| --- | --- | --- |
| `src/app/favicon.ico` | 16/32/48/64/128/256 export set | Black mark on white rounded canvas. |
| `src/app/icon1.png` | 96×96 | Black mark on white rounded canvas. |
| `src/app/apple-icon.png` | 180×180 opaque | Black mark on white square canvas. |
| `public/icons/app-192.png` | 192×192 | Black mark on white square canvas. |
| `public/icons/app-512.png` | 512×512 | Black mark on white square canvas. |
| `public/icons/maskable-512.png` | 512×512 | Black mark inside a 64px safe margin on white; essential geometry remains inside the maskable safe region. |

The existing manifest paths and browser-display semantics are unchanged. White is a presentation background; the Exphere identity itself remains black. Raster antialiasing may contain neutral gray values, but validation found no chromatic pixels in the generated PNG assets.

## Social SEO artwork

`src/app/opengraph-image.png` is 1200×630 and `twitter-image.png` is 1200×600. They are regenerated from the supplied vector social compositions with:

- white canvas;
- black Exphere mark and wordmark;
- black outlined positioning text;
- black technical/orbit line work at neutral opacity;
- no purple, yellow, gradients, shadows, glow, or chromatic pixels.

The visual language follows the selected reference's flat technical treatment while remaining Exphere-specific. Alt sidecars describe the visible black identity and positioning text. Existing metadata keeps these files inactive as remote sharing URLs until a production origin is accepted; this asset refresh does not change that launch decision.

## Asset checksums

- `public/brand/exphere-logo.svg`: `0b8f4664b99023004bb89fab930e7688c6e28e3d173264c71db8b65effaafb95`
- `src/app/icon.svg`: `f3c3f60bb731efbfa5c95c921c11c89816bb2024ce274d6f299dc7584e2e2260`
- `src/app/favicon.ico`: `4daaec06aadf42be7c4412d9933213f2e467ca97151b1a43a3d77f0bf31c8dea`
- `src/app/icon1.png`: `6d66ee8808a24ac86b1bce93af1fd42ad55caf9230269c736e08b9b1f53ae45c`
- `src/app/apple-icon.png`: `7d34e17831da2f792eb42f6aec7166bba92f91125b7bf97a4f1f92e7d073ed00`
- `public/icons/app-192.png`: `4c6d36a1fee333fc2f2b95837f93f521e5da0858abfd52afe0f1441be806506b`
- `public/icons/app-512.png`: `f7f4ce056586b483754205ca603e15a84d8cd2f7560a436c526c93c1a201dd77`
- `public/icons/maskable-512.png`: `f7f4ce056586b483754205ca603e15a84d8cd2f7560a436c526c93c1a201dd77`
- `src/app/opengraph-image.png`: `30026c5841025895d9a23de7c1bf265fca845c35cb3d2ec5911a9a709581a569`
- `src/app/twitter-image.png`: `e0c9475a5b200d2661d37fe67234322e035f69b658390b5f8f067c67ece76883`

## Validation boundary

Static validation covers source geometry/color replacement, raster decoding, dimensions, grayscale-only output, and asset references. It does not prove browser rendering, Next.js metadata resolution, deployment, search indexing, or Core Web Vitals. Those remain separate verification/launch concerns.
