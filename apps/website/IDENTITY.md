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

## Social assets

`src/app/opengraph-image.png` and `twitter-image.png` are the same 1200x630
brand-only card: the supplied horizontal SVG at its original 551x128 size on
white, centered in the canvas. Their indexed eight-color export preserves the
solid purple, graphite, and white colors while quantizing antialias shades.
It contains no unsupported product capabilities or launch claim. Alt sidecars
describe the image; image dimensions and URL descriptors remain framework-owned.
Image URL activation is deliberately gated until an origin decision; see README.

## Asset checksums

The following SHA-256 values identify the delivered bytes, not the source ZIP's
original raster encoding. Both SVG sources are byte-identical to the pack.

- `public/brand/exphere-logo.svg`: `137b016321ac0e9c466730a3fccb918cdcf7d31ce9cb0eab6e5f224103d0c970`
- `src/app/icon.svg`: `e5ed52ec7667d8718765618b6f89523f5c308276b181e6bbce18b5bdcf6ea62a`
- `src/app/apple-icon.png`: `91aa712f3a8bf1e5bfcb80ed2d20435d2303cf4585118c53a74bb1dc9f1b3f29`
- `src/app/icon1.png`: `f4e5a050f410d548839679a0e8638e7eaefae8ff17b6f74de8a2c3f58634f26b`
- `public/icons/app-192.png`: `69575b4190d53305a98070a8117499f25c1df29df1b1b84e19e43af2d629789b`
- `public/icons/app-512.png`: `e7b7e9e4cbf036949971c9e884493bf05523e5a6969fd2e7d04ff0ec40b8e432`
- `public/icons/maskable-512.png`: `be1d118edea1da0d48530a2404e70728a5bf51e3065bb05579dfe2db26318bc4`
- `src/app/favicon.ico`: `fec804c24eae3a4b32c0a59aa8059970fcbb4f7094475549b7acd7f10bada73a`
- `src/app/opengraph-image.png`: `8388add93a1131e6558495c5fc2874456d9435bb793bc98def4903d23a8ad9b3`
- `src/app/twitter-image.png`: `8388add93a1131e6558495c5fc2874456d9435bb793bc98def4903d23a8ad9b3`
