import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/qr_data.dart';
import '../widgets/qr_display_widget.dart';
import '../widgets/input_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  QRData? _currentQRData;
  bool _isLoading = false;
  InputType _selectedInputType = InputType.url;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      setState(() => _isLoading = true);

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;

        setState(() {
          _currentQRData = QRData(
            type: QRDataType.file,
            data: file.path!,
            fileName: file.name,
            fileSize: file.size,
          );
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File selected: ${file.name}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _generateQRFromURL() {
    final url = _urlController.text.trim();

    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a URL'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _currentQRData = QRData(type: QRDataType.url, data: url);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR Code generated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _clearQRCode() {
    setState(() {
      _currentQRData = null;
      _urlController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Generator'),
        centerTitle: true,
        elevation: 2,
        actions: [
          if (_currentQRData != null)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Clear',
              onPressed: _clearQRCode,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Input Type Selector
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Input Type',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        SegmentedButton<InputType>(
                          segments: const [
                            ButtonSegment(
                              value: InputType.url,
                              label: Text('URL/Link'),
                              icon: Icon(Icons.link),
                            ),
                            ButtonSegment(
                              value: InputType.file,
                              label: Text('File'),
                              icon: Icon(Icons.file_upload),
                            ),
                          ],
                          selected: {_selectedInputType},
                          onSelectionChanged: (Set<InputType> newSelection) {
                            setState(() {
                              _selectedInputType = newSelection.first;
                              _currentQRData = null;
                              _urlController.clear();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Input Section
                if (_selectedInputType == InputType.url)
                  InputSection(
                    controller: _urlController,
                    onGenerate: _generateQRFromURL,
                  )
                else
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Upload File',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Select any file to generate a QR code. Supported: images, videos, PDFs, documents, and more.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _isLoading ? null : _pickFile,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.upload_file),
                            label: Text(
                              _isLoading ? 'Loading...' : 'Choose File',
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // QR Code Display
                if (_currentQRData != null)
                  QRDisplayWidget(qrData: _currentQRData!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum InputType { url, file }
