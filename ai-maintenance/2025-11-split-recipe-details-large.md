### Summary
`shared/src/commonMain/kotlin/details/RecipeDetailsLarge.kt` (~300 lines) contains multiple responsibilities: input handling (pointer/scroll), sensor-driven parallax, shared element transitions, layout composition, and navigation controls. While not >500 lines, its breadth increases cognitive load and hampers reuse.

### Recommended remediation / acceptance criteria
- Extract sub-composables:
  - `HeroImagePanel(...)` – background shadow/image + rotation/parallax bindings
  - `DetailsPane(...)` – right column `LazyColumn` and `StepsAndDetails` wiring
  - `PointerParallaxController(...)` – `NestedScrollConnection`/`pointerInput` logic returning state
  - Keep `BackButton` as-is or move to `details/controls/`.
- Hoist sensor registration behind an interface so preview/tests can supply fakes.
- Limit `with(sharedTransactionScope)` block size by pushing transitions into sub-composables.
- Aim for top-level composable ≤150 lines.

### Notes
- Related file: `shared/src/commonMain/kotlin/details/RecipeDetailsLarge.kt`.
- Tests: Compose unit tests for derived state calculations and interaction handlers (use desktop target where feasible). Consider screenshot tests if infra exists.
- Gotchas: Preserve keys used by shared element transitions (e.g., `item-image-${recipe.id}`) to avoid regressions.