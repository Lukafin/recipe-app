# October 2025 Recipe App Competitive Digest

## Executive Summary
- Due to missing external research access in this environment, no verifiable, up-to-date announcements could be collected this cycle. The sections below outline what to monitor, how to validate quickly, and the most impactful areas for this Compose Multiplatform app.
- Highest-leverage watch areas remain: AI-assisted cooking (context-aware guidance, vision-based recognition), meal planning with grocery integrations, and big-screen/voice-first guided cooking flows (TV and Automotive) that align well with this project’s multiplatform footprint.
- The team should run the follow-up research checklist (included) to rapidly populate sources and confirm specific launches, pricing experiments, and library updates.

## Feature & UX Highlights
> No specific launches verified this month. Use the checklist below to populate quickly once research tools are available.

| Competitor | Launch/Announce Date | Platforms | Summary | Why It’s Relevant |
|---|---|---|---|---|
| (TBD) Tasty | (TBD) | Android, iOS, Web, TV | (Pending verification) | Short-form video + guided steps can inform TV/Automotive flows |
| (TBD) Yummly | (TBD) | Android, iOS | (Pending verification) | AI assistance + smart appliance tie-ins map to device integrations |
| (TBD) Allrecipes | (TBD) | Android, iOS, Web | (Pending verification) | At-scale community and shopping list flows worth benchmarking |
| (TBD) NYT Cooking | (TBD) | Android, iOS, Web | (Pending verification) | Premium UX patterns, saved collections, and personalization |
| (TBD) Paprika | (TBD) | Android, iOS, Desktop | (Pending verification) | Offline-first and robust parsing UX; sync patterns |
| (TBD) Mealime | (TBD) | Android, iOS | (Pending verification) | Meal planning → grocery cart conversion flow |
| (TBD) SideChef | (TBD) | Android, iOS, Smart Displays | (Pending verification) | Voice-guided cooking and smart kitchen integrations |
| (TBD) Kitchen Stories | (TBD) | Android, iOS, TV | (Pending verification) | Editorial video + step-by-step guidance for big screens |

## Monetization & Partnerships
- (Pending verification) Track any changes in subscription pricing, trials, family plans, and bundles for major players (e.g., NYT Cooking upsells, Paprika one-time pricing, Mealime subscription tiers).
- (Pending verification) Look for grocery delivery/retail partnerships (Instacart, Walmart, Amazon Fresh) and whether meal plans convert into carts natively or via deep links.
- (Pending verification) Creator programs or UGC-driven revenue splits (paywalled recipe collections, tip jars, affiliate links for cookware/ingredients).

## Tech & Platform Notes
- (Pending verification) Kotlin/Compose Multiplatform: review latest Compose Multiplatform release notes (stability/performance, resource loading, accessibility) for potential adoption across Android, iOS, Desktop, WASM, TV, and Automotive.
- (Pending verification) WASM/Web: track Skiko/Skia improvements and any hydration or partial-render patterns that could shrink `docs/` footprint.
- (Pending verification) Accessibility: big-screen voice/remote patterns and readable typography updates for TV/Automotive are likely maturing; evaluate voice-first step navigation.
- (Pending verification) Performance: image pipeline and font loading for WASM; split assets and lazy-load large drawables; measure startup on low-end Android TV devices.

## Sources
- Research could not be performed here due to lack of external search tooling. Run the follow-up checklist to gather links from:
  - App Store/Play Store changelogs for: Tasty, Yummly, Allrecipes, NYT Cooking, Paprika, Mealime, SideChef, Kitchen Stories
  - Official product blogs, press pages, and release notes
  - Grocery/retail partners (Instacart, Walmart, Amazon Fresh) for integration news
  - Kotlin/Compose Multiplatform and Skiko releases, Android/iOS platform notes
- Repository (current working repo): `https://github.com/Lukafin/recipe-app`
- Supplemental context (verbatim from prompt): Platforms: Android, iOS, Desktop, Web/WASM, TV, and Android Automotive; shared UI/navigation lives in `shared/src/commonMain/kotlin`. Output folder: `ai-competitive-intel/`.

## Suggested Follow-ups
- **Run the research checklist (owner: Product/Research, 1–2 days)**:
  - App store review: extract last 30–45 days of changelog items per competitor; copy links into Sources.
  - Blogs/press: scan official posts and social announcements; add dates, platform coverage, and feature summaries.
  - Partnerships: search for “<app> Instacart/Walmart/Amazon Fresh” and “meal plan cart” updates.
  - Pricing: note plan names, prices, trials, family bundles; capture screenshots where allowed.
  - Tech: record latest Compose Multiplatform/Skiko/Kotlin release notes and breaking changes.
- **Populate the table (owner: PM/Design, 0.5 day)**: Fill Feature & UX Highlights with 6–10 concrete entries and links; tag each with “Relevance” for this app.
- **Decide near-term bets (owner: Eng/PM, 0.5 day)**: Pick 1–2 features to prototype (e.g., voice-guided steps on TV, improved shopping list sync) and create tickets.
- **Set monthly cadence (owner: PM Ops, ongoing)**: Re-run this checklist monthly and store outputs in `ai-competitive-intel/`.

## Appendix (optional)
- Monitoring search strings to paste into a research tool:
  - "Tasty app update"; site:apps.apple.com OR site:play.google.com
  - "Yummly AI features"; "Yummly smart oven"; "Yummly update changelog"
  - "Allrecipes app update" "shopping list"
  - "NYT Cooking subscription price" "new features"
  - "Paprika app update" "release notes"
  - "Mealime grocery" "cart" "Instacart" "Walmart"
  - "SideChef voice guided" "smart display"
  - "Kitchen Stories TV app" "update"
  - "Compose Multiplatform release notes" "Skiko" "Kotlin multiplatform"
