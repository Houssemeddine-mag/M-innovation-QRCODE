# Technical Documentation — Innov QR Scan

This document describes how the project is built, how the pieces fit together, and what to know before changing the code. For a product overview, start with [README.md](README.md). For environment setup, see [SETUP.md](SETUP.md).

---

## 1. Scope

Innov QR Scan is a Flutter application that generates QR codes from:

- a URL entered by the user;
- a file selected from the device.

The current release is **0.1.0**. It generates and exports QR images. It does **not** scan QR codes, keep history, or upload files through the UI.

---

## 2. Tech stack

| Layer | Technology |
| --- | --- |
| Framework | Flutter (Material 3) |
| Language | Dart, SDK `^3.8.1` |
| QR rendering | `qr_flutter` |
| File selection | `file_picker` |
| File system paths | `path_provider` |
| Sharing | `share_plus` |
| Gallery save | `gal` |
| Permissions | `permission_handler` |
| Optional cloud storage | `firebase_core`, `firebase_storage` |
| Linting | `flutter_lints` |
| App icons | `flutter_launcher_icons` |

There is no state-management package, router, dependency-injection container, or local database. The app uses `StatefulWidget` + `setState` and a single screen.

---

## 3. Requirements

- Flutter SDK compatible with Dart `^3.8.1`
- Android Studio with the Android SDK
- An Android emulator or a physical Android device
- For release builds: your own signing configuration

Only Android is required. iOS, desktop, and web are not supported.

Verify the toolchain with:

```bash
flutter doctor
flutter --version
```

---

## 4. Architecture

The app follows a simple layered structure: entry point → screen → widgets → model/services.

```text
main.dart
└── QRCodeGeneratorApp (MaterialApp, light/dark Material 3 themes)
    └── HomeScreen (owns all state)
        ├── SegmentedButton<InputType>      switches URL / File mode
        ├── InputSection                    URL text field + generate button
        ├── File picker (inline Card)       chooses a file
        └── QRDisplayWidget                 renders and exports the QR code
            ├── QrImageView                 qr_flutter rendering
            ├── RepaintBoundary → PNG       capture at 3x pixel ratio
            ├── share_plus                  system share sheet
            └── gal                         save to device gallery
```

Key characteristics:

- **Single screen.** `HomeScreen` is the only routed screen.
- **Local state.** `_currentQRData`, `_isLoading`, and `_selectedInputType` live in `_HomeScreenState`.
- **No persistence.** Closing the app discards the current QR code.
- **Offline by default.** No network call is required for generation, saving, or sharing.

---

## 5. Project structure

```text
qrc/
├── lib/
│   ├── main.dart                        # App entry point, themes, home screen
│   ├── config/
│   │   └── firebase_config_template.dart # Comment-only Firebase configuration reference
│   ├── models/
│   │   └── qr_data.dart                 # QRData model and display formatting
│   ├── screens/
│   │   ├── home_screen.dart             # Main screen and app state
│   │   └── onboarding_screen.dart       # Empty placeholder (not routed)
│   ├── services/
│   │   └── file_storage_service.dart    # Optional Firebase Storage upload helper
│   ├── widgets/
│   │   ├── input_section.dart           # URL input card
│   │   └── qr_display_widget.dart       # QR preview, save, and share
│   └── resource/
│       └── Design sans titre.png        # Source image for launcher icons
├── test/
│   └── qr_data_test.dart                # Unit tests for QRData
├── android/                             # Supported platform
├── ios/                                 # Unverified scaffolding (not supported)
├── web/                                 # Unverified scaffolding (not supported)
├── windows/ macos/ linux/               # Unverified scaffolding (not supported)
├── pubspec.yaml                         # Dependencies and icon configuration
├── analysis_options.yaml                # flutter_lints configuration
├── documentation.md                     # This file
├── README.md                            # Product overview
├── SETUP.md                             # Setup and Firebase guide
├── USER_GUIDE.md                        # End-user guide
├── CHANGELOG.md                         # Version history
├── APP_ICON_SETUP.md                    # Icon generation notes
└── BUILD_FIX.md                         # Gallery dependency fix notes
```

