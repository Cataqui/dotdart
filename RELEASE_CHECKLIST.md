# Release checklist

Use this checklist for every dotdart release. dotdart follows semantic
versioning and uses immutable `v<version>` Git tags.

## Prepare the release

- [ ] Choose the release version according to semantic versioning.
- [ ] Update `version` in `pubspec.yaml`.
- [ ] Add the matching entry to `CHANGELOG.md`.
- [ ] Add migration guidance for every breaking change.
- [ ] Update consumer documentation and the example for public behavior changes.
- [ ] Regenerate and commit example output when generator output changes.
- [ ] Confirm the root `pubspec.lock` is untracked and ignored.
- [ ] Confirm `example/pubspec.lock` is committed and synchronized with the
      release version.

## Audit source and dependencies

- [ ] Review every dependency change and confirm the Dart or Flutter SDK cannot
      provide the required capability.
- [ ] Check each direct dependency's license and any notice or redistribution
      obligations.
- [ ] Confirm fixtures, example assets, and generated runtime source may be
      redistributed publicly.
- [ ] Confirm the package contains no credentials, publisher tokens, private
      assets, or sensitive local paths.

## Validate the release

- [ ] Start from a clean Git worktree.
- [ ] Run `make check`.
- [ ] Run `make pana`.
- [ ] Confirm `make publish-dry-run` reports zero warnings.
- [ ] Inspect every file in the publication archive.
- [ ] Confirm generated libraries are self-contained and do not import dotdart
      or a runtime SVG or Lottie renderer.

## Merge and tag

- [ ] Merge through protected `main`.
- [ ] Wait for every required CI check to pass on the release commit.
- [ ] Confirm the release commit's `pubspec.yaml` version exactly matches the
      planned tag.
- [ ] Obtain explicit release-owner authorization to publish. Pushing the
      version tag starts the trusted-publishing workflow immediately.
- [ ] Create the immutable `v<version>` tag.
- [ ] Create the matching GitHub Release from that tag.

## Publish to pub.dev

Publication verification is separate from creating a GitHub Release. Never run
a real pub.dev publication command or push a version tag unless the release
owner explicitly requests publication.

- [ ] For the first pub.dev release, upload manually under the intended
      publisher.
- [ ] For later releases, use the tag-triggered publish workflow only after
      GitHub OIDC trusted publishing is configured and verified.
- [ ] Confirm the published version matches both the Git tag and
      `pubspec.yaml`.
