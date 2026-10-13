# Website identity

The owner supplied the Exphere identity pack on October 12, 2026 and superseded
its purple/graphite color direction on October 13, 2026 by selecting the website
design reference and requiring all Exphere branding to be black.

This is a selected website integration, not a new UI icon library or permission
to expand the page. The app-local visual contract is [DESIGN.md](DESIGN.md).

## Source and adaptation

Source archive: `exphere-identity-seo.zip`, SHA-256
`c1a0bd65799cbcd77dbf63371984f39ea5e551d423a1d86e9b9e6d414ded61ad`.

The rebuilt assets preserve the supplied Exphere geometry while replacing the
pack's purple and graphite foregrounds with pure black `#000000`. White is used
only as a support canvas where browser/application platforms or social cards need
an opaque contrasting background. No ClickHouse yellow is imported.

`public/brand/exphere-logo.svg` derives from the supplied outlined horizontal
wordmark geometry and uses black fills only. `src/app/icon.svg` preserves the
supplied favicon mark geometry as black on white. No font files, font loading,
external SVG references, JavaScript, gradients, or additional logo treatments
are introduced. This record does not assert trademark clearance or change any
third-party font licensing.

## Raster exports

Raster identity is deliberately exported as one-bit black/white artwork so the
repository contains no legacy purple, graphite, yellow, or gray brand palette.

| Destination | Size / frames | Treatment |
| --- | --- | --- |
| `src/app/favicon.ico` | 16x16 and 32x32 | Black mark on white |
| `src/app/icon1.png` | 96x96 | One-bit black/white |
| `src/app/apple-icon.png` | 180x180 | Opaque one-bit black/white |
| `public/icons/app-192.png` | 192x192 | One-bit black/white |
| `public/icons/app-512.png` | 512x512 | One-bit black/white |
| `public/icons/maskable-512.png` | 512x512 | One-bit black/white, original safe-zone composition retained |

The manifest retains browser display semantics and existing same-origin icon
paths. Its support background stays white while `theme_color` is black. This
does not add a service worker, offline behavior, or installability guarantee.

## Social assets

`src/app/opengraph-image.png` and `twitter-image.png` are byte-identical
1200x630 one-bit PNGs: the black horizontal Exphere logo is centered on a white
support canvas. They contain no product capability, launch, customer, or
deployment claim. Alt sidecars describe the black-on-white image.

Image URL activation remains deliberately gated until a production origin is
accepted. Their existence does not make the pre-launch site indexable.

## Asset checksums

These SHA-256 values identify the delivered bytes:

- `public/brand/exphere-logo.svg`: `0b8f4664b99023004bb89fab930e7688c6e28e3d173264c71db8b65effaafb95`
- `src/app/icon.svg`: `258e060603b2ab2072aed4300ca895c220207ff56226b87533170f60f6b03d80`
- `src/app/favicon.ico`: `8d93234a45ef642b322aac261204134f37a362a9ee9e87085b2a04c2ce19982e`
- `src/app/icon1.png`: `6fbcbf33ed4b1c532318655d77aa3241567a0be443bc6ab2e7fa2de6fb54ccda`
- `src/app/apple-icon.png`: `cd469a3911c0393b9208a50009f0dceb9145ac6ec65f5da54be546a3c0a699fa`
- `public/icons/app-192.png`: `2b54d0a6fe6bbb6487d49ac84ae13ced457ffd449f8a5ef4498a9ce42b53bd6f`
- `public/icons/app-512.png`: `5365a04515ddc66675d7e81ea60cd60c2154a658b659e4c2eb6eba8858305211`
- `public/icons/maskable-512.png`: `b9a205533fa51bae213e36c98e90af106556833a9c7d991b1808f356fd34637a`
- `src/app/opengraph-image.png`: `f65871c6762e4fcd186c5c1ad23dc2900f56cead8f0be8dfbee954f782930e0b`
- `src/app/twitter-image.png`: `f65871c6762e4fcd186c5c1ad23dc2900f56cead8f0be8dfbee954f782930e0b`

## SEO boundary

The black-brand rebuild does not change the existing launch gate:
`metadataBase` remains null, the home remains `noindex`, robots remains
crawlable, canonical/sitemap/entity data remain absent, and both Open Graph and
Twitter image lists remain explicitly inactive until an origin is approved.
