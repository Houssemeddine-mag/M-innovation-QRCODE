# Setup Guide for QR Code Generator App

## Quick Start (Basic Version - No Firebase)

The app works out of the box for basic functionality without Firebase. For large files, you'll need Firebase Storage.

### 1. Run the App

```bash
flutter run
```

That's it! The app will work for:

- Generating QR codes from URLs
- Selecting files and displaying file information
- Saving and sharing QR codes

---

## Advanced Setup (With Firebase for Large Files)

If you want to upload large files to cloud storage and generate QR codes with download links, follow these steps:

### Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Follow the setup wizard

### Step 2: Register Your Apps

#### For Android:

1. In Firebase Console, click "Add app" → Android
2. Package name: `com.example.qrc` (or your custom package)
3. Download `google-services.json`
4. Place it in `android/app/` directory

#### For iOS:

1. In Firebase Console, click "Add app" → iOS
2. Bundle ID: `com.example.qrc` (or your custom bundle)
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/` directory

### Step 3: Enable Firebase Storage

1. In Firebase Console, go to "Storage"
2. Click "Get Started"
3. Choose security rules (start in test mode for development)
4. Click "Done"

### Step 4: Update Android Configuration

Edit `android/build.gradle.kts`:

```kotlin
dependencies {
    classpath("com.android.tools.build:gradle:8.1.0")
    classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0")
    classpath("com.google.gms:google-services:4.4.0")  // Add this line
}
```

Edit `android/app/build.gradle.kts`, add at the bottom:

```kotlin
apply(plugin = "com.google.gms.google-services")
```

### Step 5: Update iOS Configuration

Edit `ios/Podfile`, add after `platform :ios`:

```ruby
pod 'Firebase/Storage'
```

Then run:

```bash
cd ios
pod install
cd ..
```

### Step 6: Initialize Firebase in App

Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Add this line
  runApp(const QRCodeGeneratorApp());
}

// ... rest of the code
```

### Step 7: Use Firebase Storage in App

In `home_screen.dart`, when a file is selected, you can upload it:

```dart
import '../services/file_storage_service.dart';

// Inside _pickFile method:
final fileStorageService = FileStorageService();
final downloadUrl = await fileStorageService.uploadFile(
  File(file.path!),
  file.name
);

setState(() {
  _currentQRData = QRData(
    type: QRDataType.url,
    data: downloadUrl,  // Use the Firebase URL
  );
});
```

---

## Platform-Specific Setup

### Android

**Minimum SDK Version**: Edit `android/app/build.gradle.kts`

```kotlin
minSdk = 21
```

### iOS

**Minimum iOS Version**: Edit `ios/Podfile`

```ruby
platform :ios, '12.0'
```

---

## Testing

### Test on Android Emulator

```bash
flutter run -d emulator-5554
```

### Test on iOS Simulator

```bash
flutter run -d iPhone
```

### Test on Physical Device

```bash
flutter devices
flutter run -d <device-id>
```

---

## Troubleshooting

### Issue: "Permissions denied when saving"

**Solution**: Make sure you've added all permissions in AndroidManifest.xml and Info.plist

### Issue: "Firebase not initialized"

**Solution**: Make sure you've called `Firebase.initializeApp()` in main.dart

### Issue: "File picker not working"

**Solution**: Check that you've run `flutter pub get` to install all dependencies

### Issue: "QR code not displaying"

**Solution**: Check that the data being passed is not too large. For large files, use Firebase Storage URLs instead

---

## Security Considerations

1. **Firebase Security Rules**: Update your Firebase Storage rules for production:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /qr_files/{fileName} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

2. **File Size Limits**: Consider implementing file size limits to prevent abuse

3. **File Type Validation**: Validate file types before upload

---

## Performance Tips

1. **Compress Images**: Use image compression before uploading
2. **Cache QR Codes**: Store recently generated QR codes
3. **Lazy Loading**: Load file previews on demand
4. **Background Upload**: Implement background upload for large files

---

## Need Help?

- Check the [Flutter Documentation](https://flutter.dev/docs)
- Visit [Firebase Documentation](https://firebase.google.com/docs)
- Review the README.md for feature details
