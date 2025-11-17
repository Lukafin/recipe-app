### Summary
`androidApp/src/androidMain/AndroidManifest.xml` embeds a real Sentry DSN and enables `io.sentry.debug=true` and `io.sentry.traces.sample-rate=1.0` for all builds. Shipping a production DSN in an open repository is risky, and enabling verbose logging and 100% tracing globally can impact privacy, performance, and cost.

### Recommended remediation / acceptance criteria
- Move DSN and Sentry options to build-type or flavor-specific config:
  - Debug: enable `debug=true`, keep a separate DSN (or none).
  - Release: DSN supplied via `sentry.properties` (ignored by git) or `BuildConfig` field populated from CI secrets.
  - Reduce `traces.sample-rate` in release (e.g., 0.1) and gate with remote sampling or env.
- Remove the DSN from VCS and document local setup in `README`.
- Prefer using the Sentry Gradle plugin configuration to inject values at build-time.

### Notes
- Related file: `androidApp/src/androidMain/AndroidManifest.xml`.
- Also see `.gitignore` already excluding `androidApp/sentry.properties`.
- Tests: Verify app still initializes Sentry in debug and release appropriately. Validate no DSN is baked into release manifests via `./gradlew :androidApp:processReleaseManifest` output.
- Gotchas: Ensure Proguard/R8 rules are correct if minification is enabled; validate traces sampling doesn’t drop critical spans unintentionally.