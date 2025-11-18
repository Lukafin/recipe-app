### Summary
`shared/src/commonMain/kotlin/model/ExampleData.kt` (≈342 lines) inlines a large, static recipe dataset in Kotlin source. This inflates Kotlin LOC, complicates localization, and makes content updates require code changes and redeploys.

### Recommended remediation / acceptance criteria
- Extract the recipe payload into JSON (or YAML) resources under `shared/src/commonMain/resources/`.
- Load at runtime using `kotlinx.serialization` with `@Serializable` DTOs mapped to `Recipe`.
- Provide a thin repository that returns parsed data and caches it in memory.
- Add basic schema validation on load (required fields, non-empty lists where applicable).
- Keep images referenced by resource identifiers as-is; only move textual content/IDs.

### Notes
- Related files: `shared/src/commonMain/kotlin/model/ExampleData.kt`, `shared/src/commonMain/kotlin/model/Recipe.kt`.
- Tests: Add unit tests that parse the JSON and validate a handful of items; include a malformed JSON test to assert graceful failures.
- Gotchas: Ensure JSON resources are packaged and available across targets (Android/iOS/Desktop/WASM). Use `compose.components.resources` I/O or platform file APIs accordingly.