# QR Code Generator - User Guide

> **Platform note:** This release supports **Android only**. iOS, desktop, and web are not currently supported.

## Welcome! 👋

This app allows you to quickly generate QR codes from various sources including URLs, images, videos, PDFs, and any other files.

---

## Getting Started

### Main Screen

When you open the app, you'll see two main tabs:

1. **URL/Link** - For generating QR codes from web links
2. **File** - For generating QR codes from files on your device

---

## How to Generate QR Codes

### Method 1: From a URL or Link

Perfect for sharing websites, social media profiles, or online resources.

**Steps:**

1. Tap on the **URL/Link** tab
2. Enter or paste your URL in the text field
   - Examples:
     - `https://www.example.com`
     - `https://www.youtube.com/watch?v=...`
     - `https://drive.google.com/file/d/...`
3. Tap the **Generate QR Code** button
4. Your QR code will appear below!

**Tips:**

- Make sure your URL starts with `http://` or `https://`
- Test the URL in a browser first to ensure it works
- Shorter URLs generate simpler QR codes that are easier to scan

---

### Method 2: From a File

Perfect for sharing documents, images, videos, or any other files.

**Steps:**

1. Tap on the **File** tab
2. Tap the **Choose File** button
3. Select any file from your device:
   - 📷 Images (JPG, PNG, GIF, etc.)
   - 🎥 Videos (MP4, MOV, AVI, etc.)
   - 📄 Documents (PDF, DOCX, XLSX, etc.)
   - 🎵 Audio files (MP3, WAV, etc.)
   - 📦 Any other file type!
4. The QR code will be automatically generated
5. You'll see the file name and size displayed

**Note:** For this method to work with large files, you may need to set up Firebase Storage (see SETUP.md). Otherwise, the QR code will contain the local file path.

---

## Working with Generated QR Codes

Once you've generated a QR code, you have two options:

### 🔗 Share QR Code

Tap the **Share** button to:

- Send via messaging apps (WhatsApp, Telegram, etc.)
- Share via email
- Post to social media
- Send via Bluetooth or nearby devices

### 💾 Save QR Code

Tap the **Save** button to:

- Save the QR code image to your device's gallery
- On first use, you'll be asked to grant permission to access your photos
- The QR code will be saved as a high-quality PNG image
- You can then print it, include it in presentations, or use it anywhere!

### 🗑️ Clear QR Code

Tap the **Clear** button (trash icon in the top-right) to:

- Remove the current QR code
- Start fresh with a new URL or file

---

## Tips for Best Results

### QR Code Quality

- **High contrast:** The QR code uses black on white for best scanning
- **Size matters:** The generated QR code is 250x250 pixels - perfect for most uses
- **Save in high quality:** Saved images are at 3x resolution for print quality

### Scanning QR Codes

- **Lighting:** Ensure good lighting when someone scans your QR code
- **Distance:** The scanner should be 6-12 inches away
- **Stability:** Hold steady for best results
- **Clean surface:** If printed, make sure the paper isn't wrinkled

### URL Best Practices

✅ **Good URLs:**

- `https://example.com/page`
- `https://youtu.be/dQw4w9WgXcQ`
- `https://maps.google.com/?q=...`

❌ **Avoid:**

- URLs without `http://` or `https://`
- Extremely long URLs (use a URL shortener)
- Broken or invalid links

### File Recommendations

- **Smaller is better:** For direct encoding, keep files small
- **Use cloud storage:** For large files, upload to Google Drive, Dropbox, etc., then use the share link
- **Check file access:** Make sure the file is accessible to others if you're sharing

---

## Common Use Cases

### 🌐 Website Links

Share your portfolio, business website, or blog

### 📱 Social Media

Link to Instagram, Facebook, Twitter, LinkedIn profiles

### 📧 Contact Information

Create vCards with contact details (future feature)

### 🎥 Video Content

Share YouTube videos, tutorials, or presentations

### 📄 Documents

Share PDF brochures, menus, catalogs, forms

### 🖼️ Image Galleries

Link to photo albums or portfolios

### 🎵 Music & Audio

Share podcast episodes, music tracks, audio files

### 📍 Location

Share Google Maps locations or directions

### 💳 Payment

Create payment links (PayPal, Venmo, etc.)

### 📶 WiFi Access

Share WiFi credentials (future feature)

---

## Permissions

The app needs the following permissions:

### 📸 Photo Library (Android)

- **Why:** To save QR codes to your device
- **When:** Only when you tap the "Save" button
- **Privacy:** We only save QR codes you create

### 📁 File Access (Android)

- **Why:** To read files you want to encode
- **When:** Only when you tap "Choose File"
- **Privacy:** We only access files you explicitly select

---

## Troubleshooting

### QR Code Won't Generate

- Check your internet connection
- Ensure the URL is valid and accessible
- Try a shorter URL or smaller file

### Can't Save QR Code

- Grant photo library permission when prompted
- Check your device storage space
- Try restarting the app

### File Upload Fails

- Check file size (very large files may not work)
- Ensure file isn't corrupted
- Try a different file format

### QR Code Won't Scan

- Increase screen brightness
- Ensure good lighting conditions
- Try zooming in/out on the QR code
- Make sure the scanner app is updated

---

## Privacy & Security

- ✅ **No data collection:** We don't collect or store your data
- ✅ **Local generation:** QR codes are generated on your device
- ✅ **No tracking:** We don't track what you create
- ✅ **Your control:** You decide what to share and save

---

## Need More Help?

- Check the **documentation.md** for technical details
- Review the **SETUP.md** for advanced configuration
- Report issues on GitHub (if applicable)
- Contact support (if applicable)

---

## Future Features

We're working on adding:

- QR code scanner
- Custom colors and designs
- Batch QR code generation
- History of generated codes
- WiFi QR codes
- vCard contact QR codes

Stay tuned for updates! 🚀
