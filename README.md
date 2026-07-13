# dotdart

Convert visual assets (Lottie, SVG, and more) to pure-Dart widget code at build time. No runtime dependency — generated code is self-contained Flutter widgets.

## Installation

```yaml
# pubspec.yaml
dev_dependencies:
  dotdart:
    path: ../packages/dotdart

dotdart:
  output: lib/gen/
  lottie:
    - assets/lottie/
```

## Usage

Place an asset file in a configured folder, then run:

```bash
melos gen:all
```

This generates a self-contained Flutter widget at `lib/gen/<asset_name>.g.dart`.

### Generated widget

```dart
import 'package:cataqui_app/gen/swipe_up_onboarding.g.dart';

// Animated (loops 2.2s, pauses on app background)
SwipeUpOnboarding(width: 200, animated: true)

// Static frame
SwipeUpOnboarding(width: 200, animated: false)

// Custom colors
SwipeUpOnboarding(
  width: 200,
  color1: Color(0xFF1F1F1F),
  color2: Color(0xFFFF4A4B),
)
```

## Configuration

```yaml
dotdart:
  output: lib/gen/              # output directory (default: lib/gen/)
  lottie:                        # Lottie JSON files
    - assets/lottie/             # folder — scans all .json inside
    - assets/animations/         # another folder
    - tmp/animation.json         # single file
  # svg:                        # future
  #   - assets/svg/
```

Each asset type gets its own key under `dotdart:`. The builder detects the format automatically by inspecting file content.

## Supported Asset Types

### Lottie (currently supported)

- Shape layers (`ty: 4`)
- Shapes: rect, ellipse, bezier path
- Fills and strokes (solid colors only)
- Groups and transforms
- Animated keyframes with bezier easing
- Hold keyframes
- Spatial tangents for position

### SVG (planned)

SVG support will follow the same architecture — parse the vector format, emit `CustomPainter` code.

## Not Yet Supported

- Gradients, masks, trim paths, repeaters
- Text and image layers
- Expressions and 3D layers
- Merge paths, offset paths, pucker/bloat, zigzag
