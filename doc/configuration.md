# Configuration reference

dotdart reads a top-level `dotdart` section from the consuming package's
`pubspec.yaml`.

```yaml
dotdart:
  output: lib/gen/
  svg:
    - assets/icons/
    - assets/brand/logo.svg
  lottie:
    - assets/lotties/
  image:
    - assets/images/
```

## Keys

| Key      | Required | Meaning                                                  |
| -------- | -------- | -------------------------------------------------------- |
| `output` | No       | Package-relative destination. Defaults to `lib/gen/`.    |
| `svg`    | No       | SVG files or directories to compile.                     |
| `lottie` | No       | Lottie JSON files or directories to compile.             |
| `image`  | No       | PNG, JPEG, WebP, or GIF files or directories to inspect. |

At least one asset type must be configured. Unknown keys and values that are not
lists are rejected.

## Input rules

- Paths are relative to the consuming package.
- Absolute paths and `..` traversal are rejected.
- Directory inputs are scanned directly and are not recursive.
- An explicit file must exist and match its configured asset type.
- A configured directory must contain at least one matching asset.
- The same path cannot be configured under multiple asset types.

## Output and namespaces

Each source folder produces one `<folder>.g.dart` file. Filenames become
lower-camel-case accessor names, while folder names become PascalCase
namespaces:

| Source                        | Output                   | Accessor             |
| ----------------------------- | ------------------------ | -------------------- |
| `assets/icons/arrow_left.svg` | `lib/gen/icons.g.dart`   | `$Icons.arrowLeft()` |
| `assets/three_d/empty.webp`   | `lib/gen/three_d.g.dart` | `$ThreeD.empty()`    |

Identifier collisions, reserved words, and two assets that normalize to the same
name stop generation with an actionable error.

## Filename lookup

Every namespace provides `findByName` for names supplied at runtime:

```dart
final icon = $Icons.findByName('arrow_left.svg', width: 24) ??
    const SizedBox.shrink();
```

Pass the original filename, including the extension and exact case. The lookup
is limited to that namespace; directory paths, extensionless names, and unknown
filenames return `null`. It accepts `key`, `width`, and `height`. Dimensions
use the same sizing rules as the named accessor, and all asset-specific options
retain their defaults. Use the named accessor to customize those options.

The accessor name `findByName` is reserved. When upgrading to 0.11.0, rename any
asset such as `find_by_name.svg` that produces this accessor, regenerate, and
update calls to the renamed asset's accessor.

## Image and GIF registration

Image and GIF widgets still load their original files at runtime. Register every
image and GIF input with Flutter:

```yaml
dotdart:
  image:
    - assets/images/

flutter:
  assets:
    - assets/images/
```
