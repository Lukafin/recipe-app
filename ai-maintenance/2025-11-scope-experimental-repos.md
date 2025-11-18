### Summary
Root `build.gradle.kts` adds experimental/dev Maven repositories to all projects (`allprojects.repositories`), including `kotlin/wasm/experimental` and `kotlin/dev`. This increases the chance of resolving snapshots or experimental artifacts unintentionally across Android/iOS/Desktop apps.

### Recommended remediation / acceptance criteria
- Remove experimental repositories from `allprojects` and scope them to the modules that need them (e.g., `webApp` and `shared` when `wasmJs` is enabled).
- Keep `google()` and `mavenCentral()` at the root only.
- Add a settings-level constraint to fail resolution from disallowed repositories in release builds.

### Notes
- Related files: `build.gradle.kts`, `settings.gradle.kts`.
- Tests: Run `./gradlew dependencies` for representative modules before/after and diff resolved artifacts.
- Gotchas: WASM builds may require the experimental repos; ensure those modules keep the repo entries locally.