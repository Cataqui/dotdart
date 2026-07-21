# Security policy

## Supported versions

Security fixes are applied to the latest released minor version. Older pre-1.0
versions may require upgrading to receive a fix.

## Reporting a vulnerability

Do not open a public issue for a suspected vulnerability.

Use GitHub's private vulnerability reporting for this repository. Include:

- the affected version or commit;
- a minimal reproduction;
- the security impact;
- any suggested mitigation.

Maintainers will acknowledge a complete report within five business days and
coordinate disclosure after a fix is available.

Likely security boundaries include asset parser denial of service, unsafe output
paths, traversal or symlink escapes, generated identifier injection, and stale
output ownership.
