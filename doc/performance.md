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

## Images and GIFs

- Intrinsic dimensions and dominant color are computed during generation.
- Decode cache dimensions follow the requested display size.
- Thumbhash placeholders are available on the first frame.
- Namespace precaching is sequential to avoid concurrent decode spikes.
- Generated images use repaint boundaries to isolate expensive repaints.
