# Innov QR Scan

**Turn links and files into scannable QR codes — in seconds.**

Innov QR Scan is a Flutter application that creates QR codes from web links or files on your device. It is built for speed and simplicity: open the app, choose what you want to share, and get a clean, high-quality QR code that you can save or send anywhere.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.8%2B-0175C2?logo=dart&logoColor=white)
![Version](https://img.shields.io/badge/version-0.1.0-blue)
![Platforms](https://img.shields.io/badge/platforms-Android%20only-3DDC84?logo=android&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)

---

## Overview

QR codes are the shortest path between the physical and digital world. Innov QR Scan gives you a focused tool for creating them without accounts, ads, or unnecessary steps.

The app currently supports two input types:

- **Links** — encode any URL into a QR code.
- **Files** — select a file from your device and generate a QR code that references it.

Everything is generated locally on your device. Nothing is uploaded or tracked by the app.

> **In one sentence:** Innov QR Scan is a lightweight QR code maker for people who want to share a link or a file quickly and cleanly.

---

## What you can do with it

| Use case | Example |
| --- | --- |
| Share a website or portfolio | Encode `https://your-site.com` and add it to a poster or business card |
| Share social profiles | Link to Instagram, LinkedIn, GitHub, or any other profile |
| Share documents | Point to a PDF menu, brochure, form, or price list |
| Share media | Reference images, videos, or audio files |
| Event handouts | Put a QR code on a flyer, slide deck, or name badge |
| Quick device handoff | Create a code that points to a file on your own device |

---

## Features

- **Link to QR** — paste a URL and generate a QR code instantly.
- **File to QR** — pick any file type (images, videos, PDFs, documents, and more) and generate a code for it.
- **High-quality output** — QR codes are rendered at 3x resolution when saved or shared.
- **Save to gallery** — store the generated QR code as a PNG on Android.
- **Share anywhere** — send the QR image through any app installed on your device.
- **Clear and start over** — reset the current code with one tap.
- **Material 3 design** — a clean interface that follows your system light or dark theme.
- **No account required** — the app works without sign-up, cloud storage, or an internet connection.

---

## Supported platforms

**Only Android is currently supported and tested.**

The repository contains Flutter host projects for other platforms, but they have not been built, configured, or verified. Do not expect them to work without additional setup.

| Platform | Status |
| --- | --- |
| Android | **Supported** — the only verified target |
| iOS | **Not supported** — the Xcode project exists, but there is no Podfile/Pods setup and no verified iOS build |
| Windows / macOS / Linux | **Not supported** — Flutter scaffolding only |
| Web | **Not supported** — the app uses `dart:io` and does not compile for web |

---

## Getting started

### 1. Install Flutter

Install a recent stable Flutter SDK with Dart 3.8.1 or newer from [flutter.dev](https://flutter.dev/docs/get-started/install).

### 2. Get the project

```bash
git clone <your-repository-url>
cd qrc
flutter pub get
```

### 3. Run it

```bash
flutter run
```

That is all you need for the current feature set. Firebase is **not** required to run the app.

For device setup, platform configuration, and optional Firebase integration, see [documentation.md](documentation.md) or [SETUP.md](SETUP.md).

---

## Using the app

### Create a QR code from a link

1. Open the app and stay on the **URL/Link** tab.
2. Enter or paste a URL, for example `https://example.com`.
3. Tap **Generate QR Code**.
4. The QR code appears below the input.
5. Tap **Save** to add it to your gallery, or **Share** to send it.

### Create a QR code from a file

1. Switch to the **File** tab.
2. Tap **Choose File**.
3. Select any file from your device.
4. The QR code is generated automatically and the file name and size are shown.
5. Tap **Save** or **Share**.

### Start over

Tap the **clear** icon in the top-right corner to remove the current QR code and reset the form.

A more detailed walkthrough is available in [USER_GUIDE.md](USER_GUIDE.md).

---

## Good to know

- **File QR codes reference a local path.** The generated code contains the path of the selected file, not the file itself. It is most useful as a reference on the same device. To share a file with other people, host it online (Google Drive, Dropbox, a website) and encode that link instead.
- **This is a generator, not a scanner.** The name says "Scan", but scanning is a planned feature. The current release creates QR codes only.
- **Save to gallery is Android-only in the current release.** Sharing works through your device's system share sheet.
- **Internet is not required.** QR codes are created locally. The Firebase helper included in the project is optional and is not active in the current UI.
- **Large or complex data may not fit in a QR code.** Shorter links produce simpler, easier-to-scan codes.

---

## Project structure

```text
qrc/
├── lib/
│   ├── main.dart                 # App entry point and theme
│   ├── config/                   # Optional Firebase configuration notes
│   ├── models/                   # QR data model
│   ├── screens/                  # App screens
│   ├── services/                 # Optional cloud file storage helper
│   ├── widgets/                  # Reusable UI components
│   └── resource/                 # App icon source image
├── test/                         # Unit tests
├── android/                      # Supported platform
├── ios/ web/                     # Unverified scaffolding (not supported)
├── windows/ macos/ linux/        # Unverified scaffolding (not supported)
├── documentation.md              # Technical documentation
├── SETUP.md                      # Environment and Firebase setup
├── USER_GUIDE.md                 # End-user guide
└── CHANGELOG.md                  # Release history
```

---

## Documentation

| Document | What it covers |
| --- | --- |
| [documentation.md](documentation.md) | Architecture, code structure, dependencies, build and test details |
| [SETUP.md](SETUP.md) | Flutter setup, platform configuration, optional Firebase Storage |
| [USER_GUIDE.md](USER_GUIDE.md) | Step-by-step instructions for end users |
| [CHANGELOG.md](CHANGELOG.md) | Version history and planned work |
| [APP_ICON_SETUP.md](APP_ICON_SETUP.md) | How the launcher icon is generated |
| [BUILD_FIX.md](BUILD_FIX.md) | Notes on the gallery-saving dependency fix |

---

## Roadmap

- [ ] QR code scanning
- [ ] History of generated QR codes
- [ ] Custom QR styling (colors, gradients, logos)
- [ ] vCard, Wi-Fi, and calendar QR codes
- [ ] Upload large files and encode a shareable cloud link
- [ ] Batch generation from a CSV or spreadsheet
- [ ] Export as SVG and PDF
- [ ] Localization and accessibility improvements

See [CHANGELOG.md](CHANGELOG.md) for the full list.

---

## Contributing

Contributions are welcome.

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/your-feature`.
3. Make your changes and run `flutter analyze` and `flutter test`.
4. Commit with a clear message.
5. Open a pull request describing what changed and why.

Please keep changes focused, follow the existing Material 3 style, and update the documentation when behavior changes.

---

## License

This project is intended to be released under the **MIT License**. A `LICENSE` file has not been added to the repository yet; add one before distributing or publishing the app.

---

## Acknowledgements

Built with [Flutter](https://flutter.dev) and the following open-source packages:

`qr_flutter`, `file_picker`, `path_provider`, `share_plus`, `gal`, `permission_handler`, `url_launcher`, and optionally `firebase_core` / `firebase_storage`.
