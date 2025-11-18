## Recipe App Compose Multiplatform

Inspired by [Roaa Kadam](https://github.com/Roaa94) flutter [app](https://github.com/Roaa94/recipes_ui_app/), I wanted to do the same in Compose Multiplatform. There is a lot to explore in Compose Multiplatform from the aspect of this app like Heor Animation, Collapsable Toolbar, Staggered Animations, Gyroscope detection etc. 

> **Note**
> It is still a work in progress


### Live
You can find it live [here](https://seabdulbasit.github.io/recipe-app/)

## Supported Platforms
- Android
- iOS
- Desktop
- Web
- Android TV

![Screenshot 2023-10-08 at 1 23 46 PM](https://github.com/SEAbdulbasit/recipe-app/assets/33172684/bf0c9376-fb57-4498-80f6-4a72300cb8e9)

![Screenshot 2024-06-25 at 11 53 05 AM](https://github.com/Atif-09/recipe-app/assets/55842938/16e66d0b-48de-4403-bb74-e2788c756cc3)


## Demo

### iOS Demo
https://youtu.be/MZDgPtjTiIs

### Web Demo
https://www.youtube.com/watch?v=MZDgPtjTiIs&ab_channel=AbdulBasit

### Desktop Demo
https://www.youtube.com/watch?v=6mWrp_-MxW8&ab_channel=AbdulBasit



<img width="615" alt="Screenshot 2023-06-22 at 11 49 28 AM" src="https://github.com/SEAbdulbasit/recipe-app/assets/33172684/ac19c301-8263-4d2c-8cfc-58f27d1acdb3">


## Video Demo
You can watch the video demo [here](https://www.youtube.com/watch?v=99i21nB4sI0&ab_channel=AbdulBasit)

## Requirements
- JDK 21 is required (toolchain updated). If you see build errors about Java version, install a Java 21 JDK and ensure your IDE/Gradle use it.

## Sentry webhook → Cursor agent
There is a small Python server (`sentry_webhook_server.py`) that receives Sentry webhooks and forwards a crash prompt to Cursor Cloud.

1. Create `.env` in the repo root with your Cursor API key:
   ```
   CURSOR_KEY=your_cursor_api_key
   ```
2. Optional overrides: `CURSOR_REPO` (defaults to `https://github.com/Lukafin/recipe-app`), `CURSOR_BRANCH`, `CURSOR_AUTOCREATE_PR` (true/false), `CURSOR_MODEL`, `CURSOR_AGENT_URL`.
3. Run the server: `python3 sentry_webhook_server.py` (listens on `http://localhost:5001/webhook`).
4. Point Sentry’s webhook to that URL (or an ngrok tunnel) so crashes are forwarded to the Cursor agent.

## Sentry error tracking (Android)
The Android app integrates Sentry for crash/error reporting via the Sentry Gradle plugin and Manifest configuration.

- DSN is configured in `androidApp/src/androidMain/AndroidManifest.xml` using meta-data key `io.sentry.dsn`.
  - Replace the existing value with your project DSN from Sentry.
- Debug logging and tracing can be controlled via Manifest meta-data:
  - `io.sentry.debug` = `true|false`
  - `io.sentry.traces.sample-rate` = `0.0 - 1.0`

Quick crash test during development:
- In `shared/src/commonMain/kotlin/App.kt`, temporarily force a crash on item click by adding a `throw RuntimeException("test crash")` where indicated by the commented example.
- Run the Android app, reproduce the crash, and verify the event appears in Sentry and is forwarded to the webhook server if configured.

## Automation
- Monthly maintenance audit workflow: `.github/workflows/monthly-maintenance.yml`
- Weekly README update workflow: `.github/workflows/weekly-readme-update.yml`

## What’s new this week
- 2025-11-18: chore – Update maintenance prompt and add weekly README update workflow
- 2025-11-17: maintenance script permission change
- 2025-11-17: rename GitHub workflows and scripts folders
- 2025-11-17: feat – Add monthly maintenance audit workflow and scripts
- 2025-11-17: docs – Update README with Sentry webhook server instructions and enhance app crash handling
- 2025-11-17: feat – Enhance Sentry integration and add crash testing functionality
- 2025-11-17: feat – Add Sentry webhook server for local testing
- 2025-11-17: feat – Integrate Sentry for error tracking in Android app
- 2025-11-17: build – Update JVM toolchain to 21
