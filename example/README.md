# dotdart example

This Flutter app generates and renders one SVG, one Lottie animation, and one
image through dotdart's public namespace APIs.

```bash
fvm flutter pub get
fvm dart run build_runner build
fvm flutter run
```

In VS Code, choose a device from the status bar and run
`dotdart example (selected device)`. The launch profile always targets this
example app; the dotdart package root remains platform-independent.

Generated libraries are committed so the example shown on pub.dev matches the
repository release.

## Lookup by filename

The example also renders an SVG through
`$Icons.findByName('cross.svg', width: 64) ?? const SizedBox.shrink()`.
Lookup accepts `key`, `width`, and `height` and preserves the asset's sizing
behavior. Names must include the exact extension and case; missing names
return `null` so the app can choose a fallback.
