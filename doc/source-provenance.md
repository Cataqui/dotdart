# Source provenance and licenses

This audit was last completed for `0.6.0` on 2026-07-21.

## Repository source

The Dart implementation, generated runtime source, tests, and example assets in
this repository originate from Cataquí's Mobile repository and retain their Git
authorship through the subtree extraction.

The compact image placeholder is inspired by Evan Wallace's
[ThumbHash](https://github.com/evanw/thumbhash) concept. dotdart's encoder,
binary layout, and emitted decoder were authored in the Cataquí repository and
are not a vendored copy of the reference implementation. The reference project
is MIT licensed. Because no third-party source is redistributed, this release
does not require a separate third-party notice file.

## Direct package dependencies

The resolved `0.6.0` development lock was checked against each package's
included license file:

| Dependency | Use | License |
| --- | --- | --- |
| `build`, `dart_style`, `glob`, `path` | Runtime/build-time | BSD 3-Clause |
| `image`, `yaml` | Runtime/build-time | MIT |
| Flutter SDK | Runtime/build-time | BSD 3-Clause |
| `build_runner` | Development | BSD 3-Clause |
| `very_good_analysis` | Development | MIT |

Dependencies are resolved by consumers and are not copied into the dotdart
source archive. Re-run this audit whenever a dependency or generated runtime
implementation changes.