---

## 6. Application flow

### Startup

1. `main()` calls `runApp(const QRCodeGeneratorApp())`.
2. `QRCodeGeneratorApp` builds a `MaterialApp` with:
   - `title: 'Innov QR Scan'`
   - a deep-purple seeded `ColorScheme` for light and dark themes;
   - `themeMode: ThemeMode.system`;
   - `home: HomeScreen()`.
3. Firebase is **not** initialized at startup.

### URL flow

1. The user enters text in `InputSection`.
2. `_generateQRFromURL()` trims the value.
3. Empty input shows an orange snackbar and returns.
4. Otherwise `_currentQRData = QRData(type: QRDataType.url, data: url)`.
5. `QRDisplayWidget` renders the value with `QrImageView`.

There is no URL scheme validation or normalization beyond trimming.

### File flow

1. The user taps **Choose File**.
2. `FilePicker.platform.pickFiles(type: FileType.any)` opens the system picker.
3. On success, `_currentQRData = QRData(type: QRDataType.file, data: file.path!, fileName: file.name, fileSize: file.size)`.
4. The QR payload is the **local file path**; the file contents are not encoded or uploaded.
5. `QRDisplayWidget` renders the path. The UI displays the file name and formatted size instead of the raw path.

### Export flow

- **Share:** `RepaintBoundary.toImage(pixelRatio: 3.0)` → PNG bytes → temporary file → `Share.shareXFiles(...)`.
- **Save:** request `Permission.photos` on Android/iOS (iOS is not a supported target) → capture the same PNG → write to the temporary directory → `Gal.putImage(path)`.
- Errors are caught and shown in a red snackbar.

### Reset

- The app-bar clear button sets `_currentQRData = null` and clears the text controller.
- Switching input type also clears the current QR data and URL text.

---

## 7. Core modules

### `lib/main.dart`

Defines `QRCodeGeneratorApp` and configures Material 3 theming. No business logic.

### `lib/models/qr_data.dart`

```dart
enum QRDataType { url, file }

class QRData {
  final QRDataType type;
  final String data;
  final String? fileName;
  final int? fileSize;
}
```

- `data` is the exact string encoded into the QR code.
- `displayData` returns the URL for link codes, or `File: <name> (<size>)` for file codes.
- `_formatFileSize()` converts bytes to B, KB, MB, or GB with two decimal places.

### `lib/screens/home_screen.dart`

The state owner. Responsibilities:

- toggling between `InputType.url` and `InputType.file`;
- validating that a URL is not empty;
- opening the file picker and handling errors;
- building the input and display widgets;
- showing snackbars.

The `InputType` enum is declared at the bottom of this file, separate from `QRDataType`.

### `lib/widgets/input_section.dart`

A stateless card containing:

- a `TextField` with URL keyboard type and an outline border;
- a clear suffix icon when text is present;
- a generate button.

Note: the clear-icon visibility is refreshed with `(context as Element).markNeedsBuild()` inside `onChanged`. This is a workaround, not the preferred pattern; a `StatefulWidget` or `ValueListenableBuilder` would be cleaner.

### `lib/widgets/qr_display_widget.dart`

A stateful widget that:

- renders `QrImageView` with `QrVersions.auto`, size 250, and a white background;
- shows an inline error state if the payload is too large or invalid;
- captures the `RepaintBoundary` for sharing and saving;
- tracks `_isSaving` to disable buttons and show progress;
- uses `dart:io` and platform-specific packages.

Because this file imports `dart:io`, the project cannot currently compile for web without platform guards.

### `lib/services/file_storage_service.dart`

An optional helper around Firebase Storage:

- `uploadFile(File, String)` uploads to `qr_files/<timestamp>_<filename>` and returns a download URL;
- `deleteFile(String url)` deletes by URL;
- `initializeFirebase()` calls `Firebase.initializeApp()`.

