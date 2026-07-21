# Performance model

dotdart moves asset parsing and most metadata work to generation time so the
application does less work while rendering.

## SVG and Lottie

- Source XML and JSON are not parsed at runtime.
- Geometry is emitted as reusable Dart `Path` data.
- Generated painters reuse paints and static geometry where possible.
- Generated output imports Flutter SDK libraries but no SVG, Lottie, or dotdart
  runtime package.
- Explicitly sized widgets remain finite inside unbounded parents such as
  `Column`.

## Raster images

- Intrinsic dimensions and dominant color are computed during generation.
- Decode cache dimensions follow the requested display size.
- Thumbhash placeholders are available on the first frame.
- Namespace precaching is sequential to avoid concurrent decode spikes.
- Generated images use repaint boundaries to isolate expensive repaints.

## Performance changes

Changes to parsing or emitted code must be tested at the generator and rendered
widget levels. Do not introduce `saveLayer`, eager image decoding, concurrent
namespace precaching, or a runtime renderer dependency without measured evidence
that the change remains suitable for 2–4 GB devices.
