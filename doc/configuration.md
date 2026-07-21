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
