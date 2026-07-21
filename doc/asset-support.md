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
- transforms, opacity, trim paths, hold keyframes, and cubic Bézier easing
- timeline playback, looping, progress control, sizing, and color overrides
- app lifecycle pause and resume behavior

Not supported:

- image, text, audio, camera, or precomposition layers
- expressions, effects, masks, mattes, gradients, or 3D layers
- nested groups beyond the supported shape-group structure

Unsupported layer and shape types that can be skipped safely produce build
warnings. Features that would change rendering semantics fail generation.

## Raster images

Supported formats are PNG, JPEG, WebP, and GIF. Generated metadata includes
intrinsic dimensions, aspect ratio, animation status, dominant color, and a
thumbhash placeholder.

AVIF and HEIC are intentionally unsupported because their availability and
decode behavior are not consistent across the low-end devices dotdart targets.

## Sizing

SVG and Lottie widgets preserve their native aspect ratio by default. When both
`width` and `height` are provided, the larger requested dimension is used as
the reference. Pass `maintainAspectRatio: false` only when intentional
distortion is acceptable.
