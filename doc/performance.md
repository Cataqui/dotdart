# Performance model

dotdart moves asset parsing and most metadata work to generation time so the
application does less work while rendering.

## SVG and Lottie

- Source XML and JSON are not parsed at runtime.
- Geometry is emitted as reusable Dart `Path` data.
- Generated painters reuse paints and static geometry where possible.
- Lottie text painters retain their layout between frames, and adjacent
  constant keyframes are compacted before source is emitted.
- Sequential trim-path lengths are computed once instead of being added again
  for every animated frame.
- Generated output imports Flutter SDK libraries but no SVG, Lottie, or dotdart
  runtime package.
- Explicitly sized widgets remain finite inside unbounded parents such as
  `Column`.

## Images and GIFs

- Intrinsic dimensions and dominant color are computed during generation.
- Decode cache dimensions follow the requested display size.
- Thumbhash placeholder colors are decoded during generation and embedded as
  constants, so the first frame does not parse base64 or run inverse-DCT math.
- Per-asset cache methods can warm only the images needed for the next screen.
- Matching removal methods release decoded entries after they are no longer
  needed, instead of retaining full-screen image memory indefinitely.
- Removal preserves live image entries, avoiding a duplicate decode when the
  same image is still displayed during a transition.
- Generated images use repaint boundaries to isolate expensive repaints.