It is **not referenced by the UI**. To use it, Firebase must be configured and initialized, and `HomeScreen` must call `uploadFile()` instead of encoding the local path.

### `lib/config/firebase_config_template.dart`

A comment-only reference showing the shape of `DefaultFirebaseOptions` and the FlutterFire CLI command. It contains no executable configuration.

### `lib/screens/onboarding_screen.dart`

Currently empty and not referenced anywhere. Either implement and route it, or remove it.

---

## 8. Dependencies

Declared in `pubspec.yaml`:

| Package | Version | Used for | Status |
| --- | --- | --- | --- |
| `qr_flutter` | `^4.1.0` | QR rendering | Active |
| `file_picker` | `^8.1.4` | Selecting any file type | Active |
| `path_provider` | `^2.1.5` | Temporary directory for exported PNGs | Active |
| `share_plus` | `^10.1.2` | System share sheet | Active |
| `gal` | `^2.3.0` | Saving images to the gallery | Active |
| `permission_handler` | `^11.3.1` | Photo-library permission | Active |
| `url_launcher` | `^6.3.1` | Opening URLs | **Not used in code** |
| `firebase_storage` | `^12.3.6` | Optional file uploads | Helper only |
| `firebase_core` | `^3.8.1` | Optional Firebase initialization | Helper only |
| `flutter_launcher_icons` | `^0.14.1` | Launcher icon generation (dev) | Active |
| `flutter_lints` | `^5.0.0` | Lint rules (dev) | Active |

`pubspec.lock` pins the resolved versions and should be committed for applications.

---

## 9. Platform status and configuration

Only **Android** is supported and verified. The other platform folders are scaffolding and are not expected to build or run correctly.

| Platform | Status |
| --- | --- |
| Android | **Supported and verified** |
| iOS | **Not supported** — the Xcode project exists, but there is no `Podfile`/Pods setup and no verified build |
| Windows / macOS / Linux | **Not supported** — Flutter scaffolding only |
| Web | **Not supported** — `dart:io` imports prevent compilation |

### Android

- Application ID and namespace: `com.example.qrc` (change before publishing).
- `minSdk`, `targetSdk`, and `compileSdk` inherit from the Flutter Gradle plugin.
- NDK version is pinned to `27.0.12077973`.
- Java/Kotlin target: 11.
- Release builds currently use the **debug signing config**; configure a real keystore before distribution.
- App label: `Innov QR Scan`.
- Launcher icon: `@mipmap/ic_launcher`.

Permissions in `android/app/src/main/AndroidManifest.xml`:

| Permission | Purpose |
| --- | --- |
| `INTERNET` | Network access (future/optional Firebase use) |
| `READ_EXTERNAL_STORAGE` | Reading selected files on older Android versions |
| `WRITE_EXTERNAL_STORAGE` (`maxSdkVersion=32`) | Saving on Android 12 and below |
| `READ_MEDIA_IMAGES` | Media access on Android 13+ |
| `READ_MEDIA_VIDEO` | Media access on Android 13+ |
| `READ_MEDIA_AUDIO` | Media access on Android 13+ |

### iOS

**Not supported.** The `ios/` folder exists, but the project has no `Podfile` or Pods installation and no iOS build has been verified.

`ios/Runner/Info.plist` declares the following keys, which would be relevant only if iOS support is added later:

| Key | Purpose |
| --- | --- |
| `NSPhotoLibraryUsageDescription` | Access to the photo library |
| `NSPhotoLibraryAddUsageDescription` | Saving QR codes to the photo library |
| `NSCameraUsageDescription` | Reserved for the planned scanner feature |

Display name: `Innov QR Scan`.

### Web and desktop

- **Not supported.** Host projects exist for web, Windows, macOS, and Linux, but they are scaffolding only.
- Web does not compile because of `dart:io` imports in `qr_display_widget.dart` and `file_storage_service.dart`.
- Desktop builds have not been verified. `gal`, `permission_handler`, and `share_plus` behavior varies by platform.
- Treat Android as the only supported target.

