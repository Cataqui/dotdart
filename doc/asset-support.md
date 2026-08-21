# Asset support

dotdart favors deterministic, efficient generated code over broad format
coverage. Unsupported features fail or produce an explicit build warning.

## SVG

Supported:

- `path`, `rect`, `circle`, `ellipse`, `line`, `polyline`, and
  `polygon`
- groups and inherited presentation attributes
- fill, stroke, opacity, fill rule, line cap, and line join
- translate, scale, and rotate transforms
- `viewBox` offsets
- `defs`, `clipPath`, and `clip-path="url(#id)"`

Not supported:

- gradients, filters, masks, patterns, text, or embedded images
- CSS `style` blocks
- `use` and `symbol`
- arc path commands
- matrix and skew transforms

Generated SVG accessors expose supported source colors as typed `color1`,
`color2`, and later parameters.

## Lottie

Supported:

- shape layers with groups, paths, rectangles, ellipses, fills, and strokes
- reusable precomposition layers
- parented layer transforms, including null controller layers
- static text layers, including point text and paragraph boxes
- static, non-inverted, fully opaque additive masks with zero expansion
- transforms, opacity, hold keyframes, and cubic Bézier easing
- one static or animated trim-path modifier per shape group, including start,
  end, offset, wraparound, default shape direction, and parallel or sequential
  multiple-shape modes
- timeline playback with one-time or continuous-loop modes, one-time playback
  delay, duration override, progress control, sizing, text replacement, and
  color overrides
- app lifecycle pause and resume behavior

Generated Lottie accessors clip painting to the source canvas by default,
matching normal Lottie-player behavior. Pass `clip: false` to allow layers to
paint beyond that boundary.

Automatic playback uses `LottiePlayback.once` by default and keeps the final
frame visible. Pass `playback: LottiePlayback.loop` to repeat continuously.
Manual `progress` continues to take precedence over automatic playback.

Generated text and color fields live on the asset's generated `overrides`
object and use the Lottie layer name when one is available. Named text fields
end in `Text`, unless the name already does. For example, layers named `Job
Title` and `Miami Artwork` produce `jobTitleText`, `jobTitleTextColor`, and
`miamiArtworkColor1`. Repeated text layer names receive numbered fields such as
`jobTitleText2` and `jobTitleText2Color`, so every layer remains independently
editable. Unnamed layers use `text1`, `color1`, and later fields.

Text is painted with Flutter's `TextPainter`. Register the font family named in
the Lottie file in the consuming app when exact font metrics matter; Flutter's
normal font fallback is used otherwise.

Not supported:

- image, audio, camera, or animated text layers
- expressions, effects, precomposition time remapping, animated, translucent,
  expanded, inverted, or non-additive masks, mattes, gradients, or 3D layers
- nested groups beyond the supported shape-group structure
- multiple trim-path modifiers in one shape group
- trim paths combined with reversed shape direction

Unsupported layer and shape types that can be skipped safely produce build
warnings. Features that would change rendering semantics fail generation.

## Images and GIFs

Supported formats are PNG, JPEG, WebP, and GIF. Generated metadata includes
intrinsic dimensions, aspect ratio, animation status, dominant color, and a
thumbhash placeholder.

Each namespace containing an image or GIF also has a generated cache class.
Warm one decoded image before it is shown, then remove that same entry when it
is no longer needed:

```dart
await $ImagesCache.precacheProfile(context, width: 160);

final image = $Images.profile(width: 160);

final removed = await $ImagesCache.removeProfile(context, width: 160);
```

Widths and heights are logical pixels. Use the same values for precaching,
rendering, and removal so Flutter addresses the same decoded cache entry. If
only one dimension is supplied, dotdart derives the other from the image's
intrinsic aspect ratio. If neither is supplied, the generated widget's default
display size is used. Removal releases the reusable cache entry without
discarding an image that is still being displayed.

AVIF and HEIC are intentionally unsupported because their availability and
decode behavior are not consistent across the low-end devices dotdart targets.

## Sizing

SVG and Lottie widgets preserve their native aspect ratio by default. When both
`width` and `height` are provided, the larger requested dimension is used as
the reference. Pass `maintainAspectRatio: false` only when intentional
distortion is acceptable.
