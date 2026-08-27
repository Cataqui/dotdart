# Troubleshooting

## A generated file is missing

Confirm that:

1. The asset path is configured under the correct `dotdart` key.
2. The configured directory contains a directly nested supported file.
3. `dart run build_runner build` completed.
4. The import matches the source folder, for example
   `assets/icons/` becomes `lib/gen/icons.g.dart`.

## An image or GIF widget is empty

Images and GIFs must be registered under Flutter's `assets` section in addition
to dotdart's `image` section.

## An accessor name is unexpected

Filenames are normalized to lower camel case and Dart identifiers. Rename the
source file when the normalized name is unclear. Generation rejects collisions
instead of silently choosing an accessor.

## An SVG color parameter changed

Regenerate the asset library, then follow Dart analyzer errors or generated API
completion to update call sites. SVG colors use the drawable's `id`, or its
nearest ancestor group `id`, before falling back to numbered `color1` names.
Empty, whitespace-containing, invalid, or duplicate IDs stop generation so the
generated customization API cannot silently change ownership.

## Generation reports unsupported content

Check the [asset support reference](asset-support.md). Simplify or re-export the
source asset using supported features. Open an issue with a minimal,
redistributable fixture when the missing feature should be considered.

## Workspace output is written to the wrong package

Run generation from a resolved Pub workspace and ensure
`.dart_tool/package_config.json` is current. dotdart validates the consuming
package's `pubspec.yaml`; it does not use `Directory.current` as a fallback.

## Stale generated files remain

Run:

```bash
dart run build_runner clean
dart run build_runner build
```

dotdart only deletes stale files containing its exact ownership header. It
preserves output owned by other generators.
