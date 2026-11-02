/// Firebase Configuration Template
///
/// This file shows how to properly configure Firebase for the QR Code Generator app.
/// Follow the steps in SETUP.md to get your actual Firebase credentials.

library;

/// For Web Platform (optional)
/// Create a file named 'firebase_options.dart' with your Firebase web configuration
/// 
/// Example:
/// ```dart
/// import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
/// import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
/// 
/// class DefaultFirebaseOptions {
///   static FirebaseOptions get currentPlatform {
///     if (kIsWeb) {
///       return web;
///     }
///     switch (defaultTargetPlatform) {
///       case TargetPlatform.android:
///         return android;
///       case TargetPlatform.iOS:
///         return ios;
///       default:
///         throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
///     }
///   }
/// 
///   static const FirebaseOptions web = FirebaseOptions(
///     apiKey: 'YOUR_API_KEY',
///     appId: 'YOUR_APP_ID',
///     messagingSenderId: 'YOUR_SENDER_ID',
///     projectId: 'YOUR_PROJECT_ID',
///     storageBucket: 'YOUR_STORAGE_BUCKET',
///   );
/// 
///   static const FirebaseOptions android = FirebaseOptions(
///     apiKey: 'YOUR_ANDROID_API_KEY',
///     appId: 'YOUR_ANDROID_APP_ID',
///     messagingSenderId: 'YOUR_SENDER_ID',
///     projectId: 'YOUR_PROJECT_ID',
///     storageBucket: 'YOUR_STORAGE_BUCKET',
///   );
/// 
///   static const FirebaseOptions ios = FirebaseOptions(
///     apiKey: 'YOUR_IOS_API_KEY',
///     appId: 'YOUR_IOS_APP_ID',
///     messagingSenderId: 'YOUR_SENDER_ID',
///     projectId: 'YOUR_PROJECT_ID',
///     storageBucket: 'YOUR_STORAGE_BUCKET',
///     iosBundleId: 'com.example.qrc',
///   );
/// }
/// ```
/// 
/// Then in main.dart:
/// ```dart
/// import 'firebase_options.dart';
/// 
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```

/// Note: You can also use FlutterFire CLI to automatically generate this file:
/// ```bash
/// # Install FlutterFire CLI
/// dart pub global activate flutterfire_cli
/// 
/// # Configure Firebase for your project
/// flutterfire configure
/// ```
