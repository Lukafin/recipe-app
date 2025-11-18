# November 2025 Recipe App Competitive Digest

## Executive Summary
- **No live web access in this environment; external updates could not be verified.** This digest frames likely areas of impact and concrete follow-ups to gather and validate sources.
- **Expected focus areas this month**: AI-assisted cooking (planning, step-by-step copilots), shopping-list/grocery delivery integrations, and lean TV/Automotive guided-cooking flows. These have clear UX implications for a Compose Multiplatform app like ours.
- **Tech posture**: Kotlin/Compose Multiplatform continues to mature; maintain alignment with current Android SDK 35 and ensure compatibility across iOS/Desktop/Web/WASM while monitoring compose compiler/plugin version alignment.

## Feature & UX Highlights
Below are themes and placeholders to fill with verified items upon running web queries. Keep the structure for easy monthly updates.

| Competitor | Date (Nov 2025) | Platforms | What | Why it matters |
|---|---|---|---|---|
| TBD (e.g., Tasty, Yummly, NYT Cooking, Allrecipes, Mealime, Paprika, SideChef, Kitchen Stories) | TBD | Android, iOS, Web, TV | Pending verification: AI meal-planning, smart shopping cart, voice-guided cooking, offline packs, family profiles | Guides priorities for AI-powered flows, shopping sync, and living-room/Auto experiences |

Additional areas to validate when online:
- **AI copilots**: natural-language recipe transforms (scale, substitute, dietary constraints), multimodal steps (voice + visuals), and pause/resume state across devices.
- **Meal planning & calendars**: weekly meal plans, nutrition targets, pantry-aware suggestions.
- **Shopping integrations**: list sync across devices, grocery retailer partnerships, substitutions, delivery ETA visibility.
- **TV & Automotive**: large-type, step-focused UI, voice navigation, glanceable timers, offline caching.
- **Creator/UGC**: recipe submissions, reviews, short-form how-tos, creator monetization.

## Monetization & Partnerships
- **Subscriptions**: tiering around AI features (meal planning, nutrition breakdown), family profiles, and offline recipe packs.
- **Bundles/Partnerships**: grocery delivery tie-ins, kitchen hardware bundles (smart displays), or nutrition-service bundles for retention.
- **Ads & attribution**: shoppable ingredients, retailer affiliate links, and clear disclosure patterns.

## Tech & Platform Notes
- **Current repo targets**: Android `compileSdk/targetSdk 35`, `minSdk 24` per `gradle.properties`. Compose Multiplatform used across Android, iOS, Desktop, Web/WASM, TV, Automotive.
- **Version alignment**: Ensure consistency between `gradle.properties` and `gradle/libs.versions.toml` (kotlin, compose plugin, AGP, compose compiler) to avoid toolchain drift.
- **Cross-platform UX**: Favor shared UI in `shared/src/commonMain/kotlin` with thin platform shells; keep TV/Auto flows step-centric with large touch targets and voice support.
- **Accessibility**: Prefer high-contrast themes, scalable typography, and focus order suitable for TV/Automotive remotes and keyboard navigation on Desktop/Web.

## Sources
- Project repo: `https://github.com/Lukafin/recipe-app`
- Prompt context (verbatim):
  - Repository: https://github.com/Lukafin/recipe-app (current working repo)
  - Platforms: Android, iOS, Desktop, Web/WASM, TV, and Android Automotive; shared UI/navigation lives in `shared/src/commonMain/kotlin`.
  - Output folder: ai-competitive-intel/
  - Goal: surface notable recipe and cooking app moves from the past month—feature launches, UX patterns, AI-assisted cooking capabilities, meal planning/shopping integrations, monetization/pricing trials, distribution partnerships, and relevant Compose/Kotlin multiplatform library updates that could influence this app's direction.
- General sources for verification (collect when online):
  - App store listings/changelogs: `Tasty`, `Yummly`, `Allrecipes`, `NYT Cooking`, `Mealime`, `Paprika`, `SideChef`, `Kitchen Stories` (Google Play and App Store pages)
  - Product blogs and press pages for the above apps
  - Compose Multiplatform releases: `https://github.com/JetBrains/compose-multiplatform/releases`
  - Kotlin Multiplatform updates: `https://kotlinlang.org/blog/`

## Suggested Follow-ups
- **Run web queries and fill the table**: PM/research to collect 6–10 concrete items (links + dates) across AI features, shopping, TV/Auto, and pricing. Deadline: 2 business days.
- **Validate monetization trends**: PM to snapshot subscription tiers and trial funnels for top 5 competitors, with screenshots and pricing notes. Deadline: 3 business days.
- **Prototype guided-cooking flow (TV/Auto)**: Design + Eng to draft a step-by-step voice-first flow in `shared` UI; add timers and large-style controls. Checkpoint: clickable prototype in 1 week.
- **Version alignment audit**: Eng to review `gradle.properties` vs `gradle/libs.versions.toml` and propose a unification plan for Kotlin, Compose plugin, AGP, and compose compiler versions. Checkpoint: PR in 3 days.

## Appendix (optional)
- Query pack to run when online:
  - "<competitor> app update November 2025" (Tasty, Yummly, Allrecipes, NYT Cooking, Paprika, Mealime, SideChef, Kitchen Stories)
  - "<competitor> AI cooking", "meal planning", "shopping list integration", "grocery delivery partnership"
  - "site:medium.com <competitor> product", "site:blog.* <competitor>"
  - "Compose Multiplatform release November 2025", "Kotlin Multiplatform release November 2025"
- Internal references:
  - Shared UI/navigation lives in `shared/src/commonMain/kotlin`.
  - Android builds via `./gradlew :androidApp:assembleDebug`; Web/WASM via `./gradlew :webApp:wasmJsBrowserDistribution`.
