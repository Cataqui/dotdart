# AGENTS.md — dotdart

## Mission

dotdart is a build-time Flutter asset compiler. It turns supported SVG, Lottie,
images, and GIFs into typed, optimized Dart widgets while keeping runtime work
and memory pressure low.

The package promise is literal: the asset becomes Dart. Generated libraries must
be self-contained, analyzable, deterministic, and safe on low-end devices.

## Environment and commands

- Flutter is pinned by `.fvmrc`. Never use an untracked global Flutter SDK.
- Use the root `Makefile`; this repository does not use Melos.
- Commit `pubspec.lock` whenever dependencies change.
- Do not add a dependency unless the requested work requires it and Dart or
  Flutter cannot provide the capability.

Common commands:

```bash
make setup
make format
make analyze
make test
make example
make check
make pana
make publish-dry-run
```

Never run a real pub.dev publication command unless the human explicitly asks.

## Architecture

```text
lib/
├── dotdart.dart
└── src/
    ├── builders/    # config, discovery, manifests, package roots, output safety
    ├── generators/  # SVG, Lottie, image/GIF, namespaces, shared source emission
    ├── models/      # parsed immutable asset models
    └── parsers/     # Lottie JSON, image/GIF metadata/thumbhash, minimal SVG
```

The public library exports only `dotdartBuilder` and
`dotdartPostProcessBuilder`. These two builder factories are the deliberate
exception to the no-top-level-functions rule because `build.yaml` must name
top-level factories.

Everything else under `lib/src` is implementation detail.

## Invariants

- Assets are grouped by source folder into one flat namespace library.
- Generated widget classes are private; public namespace methods return
  `Widget`.
- Generated files may import Dart and Flutter SDK libraries, never dotdart or a
  runtime SVG/Lottie renderer.
- Package roots come from `.dart_tool/package_config.json` and are validated
  against the consuming `pubspec.yaml`. Never fall back to
  `Directory.current`.
- Post-processing deletes only files with dotdart's exact ownership header.
  Preserve files owned by other generators and reject traversal or symlink
  escapes.
- Generated SVG/Lottie sizing must remain finite inside unbounded layouts.
  `OverflowBoxFit.deferToChild` and its explicit rendering import are regression
  contracts.
- Image and GIF decoding follows requested display size. Namespace precaching remains
  sequential to avoid memory spikes.

## Dart style

- Prefer explicit, boring, readable code.
- Avoid `dynamic`; narrow unknown JSON immediately.
- Use named parameters when a function or constructor accepts more than one
  primitive input.
- Keep models immutable.
- Put enums in an owner-specific `*_enums.dart` part file. Put behavior driven
  only by an enum value on the enum.
- Exhaustively list every enum member in switches. Do not use `default` or
  wildcard clauses over enums.
- Keep reusable public callback types in an owner-specific `*_types.dart` file;
  inline signatures used only once.
- Keep at most one implementation class per source file, except a
  `StatefulWidget` and its private `State`.
- Do not add free-standing helpers. Use an owning class method.
- Inline single-use values. Extract linked layout values so every consumer uses
  the same constant.
- Prefer guard clauses and early returns over nested `if/else` chains.
- Every exported declaration requires consumer-focused Dartdoc.

## Generated source

The generators produce public consumer code, so generated output has the same
quality bar as handwritten source:

- deterministic ordering and formatting;
- complete Dartdoc for public namespace APIs;
- no blanket lint suppression;
- no hidden runtime dependency;
- actionable source paths in failures;
- exhaustive tests for constructor/accessor parameter parity.

Never patch generated consumer files to fix a generator defect. Reproduce the
issue in dotdart, fix the parser/generator contract, and regenerate consumers.

## Testing

- Every bug fix requires a regression test that fails before the fix when
  practical.
- Test descriptions use: `when <condition/action>, it should <result>`.
- Each test block contains exactly one assertion call.
- A source file's tests live in the matching dedicated test file.
- Prefer `pumpAndSettle` immediately after `pumpWidget`; use `pump` only for
  deliberate intermediate or infinite states.
- Parser tests verify models and failures.
- Generator tests verify emitted source and documentation.
- Widget tests compile and render representative generated output.
- The consumer fixture runs real build_runner, analyzes generated libraries, and
  renders every asset type.

Run focused tests while iterating, then `make check` before handoff.

## Debugging

Do not guess at generator failures. Reproduce them with a minimal,
redistributable asset and capture the relevant build log or stack trace before
changing production code. If an attempted fix does not resolve the failure,
revert that attempt before trying another approach.

Distinguish source failures from environment failures such as unwritable FVM
caches or unavailable networks.

## Performance

Every change must remain appropriate for 2–4 GB devices and older mobile CPUs.
Parsing and metadata work belong at build time. Avoid runtime XML/JSON parsing,
eager image decoding, concurrent image warming, unnecessary allocations in
`paint`, and `saveLayer` without measured justification.

A passing code suite does not prove on-device frame performance or perceptual
quality. Report those gates separately when a change affects rendering cost.

## Documentation and releases

- Keep README and `doc/` content consumer-first. Move maintainer detail into
  `CONTRIBUTING.md` or this file, never into `doc/`.
- Follow `RELEASE_CHECKLIST.md` for every release. Do not skip or silently infer
  a completed gate.
- Use plain language familiar to Flutter developers in every consumer-facing
  surface, including public APIs, documentation, examples, changelogs,
  generated Dartdoc, configuration guidance, warnings, and errors. Prefer the
  term a package user already knows, and explain unavoidable specialist
  terminology when it first appears.
- Say "images and GIFs" or name the supported formats (PNG, JPEG, WebP, and
  GIF). Never use "raster" as a consumer-facing synonym for them. Established
  internal identifiers may retain `raster` when renaming them would obscure the
  implementation or create needless churn.
- Describe the supported format subset precisely; never claim complete SVG or
  Lottie compatibility.
- Follow semantic versioning. Before 1.0, document breaking minor releases with
  migration guidance.
- Update README, docs, example, changelog, and `pubspec.yaml` together when a
  public behavior changes.
- Inspect the publication archive and require zero dry-run warnings.
- Release tags are immutable and must match the pubspec version.

## Pull requests

Use Conventional Commits. Include tests, changelog entries for user-visible
changes, and regenerated example output when applicable. Required CI must pass
before merge; never force-push or delete a release tag.

## Security

Never commit credentials, publisher tokens, private assets, or sensitive local
paths. Treat asset parsers and output paths as untrusted-input boundaries.
Reject traversal, unsafe symlinks, invalid identifiers, and ambiguous ownership
instead of attempting recovery.
