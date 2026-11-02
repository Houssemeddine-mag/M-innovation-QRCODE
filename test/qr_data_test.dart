import 'package:flutter_test/flutter_test.dart';
import 'package:qrc/models/qr_data.dart';

void main() {
  group('QRData Model Tests', () {
    test('URL QRData should display correct data', () {
      final qrData = QRData(type: QRDataType.url, data: 'https://example.com');

      expect(qrData.type, QRDataType.url);
      expect(qrData.data, 'https://example.com');
      expect(qrData.displayData, 'https://example.com');
      expect(qrData.fileName, null);
      expect(qrData.fileSize, null);
    });

    test('File QRData should display correct data with file info', () {
      final qrData = QRData(
        type: QRDataType.file,
        data: '/path/to/file.pdf',
        fileName: 'document.pdf',
        fileSize: 1024 * 1024, // 1 MB
      );

      expect(qrData.type, QRDataType.file);
      expect(qrData.data, '/path/to/file.pdf');
      expect(qrData.fileName, 'document.pdf');
      expect(qrData.fileSize, 1024 * 1024);
      expect(qrData.displayData, contains('document.pdf'));
      expect(qrData.displayData, contains('MB'));
    });

    test('File size formatting should work correctly', () {
      // Test bytes
      final bytesData = QRData(
        type: QRDataType.file,
        data: 'test.txt',
        fileName: 'test.txt',
        fileSize: 500,
      );
      expect(bytesData.displayData, contains('500 B'));

      // Test kilobytes
      final kbData = QRData(
        type: QRDataType.file,
        data: 'test.jpg',
        fileName: 'test.jpg',
        fileSize: 1024 * 50, // 50 KB
      );
      expect(kbData.displayData, contains('KB'));

      // Test megabytes
      final mbData = QRData(
        type: QRDataType.file,
        data: 'test.mp4',
        fileName: 'test.mp4',
        fileSize: 1024 * 1024 * 5, // 5 MB
      );
      expect(mbData.displayData, contains('MB'));

      // Test gigabytes
      final gbData = QRData(
        type: QRDataType.file,
        data: 'large.zip',
        fileName: 'large.zip',
        fileSize: 1024 * 1024 * 1024 * 2, // 2 GB
      );
      expect(gbData.displayData, contains('GB'));
    });

    test('File QRData without fileName should show Unknown', () {
      final qrData = QRData(
        type: QRDataType.file,
        data: '/path/to/file',
        fileSize: 1024,
      );

      expect(qrData.displayData, contains('Unknown'));
    });

    test('File QRData with zero size should format correctly', () {
      final qrData = QRData(
        type: QRDataType.file,
        data: 'empty.txt',
        fileName: 'empty.txt',
        fileSize: 0,
      );

      expect(qrData.displayData, contains('0 B'));
    });
  });
}
