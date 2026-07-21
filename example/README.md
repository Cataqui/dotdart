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
