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
- Android Automotive

## Requirements
- JDK 21 (toolchain configured in Gradle)
- Android SDK: compile/target SDK 35, min SDK 24

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

## Sentry webhook → Cursor agent
There is a small Python server (`sentry_webhook_server.py`) that receives Sentry webhooks and forwards a crash prompt to Cursor Cloud.

1. Create `.env` in the repo root with your Cursor API key:
   ```
   CURSOR_KEY=your_cursor_api_key
   ```
2. Optional overrides: `CURSOR_REPO` (defaults to `https://github.com/Lukafin/recipe-app`), `CURSOR_BRANCH`, `CURSOR_AUTOCREATE_PR` (true/false), `CURSOR_MODEL`, `CURSOR_AGENT_URL`.
3. Run the server: `python3 sentry_webhook_server.py` (listens on `http://localhost:5001/webhook`).
4. Point Sentry’s webhook to that URL (or an ngrok tunnel) so crashes are forwarded to the Cursor agent.

### Build and Run
- Fast sanity check (all targets): 
  ```
  ./gradlew check
  ```
- Desktop preview:
  ```
  ./gradlew :desktopApp:run
  ```
- Android builds:
  ```
  ./gradlew :androidApp:assembleDebug
  ./gradlew :tvApp:assembleDebug
  ./gradlew :automotiveApp:assembleDebug
  ```
- Web/WASM dev server:
  ```
  ./gradlew :webApp:wasmJsBrowserDevelopmentRun
  ```
- Web distribution (GitHub Pages):
  ```
  ./gradlew :webApp:wasmJsBrowserDistribution
  ```
  Then sync `webApp/build/dist/wasmJs/productionExecutable/` into `docs/`. Do not edit `docs/` manually; it’s the published build output.
- iOS: 
  ```
  cd iosApp && pod install
  open iosApp/iosApp.xcworkspace
  ```

### Automation and maintenance
- GitHub Actions:
  - Monthly maintenance audit: `.github/workflows/monthly-maintenance.yml`
  - Monthly competitive research: `.github/workflows/monthly-competitive-research.yml`
  - Weekly README update: `.github/workflows/weekly-readme-update.yml`
- Prompt templates used by the automation live under `.github/scripts/prompts/`.
- See `AGENTS.md` for an overview of automation, setup, and build instructions.
