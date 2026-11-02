enum QRDataType { url, file }

class QRData {
  final QRDataType type;
  final String data;
  final String? fileName;
  final int? fileSize;

  QRData({
    required this.type,
    required this.data,
    this.fileName,
    this.fileSize,
  });

  String get displayData {
    if (type == QRDataType.url) {
      return data;
    } else {
      return 'File: ${fileName ?? 'Unknown'} (${_formatFileSize(fileSize ?? 0)})';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
