# Website identity

The owner supplied `exphere-identity-seo(1).zip` on October 13, 2026 and selected
black Exphere branding. The recorded source archive SHA-256 is
`c1a0bd65799cbcd77dbf63371984f39ea5e551d423a1d86e9b9e6d414ded61ad`.
The [website design contract](DESIGN.md) adapts the owner's design reference;
ClickHouse marks and yellow are not used.

The current `public/brand/exphere-logo.svg` and `src/app/icon.svg` preserve the
supplied geometry, with a black mark/outlined wordmark and white support canvas
where appropriate. No font files, external SVG references, runtime image
service or logo redesign was introduced. The home SVG heading remains
commented out under SPEC-WEBSITE-HOME-LOGO-VISIBILITY.

## Active browser and application assets

| Destination | Size | Treatment and provenance |
| --- | --- | --- |
| `src/app/icon.svg` | 128×128 vector | Existing black mark on white rounded canvas, unchanged. |
| `src/app/icon1.png` | 96×96 | Existing black mark on white rounded canvas, unchanged. |
| `src/app/apple-icon.png` | 180×180 | Exact one-bit black/white bytes recovered from `706d6dae3eb7a95f68738448ae28e36fefd291a3`. |
| `public/icons/app-192.png` | 192×192 | Existing black mark on white canvas, unchanged. |
| `public/icons/app-512.png` | 512×512 | Exact black/white bytes recovered from the same revision. |
| `public/icons/maskable-512.png` | 512×512 | Exact black/white safe-zone composition recovered from the same revision. |

The recovery revision has the identical horizontal SVG checksum as the current
tree, and its icon SVG differs only by an identity transform. Restoring those
existing binary exports preserves the black geometry without redrawing it.
The manifest paths and browser-display semantics remain unchanged. No service
worker, offline behavior or installability guarantee is introduced.

There is no active `favicon.ico` convention file. The original is truncated;
the historical replacement has one-bit embedded PNG frames that Next.js 16.4's
Turbopack ICO decoder rejects. The valid SVG and 96px PNG provide explicit
favicon links instead. Legacy clients requiring only `/favicon.ico` remain a
compatibility limitation until a separately verified ICO export is supplied.

## Preserved corrupt source assets

The PR completion build found six malformed binary assets already present in
the `d6b3c8abff240c54011f81f7088f445e3fbabef4` baseline. They were not usable
rendering evidence. The original bytes are preserved under existing
`public/brand/`, without being advertised by metadata or the manifest:

| Preserved path | Observed defect |
| --- | --- |
| `public/brand/apple-icon.png` | IDAT checksum mismatch. |
| `public/brand/favicon.ico` | Truncated image data. |
| `public/brand/opengraph-image.png` | Declared IDAT length exceeds remaining file bytes. |
| `public/brand/twitter-image.png` | Declared IDAT length exceeds remaining file bytes. |
| `public/brand/app-512.png` | Truncated PNG chunk. |
| `public/brand/maskable-512.png` | Truncated PNG chunk. |

The social alt sidecars moved alongside the originals. These files preserve
historical source material; they are not valid replacement assets. Their
recorded intended composition was black Exphere artwork and technical linework
on white, but the corrupt payloads do not demonstrate a renderable composition.
The earlier validation/checksum claims are superseded by this byte inspection.

No active `opengraph-image.*` or `twitter-image.*` convention file remains.
Both pages and the root retain empty image lists, and the production origin
remains undecided. Valid social exports must be supplied and verified before a
future sharing/indexing launch. No canonical, sitemap or entity claim was added.

## Current checksums

SHA-256 identifies the actual bytes in this recovery:

| Active asset | SHA-256 |
| --- | --- |
| `public/brand/exphere-logo.svg` | `0b8f4664b99023004bb89fab930e7688c6e28e3d173264c71db8b65effaafb95` |
| `src/app/icon.svg` | `f3c3f60bb731efbfa5c95c921c11c89816bb2024ce274d6f299dc7584e2e2260` |
| `src/app/icon1.png` | `6d66ee8808a24ac86b1bce93af1fd42ad55caf9230269c736e08b9b1f53ae45c` |
| `src/app/apple-icon.png` | `cd469a3911c0393b9208a50009f0dceb9145ac6ec65f5da54be546a3c0a699fa` |
| `public/icons/app-192.png` | `4c6d36a1fee333fc2f2b95837f93f521e5da0858abfd52afe0f1441be806506b` |
| `public/icons/app-512.png` | `5365a04515ddc66675d7e81ea60cd60c2154a658b659e4c2eb6eba8858305211` |
| `public/icons/maskable-512.png` | `b9a205533fa51bae213e36c98e90af106556833a9c7d991b1808f356fd34637a` |

| Preserved original | SHA-256 |
| --- | --- |
| `public/brand/apple-icon.png` | `2ce7dc593a536409b91ddc52a264cb76263053a7f5c1500f01f80ea5beae3e6f` |
| `public/brand/favicon.ico` | `e68dda39486f91d4c09609021519e8dae81e00cd65d4c665f91e410c0a17c3df` |
| `public/brand/opengraph-image.png` | `f220f3613f92acc4a8156083b6fd2471683fedd693cd2d78e8eece9e1bcd6689` |
| `public/brand/twitter-image.png` | `353e1e860783d1a71a809b8f14fdadd476400e49dd51311a7d8880b7a9840059` |
| `public/brand/app-512.png` | `69c155ce40edb2b60786f93e2d132609fdb351335e1e109c03af0dd31c14013f` |
| `public/brand/maskable-512.png` | `69c155ce40edb2b60786f93e2d132609fdb351335e1e109c03af0dd31c14013f` |

## Verification boundary

The completion cycle inspected PNG structure, compared recovered bytes with
Git history, compiled the production application and inspected generated
metadata. These checks do not establish browser rendering, deployment,
indexing, Core Web Vitals, or production acceptance. The site remains noindex.
