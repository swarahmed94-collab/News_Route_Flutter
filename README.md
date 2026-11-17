# News App — Flutter / Figma Export

A real Flutter source project implementing the user-provided **News** design (16 exported PNGs), with category navigation, NewsAPI source tabs, story cards, search, preview bottom sheet, article view, left drawer, light/dark styles, language selection, and a custom splash. **All bundled image assets come from the original user-provided ZIP.** There are **no third-party runtime packages**.

## What's in the archive

- `lib/`: actual Flutter UI, separate models, API service/repository and app state.
- `assets/reference/`: all **16 original Figma-export screens**, preserved unchanged.
- `assets/cards/`: 7 category cards in white/dark variants, extracted from those screenshots. Missing dark cards are local transformations, not external assets.
- `assets/photos/`, `assets/branding/`: crops from the same exported PNGs.
- `android/` and `ios/`: platform configuration and native article URL handling. **Runner-generated build metadata** must be initialized on a computer with Flutter installed (see next section).
- `test/`: local model/repository tests.

## Open and run (Android)

Flutter SDK **3.24+** recommended; Android SDK and Java 17 are required.

1. Extract the ZIP and open the **`News_Route_Flutter`** directory in VS Code or Android Studio.
2. Run once, from the project root:

   ```bash
   flutter create --platforms=android --project-name=news_route --org=com.newsroute .
   flutter pub get
   flutter run
   ```

   The `flutter create` step generates machine/platform build files such as `gradle-wrapper.jar` that cannot be bundled from this environment. Existing Dart source and cropped image assets should be retained. The source archive contains the app's custom Android `MainActivity.kt`, Internet permission, and locally made icon.

3. To use real NewsAPI results, obtain your **own** key from <https://newsapi.org> and start the app with:

   ```bash
   flutter run --dart-define=NEWS_API_KEY=YOUR_OWN_KEY
   ```

   On release builds, **do not ship an API key directly inside a public app**. Use a server-side proxy to protect it when deploying. No credential or proxy URL was provided, so no proxy is invented here.

## Open and run (iOS on macOS)

1. From the extracted project root run:

   ```bash
   flutter create --platforms=ios --project-name=news_route --org=com.newsroute .
   flutter pub get
   cd ios && pod install && cd ..
   flutter run --dart-define=NEWS_API_KEY=YOUR_OWN_KEY
   ```

   You need Xcode, CocoaPods and Apple signing for a physical device. The archive includes `ios/Runner/AppDelegate.swift` with the native URL method channel; create the Xcode project metadata using the Flutter command first.

## API integration — only documented NewsAPI routes

The originally shared documentation was <https://newsapi.org/docs>:

| Feature | HTTP route | Query fields | Header |
|---|---|---|---|
| Browse category | `GET /v2/top-headlines` | `country=us`, `category=<one of the 7 documented categories>` | `X-Api-Key` |
| Browse source | `GET /v2/top-headlines` | `sources=<id from sources endpoint>` | `X-Api-Key` |
| Load source tabs | `GET /v2/top-headlines/sources` | `category=<documented category>` | `X-Api-Key` |
| Search | `GET /v2/everything` | `q=<entered query>` | `X-Api-Key` |

The app parses **only** the published JSON keys `status`, `code`, `message`, `articles`, `sources`, `source`, `id`, `name`, `author`, `title`, `description`, `url`, `urlToImage`, `publishedAt`, and `content`. `sources` is never combined with `country` or `category` on article requests. If NewsAPI returns an error, its exact `message` is shown; no API fallback endpoints or invented fields exist.

### No key vs. real data

**No key provided:** the app runs in **offline Figma-preview mode**, with the two article snippets visible in the user's design and five source names printed in the exported image. This is explicitly **not** a live NewsAPI feed. The preview lets you inspect and navigate the UI without hiding broken requests behind fabricated articles. Search filters these locally supplied items.

**Key provided:** the app requests NewsAPI using the documented routes, populates real sources and headlines, searches the API on keyboard submission, and uses API-provided images (`urlToImage`) for real articles. The button in the article page opens the original `url` through the Android/iOS native system browser. NewsAPI returns only abbreviated `content`, not the full article.

**Important NewsAPI limitation:** its free Developer plan allows development/testing only, has a 24-hour article delay and a request quota. Production/published apps require a suitable subscription and secure server-side key handling. See <https://newsapi.org/pricing>.

## Tests

```bash
flutter analyze
flutter test
```

The Flutter SDK/Android emulator is **not installed in the file-generation environment**, so `flutter run`, `flutter analyze`, `flutter test` and APK signing cannot be executed here. The project files and local assets are supplied for testing in your Flutter environment; no false build-success claim is made.

## Original reference sheet

See `assets/reference/` for the original 16 untouched PNG exports (`Home*.png`, `Search*.png`, `Splash*.png`, `Frame 1.png`, `Frame 90.png`).
