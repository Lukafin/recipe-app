# November 2025 Recipe App Competitive Digest

## Executive Summary
- **Compose Multiplatform advances (1.9.3 stable; 1.10.0-beta01)**: recent releases suggest continued polish for iOS/WASM and desktop rendering; evaluate upgrade path for stability/perf wins in this project.
- **Server/network stack updates (Ktor 3.3.2; Skiko 0.9.35)**: incremental improvements likely affecting HTTP, serialization, and desktop/WASM rendering; plan smoke tests across platforms after bumping.
- **Competitor features**: no verifiable public app updates captured this cycle via offline sources; prioritize automated monitoring (store changelogs, blogs, and pricing diffs) to avoid blind spots next month.

## Feature & UX Highlights
- **No verified competitor feature launches were captured this month** under the current (offline) collection method. Recommended watchlist and examples of high-signal areas:
  - **AI cooking assistance**: contextual step guidance, camera-based food recognition, voice-driven cooking on TV/Automotive.
  - **Planning + commerce**: weekly meal plans, pantry awareness, smart substitutions, retailer integrations, shareable carts.
  - **Accessibility & offline**: large-text/contrast presets, screen-reader labels, robust offline/low-connectivity flows.

## Monetization & Partnerships
- **No new public pricing/partnership moves verified this cycle**.
- Suggested monitoring:
  - **Pricing experiments**: monthly vs. annual discounts, family plans, trial lengths, one-time unlocks.
  - **Creator programs**: revenue shares, recipe marketplace commissions, affiliate storefronts with grocers/kitchen brands.
  - **Distribution**: OEM TV hubs, automotive galleries, telco/device bundles, cross-promo with fitness/nutrition apps.

## Tech & Platform Notes
- **Compose Multiplatform**
  - 1.9.3 (2025-11-06) [link]
  - 1.10.0-beta01 (2025-11-04) [link]
  - Relevance: potential iOS/WASM stability and performance improvements; verify compatibility with current `shared` module and Gradle setup before upgrading.
- **Kotlin**
  - 2.2.21 (2025-10-23) [link]
  - 2.3.0-Beta2 (2025-10-28) [link]
  - Relevance: consider stability vs. feature tradeoffs; test compiler and library alignment (coroutines, serialization, Ktor) before moving beyond 2.2.x.
- **Ktor**
  - 3.3.2 (2025-11-05) [link]
  - Relevance: HTTP client/server fixes and Gradle alignment; re-run network-layer smoke tests (timeouts, retries, JSON handling).
- **Skiko**
  - 0.9.35 (2025-11-12) [link]
  - Relevance: desktop/WASM rendering updates; recheck font rendering, image decoding, and animation smoothness on low-end devices.
- Alignment note for this repository: UI and navigation live in `shared/src/commonMain/kotlin`; platform modules (`androidApp`, `iosApp`, `desktopApp`, `webApp`, `tvApp`, `automotiveApp`) are thin shells. Favor upgrades that keep logic in `shared` and minimize per-platform deltas.

## Sources
- Repository: [`https://github.com/Lukafin/recipe-app`](https://github.com/Lukafin/recipe-app)
- Supplemental project context (verbatim from prompt): Platforms: Android, iOS, Desktop, Web/WASM, TV, and Android Automotive; shared UI/navigation lives in `shared/src/commonMain/kotlin`.
- Compose Multiplatform releases:
  - 1.9.3 — [`https://github.com/JetBrains/compose-multiplatform/releases/tag/v1.9.3`](https://github.com/JetBrains/compose-multiplatform/releases/tag/v1.9.3)
  - 1.10.0-beta01 — [`https://github.com/JetBrains/compose-multiplatform/releases/tag/v1.10.0-beta01`](https://github.com/JetBrains/compose-multiplatform/releases/tag/v1.10.0-beta01)
- Kotlin releases:
  - 2.2.21 — [`https://github.com/JetBrains/kotlin/releases/tag/v2.2.21`](https://github.com/JetBrains/kotlin/releases/tag/v2.2.21)
  - 2.3.0-Beta2 — [`https://github.com/JetBrains/kotlin/releases/tag/v2.3.0-Beta2`](https://github.com/JetBrains/kotlin/releases/tag/v2.3.0-Beta2)
- Ktor release:
  - 3.3.2 — [`https://github.com/ktorio/ktor/releases/tag/3.3.2`](https://github.com/ktorio/ktor/releases/tag/3.3.2)
- Skiko release:
  - 0.9.35 — [`https://github.com/JetBrains/skiko/releases/tag/v0.9.35`](https://github.com/JetBrains/skiko/releases/tag/v0.9.35)

## Suggested Follow-ups
- **Set up automated competitor intel** (Growth/PM, weekly)
  - App Store/Play changelog scrapers for top apps (Tasty, Yummly, Whisk, Paprika, Mealime, Kitchen Stories, SideChef, AnyList).
  - Monitor official blogs/newsrooms and product update feeds; snapshot pricing/paywall screens monthly.
- **Trial library upgrades on a branch** (Platform, this sprint)
  - Incrementally bump Skiko → 0.9.35 and Ktor → 3.3.2; run `./gradlew check` and desktop/web smoke tests.
  - Stage Compose Multiplatform 1.9.3; assess 1.10.0 beta on a separate branch behind a flag.
- **UX study on TV/Automotive cooking flows** (Design/UX, next 2 weeks)
  - Prototype voice-guided steps and hands-free timers; evaluate large-type and high-contrast presets.
- **Shopping list + meal planning discovery** (Product/Backend, this month)
  - Scope pantry awareness, substitutions, and retailer export; identify minimal viable integration for a pilot.

## Appendix (optional)
- Monitoring scope checklist (starter):
  - App store releases, in-app changelogs, pricing/paywalls, feature flags surfaced in UI, partner logos/links, creator program T&Cs, social/blog announcements, and SDK release notes touching Compose/Kotlin, Ktor, Skiko, serialization, coroutines.