---

## 10. Setup and commands

### Install dependencies

```bash
flutter pub get
```

### Run

```bash
flutter run
flutter devices
flutter run -d <device-id>
```

### Analyze and test

```bash
flutter analyze
flutter test
```

### Build

```bash
# Android (supported)
flutter build apk --debug
flutter build apk --release
flutter build appbundle --release
```

The following targets are **not supported** and are not expected to build without additional configuration:

```bash
# flutter build ios --release      # no Podfile/Pods setup; requires macOS + Xcode
# flutter build windows
# flutter build macos
# flutter build linux
# flutter build web                # blocked by dart:io imports
```

### Clean

```bash
flutter clean
flutter pub get
```

### Regenerate launcher icons

```bash
dart run flutter_launcher_icons
```

The source image is configured in `pubspec.yaml` as `lib/resource/Design sans titre.png`. Replace it with a 1024×1024 PNG, run the command, and rebuild.

---

## 11. Optional Firebase Storage integration

The repository includes a ready-to-use service but no active Firebase setup. The basic app works without it.

High-level steps (full details in [SETUP.md](SETUP.md)):

1. Create a Firebase project.
2. Register the Android app with package `com.example.qrc`. Register an iOS app only if you add iOS support.
3. Download `google-services.json` into `android/app/` and/or `GoogleService-Info.plist` into `ios/Runner/`.
4. Add the Google Services Gradle plugin to the Android project.
5. Enable Firebase Storage and configure security rules.
6. Initialize Firebase in `main.dart` before `runApp`.
7. Call `FileStorageService().uploadFile(file, name)` and encode the returned download URL instead of the local path.

Security notes:

- Do not ship permissive test-mode Storage rules.
- Restrict uploads by authentication, size, and content type.
- Treat download URLs as public if the rules allow public reads.

---

## 12. Testing

Existing coverage is limited to the data model in `test/qr_data_test.dart`:

- URL payload display;
- file payload display with name and size;
- B/KB/MB/GB formatting;
- missing file name fallback to `Unknown`;
- zero-byte formatting.

Run with:

```bash
flutter test
```

There are no widget or integration tests. A manual checklist for release verification:

- [ ] Generate a QR code from a valid URL.
- [ ] Verify empty input shows a validation message.
- [ ] Generate a QR code from a file of each common type (image, PDF, video).
- [ ] Save the QR code and confirm it appears in the gallery.
- [ ] Share the QR code and confirm the system sheet opens.
- [ ] Clear the QR code and switch between input types.
- [ ] Verify light and dark themes.
- [ ] Verify behavior on Android 12 and below, and Android 13+.
- [ ] Verify behavior on Android with permission denied and granted.

---

## 13. Build history

- **Gallery dependency fix (October 2025):** `image_gallery_saver` 2.0.3 failed with *"Namespace not specified"* under newer Android Gradle Plugin versions. It was replaced with `gal` 2.3.0. See [BUILD_FIX.md](BUILD_FIX.md).
- **Launcher icons:** Generated with `flutter_launcher_icons` 0.14.x for Android and iOS assets, including adaptive Android icons with a white background. Only the Android icons are part of a supported build. See [APP_ICON_SETUP.md](APP_ICON_SETUP.md).

---

## 14. Known limitations and technical debt

