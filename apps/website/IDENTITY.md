# Website identity

The owner supplied the Exphere identity pack on October 12, 2026 for the single
home-page logo and website metadata assets. This is a selected integration, not
a new UI icon library or permission to expand the page.

## Source and scope

Source archive: `exphere-identity-seo.zip`, SHA-256
`c1a0bd65799cbcd77dbf63371984f39ea5e551d423a1d86e9b9e6d414ded61ad`.

`public/brand/exphere-logo.svg` is a byte-identical copy of the pack's
`brand/svg/logo-horizontal-light.svg`. Its purple symbol and graphite wordmark
are preserved as paths. `src/app/icon.svg` is the supplied `favicons/favicon.svg`.
No font files, font loading, external SVG references, or JavaScript are required
by these assets. The pack credits the outlined wordmark to Inter Display; it
identifies the Exphere mark and composition as newly authored artwork. This
record does not assert trademark clearance or change third-party font licensing.

## Raster exports

| Destination | Pack source | Encoding |
| --- | --- | --- |
| `src/app/favicon.ico` | `favicons/favicon.ico` | Original 16/32px pixels in PNG-compressed ICO frames |
| `src/app/icon1.png` | `favicons/favicon-96x96.png` | Lossless indexed PNG |
| `src/app/apple-icon.png` | `favicons/apple-icon.png` | Lossless indexed PNG, opaque 180x180 |
| `public/icons/app-192.png` | `favicons/android-chrome-192x192.png` | Lossless indexed PNG |
| `public/icons/app-512.png` | `favicons/android-chrome-512x512.png` | 8-color indexed PNG; antialias shades quantized |
| `public/icons/maskable-512.png` | `favicons/maskable-icon-512x512.png` | 8-color indexed PNG; antialias shades quantized |

Decoded pixels of the ICO, 96px, 180px, and 192px exports match their sources.
The 512px exports retain geometry and solid brand colors with fewer antialias
shades; they are not byte-identical or pixel-identical copies. The
manifest uses browser display and relative same-origin icon paths; it introduces
no service worker, offline behavior, or installability guarantee. The maskable
artwork keeps its essential mark within the central 80%-diameter circle.

Keep SVG masters unchanged when re-encoding images. Asset export is a one-time
preparation step, not a new application dependency or repository generator.
