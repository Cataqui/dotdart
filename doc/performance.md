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
- Per-asset cache methods can warm only the images needed for the next screen.
- Matching removal methods release decoded entries after they are no longer
  needed, instead of retaining full-screen image memory indefinitely.
- Removal preserves live image entries, avoiding a duplicate decode when the
  same image is still displayed during a transition.
- Generated images use repaint boundaries to isolate expensive repaints.
