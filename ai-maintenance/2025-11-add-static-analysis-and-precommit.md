### Summary
The repo lacks consistent static analysis across languages. Kotlin code would benefit from `ktlint` and/or `detekt`; the Python webhook server would benefit from linting (ruff/flake8) and type checks (mypy). Pre-commit hooks help keep formatting and basic checks consistent.

### Recommended remediation / acceptance criteria
- Kotlin: add `ktlint` Gradle plugin and/or `detekt` with a baseline, wired into CI.
- Python: add `ruff` (lint+format) and `mypy` (basic type checks) for `sentry_webhook_server.py`.
- Add `.editorconfig` with common code style rules.
- Introduce `pre-commit` with hooks for ktlint/detekt, ruff, mypy, and license headers if desired.
- Update CI to run these checks on PRs.

### Notes
- Related files: Kotlin modules (`shared`, `androidApp`, etc.), `sentry_webhook_server.py`.
- Tests: CI green with the new checks; fix any surfaced issues.
- Gotchas: Keep detekt config pragmatic to avoid churn; exclude generated/built artifacts under `docs/` and `node_modules/`.