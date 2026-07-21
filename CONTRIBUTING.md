# Contributing to dotdart

Thanks for helping make Flutter asset access safer and faster.

## Before opening an issue

- Search existing issues and discussions.
- Reduce generator failures to the smallest asset that still reproduces them.
- Confirm the asset may be redistributed publicly.
- Include Flutter, Dart, dotdart, and build_runner versions.
- Include the relevant `dotdart` configuration and complete error output.

Use Discussions for support and design exploration. Use Issues for reproducible
bugs and accepted feature work.

## Development

```bash
git clone https://github.com/Cataqui/dotdart.git
cd dotdart
make setup
make check
```

Flutter is managed exclusively through FVM. The repository uses Make rather
than Melos.

## Changes

- Write a regression test for every bug fix.
- Keep one assertion per test block and use the
  `when ..., it should ...` naming convention.
- Fix generator defects in dotdart rather than patching generated output.
- Add fixtures only when their license permits redistribution.
- Update the changelog and documentation for user-visible changes.
- Do not add dependencies without explaining why the SDK cannot provide the
  required capability.

## Pull requests

Use Conventional Commits, keep each pull request focused, and complete the pull
request checklist. CI runs locked, minimum-dependency, and cross-platform gates.

By participating, you agree to follow the code of conduct.
