# Releasing

dotdart uses semantic versioning and immutable `v<version>` Git tags.

## Release checklist

1. Update `version` in `pubspec.yaml`.
2. Add the matching changelog entry and migration notes for breaking changes.
3. Run `make check` and `make pana`.
4. Confirm `make publish-dry-run` has zero warnings and inspect every file.
5. Re-run the dependency and generated-source audit in
   [`source-provenance.md`](source-provenance.md).
6. Merge through protected `main` and wait for required CI.
7. Create the immutable tag and GitHub Release.

## Pub.dev

Publishing is deliberately separate from creating a GitHub Release. Never run a
real publication command unless the release owner explicitly requests it.

The first pub.dev version must be uploaded manually. After that release is
owned by the intended publisher and GitHub OIDC is configured, future
`v<version>` tags can use the repository's publish workflow. The tag and
`pubspec.yaml` versions must match.
