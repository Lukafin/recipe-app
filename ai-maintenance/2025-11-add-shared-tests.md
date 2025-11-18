### Summary
There are virtually no tests covering the shared Kotlin logic or the Python webhook. Only template tests exist under `automotiveApp`. This limits our ability to safely refactor and adds risk when changing navigation, data parsing, or interaction logic.

### Recommended remediation / acceptance criteria
- Kotlin (shared):
  - Extract logic from composables where feasible into pure functions and add unit tests under `shared/src/commonTest`.
  - Add tests for any data parsing once recipes are in JSON (see related task).
  - For Android-specific sensor code, add instrumented tests or unit tests with Robolectric where applicable.
- Python: add unit tests for `format_sentry_event`, signature verification (see secure webhook task), and basic endpoint behavior.
- Add minimal test scaffolding for WASM/desktop targets where practical.

### Notes
- Related areas: `shared/src/commonMain/kotlin/**`, `shared/src/androidMain/kotlin/sensor/**`, `sentry_webhook_server.py`.
- Tests to run: `./gradlew test`, `./gradlew :androidApp:connectedAndroidTest` (if configured), and `pytest`/`python -m unittest` for Python.
- Gotchas: Compose UI is harder to unit test; focus on extracted state/logic and use previews/manual verification for rendering.