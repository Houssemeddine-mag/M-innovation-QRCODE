import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

/// Service for uploading files to Firebase Storage and generating download URLs
/// This can be used for large files that cannot be directly encoded in QR codes
class FileStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file to Firebase Storage and returns the download URL
  /// This URL can then be used to generate a QR code
  Future<String> uploadFile(File file, String fileName) async {
    try {
      // Create a reference to the file location
      final ref = _storage.ref().child(
        'qr_files/${DateTime.now().millisecondsSinceEpoch}_$fileName',
      );

      // Upload the file
      final uploadTask = ref.putFile(file);

      // Wait for upload to complete
      final snapshot = await uploadTask.whenComplete(() => null);

      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  /// Deletes a file from Firebase Storage
  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Initializes Firebase (call this in main.dart before runApp)
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }
}

/// Example usage in your app:
/// 
/// 1. Initialize Firebase in main.dart:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await FileStorageService.initializeFirebase();
///   runApp(const QRCodeGeneratorApp());
/// }
/// ```
/// 
/// 2. Upload a file and generate QR code:
/// ```dart
/// final fileStorageService = FileStorageService();
/// final downloadUrl = await fileStorageService.uploadFile(file, 'myfile.pdf');
/// 
/// // Now generate QR code with the download URL
/// setState(() {
///   _currentQRData = QRData(
///     type: QRDataType.url,
///     data: downloadUrl,
///   );
/// });
/// ```
