# Changelog

All notable changes to the QR Code Generator app will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-10-08

### Added

- Initial release of QR Code Generator app
- Generate QR codes from URLs and links
- Generate QR codes from files (images, videos, PDFs, documents)
- Save QR codes to device gallery
- Share QR codes via any installed app
- Material Design 3 UI with light and dark theme support
- File picker for selecting any file type
- File size display for uploaded files
- Permission handling for storage access
- Responsive design for all screen sizes
- Error handling with user-friendly messages
- High-quality QR code export (3x resolution)

### Features

- **URL Input**: Text field with validation for entering URLs
- **File Upload**: Support for all file types with file picker
- **QR Display**: Clean, high-contrast QR code display
- **Save Function**: Save to gallery with permission handling
- **Share Function**: Share via system share sheet
- **Clear Function**: Easy reset to start over
- **Modern UI**: Material Design 3 with dynamic theming
- **Cross-platform**: Support for Android, iOS, Web, Windows, macOS, Linux

### Dependencies

- qr_flutter: ^4.1.0 - QR code generation
- file_picker: ^8.1.4 - File selection
- path_provider: ^2.1.5 - System paths
- share_plus: ^10.1.2 - Share functionality
- image_gallery_saver: ^2.0.3 - Save to gallery
- permission_handler: ^11.3.1 - Permission management
- url_launcher: ^6.3.1 - URL handling
- firebase_storage: ^12.3.6 - Cloud storage (optional)
- firebase_core: ^3.8.1 - Firebase initialization (optional)

### Documentation

- README.md - Project overview and features
- SETUP.md - Installation and configuration guide
- USER_GUIDE.md - End-user documentation
- Inline code comments for developers

### Testing

- Unit tests for QRData model
- File size formatting tests
- Display data validation tests

---

## [Unreleased]

### Planned Features

- [ ] QR code scanner functionality
- [ ] History of generated QR codes with local storage
- [ ] Batch QR code generation from CSV/Excel
- [ ] Custom QR code styling (colors, gradients, logos)
- [ ] vCard QR code generation for contacts
- [ ] WiFi QR code generation
- [ ] Calendar event QR codes
- [ ] Export QR codes in multiple formats (SVG, PDF, EPS)
- [ ] QR code analytics (scan tracking)
- [ ] Cloud sync for QR code history
- [ ] Templates for common QR code types
- [ ] QR code expiration and password protection
- [ ] Multi-language support (i18n)
- [ ] Accessibility improvements (screen reader support)
- [ ] Widget for home screen quick generation

### Planned Improvements

- [ ] Offline mode with local file caching
- [ ] Better error messages and user guidance
- [ ] Animated QR code generation
- [ ] QR code preview before generation
- [ ] Image compression for uploaded files
- [ ] Background upload for large files
- [ ] Progress indicator for file uploads
- [ ] QR code zoom and pan functionality
- [ ] Print directly from app
- [ ] Automatic URL validation and correction
- [ ] Support for URL shortening services
- [ ] QR code quality settings
- [ ] Custom file size limits

### Known Issues

- None currently reported

---

## Version History

### Version 0.1.0 (Current)

- Initial release
- Basic QR code generation from URLs and files
- Save and share functionality
- Material Design 3 UI

---

## How to Contribute

If you'd like to contribute to this project:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## Support

For issues, questions, or feature requests:

- Open an issue on GitHub
- Check the USER_GUIDE.md for common questions
- Review the SETUP.md for configuration help

---

_This changelog will be updated with each new release._