| Area | Issue |
| --- | --- |
| File QR semantics | The payload is the local file path. Other devices cannot resolve it. |
| Firebase | `FileStorageService` is implemented but not wired into the UI; Firebase is not initialized. |
| Onboarding | `onboarding_screen.dart` is empty and unrouted. |
| URL validation | Only emptiness is checked; no scheme check, normalization, or reachability test. |
| Unused dependency | `url_launcher` is declared but not used. |
| Input rebuild | `InputSection` calls `markNeedsBuild()` from `onChanged` instead of using state or a listenable. |
| Permissions | `Permission.photos` behavior differs across Android versions; the save flow should be tested on Android 12 and below. |
| Web | Not supported; `dart:io` imports block web compilation. |
| Desktop | Not supported; scaffolding only, builds not verified. |
| iOS | Not supported; no Podfile/Pods setup and no verified build. |
| Release readiness | App ID is still `com.example.qrc`, and release builds are signed with debug keys. |
| CI/CD | No automated pipeline for analyze, test, or build. |
| Placeholder files | `BUILD_STATUS.md`, `BUILD_WORKAROUND.md`, and `build-and-install.ps1` are empty. |

Recommended next steps, in order:

1. Replace the local file path with a hosted URL or clearly label file QR codes as device-local.
2. Wire Firebase uploads behind a feature flag or a "Upload and share" action.
3. Add URL validation and normalization.
4. Remove or implement the onboarding screen and the unused dependency.
5. Add widget tests for the main flow.
6. Set a production application ID and signing configuration.
7. Add a CI workflow running `flutter analyze` and `flutter test`.

---

## 15. Extending the app

### Add a new QR content type

1. Add a value to `QRDataType` in `lib/models/qr_data.dart`.
2. Extend `displayData` for the new type.
3. Add an input branch in `HomeScreen` (or a dedicated widget) and build the payload string.
4. Add unit tests for the new display formatting.
5. Update [README.md](README.md), [USER_GUIDE.md](USER_GUIDE.md), and this document.

### Add the scanner feature

1. Add a camera/scanning package (for example `mobile_scanner`).
2. Request camera permission and update platform manifests if needed.
3. Add a new screen and a navigation entry point.
4. Handle scanned values safely; do not auto-open untrusted URLs without confirmation.

### Add history

1. Choose local storage (`sqflite`, `hive`, or `shared_preferences`).
2. Persist payload, type, timestamp, and an optional preview path.
3. Add a history screen with delete and re-share actions.
4. Decide whether history is device-local or synced.

---

## 16. Troubleshooting

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| `Namespace not specified` during Android build | Old gallery plugin | Confirm `gal` is used, not `image_gallery_saver` |
| `Firebase has not been initialized` | Calling `FileStorageService` without setup | Initialize Firebase in `main.dart` or remove the call |
| QR code shows an error state | Payload too long or invalid | Shorten the URL/path or host the file and encode a link |
| Save fails on Android | Permission model differs by version | Verify manifest permissions and test `Permission.photos` / storage handling |
| Save fails on desktop/web | Gallery plugin unsupported | Use Share instead, or add platform guards |
| Web build fails | `dart:io` imports | Add conditional imports or move file operations behind platform checks |
| Icon did not change | Launcher cache | `flutter clean`, rebuild, uninstall and reinstall |
| Share sheet does not open | Platform share plugin issue | Verify `share_plus` setup and test on a physical device |

---

## 17. Repository notes

- `README.md` is the product overview; this file is the technical reference.
- `SETUP.md`, `USER_GUIDE.md`, `CHANGELOG.md`, `APP_ICON_SETUP.md`, and `BUILD_FIX.md` contain older, more detailed notes and remain valid references.
- `BUILD_STATUS.md`, `BUILD_WORKAROUND.md`, and `build-and-install.ps1` are zero-byte placeholders. They can be filled in or removed.
- `Nouveau dossier/` is an empty directory.
- `lib/resource/Design sans titre.png` is the icon source, not a UI asset loaded at runtime.

---

## 18. Conventions

- Follow `flutter_lints` (`analysis_options.yaml`).
- Use Material 3 widgets and theme colors instead of hard-coded colors where possible.
- Keep widgets small and focused; put reusable UI in `lib/widgets/`.
- Keep business/data types in `lib/models/`.
- Use relative imports within `lib/`.
- Update tests and documentation with behavior changes.
- Do not commit secrets, Firebase service files for private projects, or signing keys.

---

_Last updated: November 2026 · App version 0.1.0_
