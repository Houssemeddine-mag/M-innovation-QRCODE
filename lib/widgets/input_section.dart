import 'package:flutter/material.dart';

class InputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onGenerate;

  const InputSection({
    super.key,
    required this.controller,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter URL or Link',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'https://example.com',
                labelText: 'URL',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.link),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => controller.clear(),
                      )
                    : null,
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => onGenerate(),
              onChanged: (_) {
                // Trigger rebuild to show/hide clear button
                (context as Element).markNeedsBuild();
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onGenerate,
              icon: const Icon(Icons.qr_code),
              label: const Text('Generate QR Code'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
