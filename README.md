# 🛡️ SafeGuard AI

AI-powered workplace safety analysis and automated reporting system.

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🎯 Overview

SafeGuard AI is an intelligent workplace safety monitoring system that combines AI-powered image analysis with workflow automation to provide instant risk assessment and automated reporting.

### Key Features

- 📸 **Image Capture & Analysis** - Quick photo capture or gallery selection
- 🤖 **Google Gemini AI Integration** - Intelligent risk detection and analysis
- ⚙️ **n8n Workflow Automation** - End-to-end automated reporting pipeline
- 📧 **Smart Email Generation** - Risk-based email templates with editable content
- 📊 **Dashboard & Statistics** - Track safety metrics and trends
- 🎨 **Modern UI/UX** - Material Design 3 with light/dark theme support

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.10 or higher
- Dart SDK 3.0 or higher
- Docker (for n8n backend)
- Google Gemini API key

### Mobile App Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/safeguard_ai.git
cd safeguard_ai

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Backend Setup (n8n)

```bash
# Start n8n with Docker
./n8n_start.sh

# Access n8n dashboard
open http://localhost:5678
```

For detailed setup instructions, see `notes/WORKFLOW_SETUP_GUIDE.md`

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **BLoC** state management:

```
lib/
├── core/
│   ├── constants/      # App constants & colors
│   ├── theme/          # Theme configuration
│   ├── router/         # Navigation
│   └── utils/          # Utilities & helpers
├── features/
│   ├── analysis/       # AI analysis feature
│   ├── history/        # Report history
│   ├── settings/       # App settings
│   └── home/           # Dashboard
└── main.dart
```

## 🛠️ Tech Stack

### Mobile (Flutter)
- **Framework**: Flutter 3.10+
- **Language**: Dart 3.0+
- **State Management**: flutter_bloc
- **Navigation**: go_router
- **API Client**: dio
- **Local Storage**: hive (planned)
- **Code Generation**: freezed, json_serializable

### Backend & AI
- **AI**: Google Gemini AI (Image Analysis)
- **Automation**: n8n (Workflow Engine)
- **Containerization**: Docker

### Architecture Patterns
- Clean Architecture
- BLoC Pattern
- Repository Pattern
- Dependency Injection (GetIt)

## 📱 Features

### Current Features

- ✅ Image capture and gallery selection
- ✅ AI-powered risk analysis (Mock mode)
- ✅ Automated email template generation
- ✅ Risk-based recipient lists
- ✅ Editable report content
- ✅ Bottom navigation with 4 sections
- ✅ Dashboard with statistics placeholders
- ✅ History page with filters
- ✅ Settings page with configuration options
- ✅ Light/Dark theme support
- ✅ Comprehensive input validation
- ✅ Error handling and user feedback

### Planned Features

- ⏳ Hive local storage integration
- ⏳ Report history with CRUD operations
- ⏳ Real-time statistics and analytics
- ⏳ n8n production integration
- ⏳ Google Docs auto-save
- ⏳ PDF report generation
- ⏳ Multi-language support
- ⏳ Voice commands

## 🎭 Mock Mode

The app currently runs in **Mock Mode**, allowing full feature development and testing without n8n backend:

```dart
// lib/core/init/injection_container.dart
const bool _useMockData = true; // Switch to false for production
```

Mock mode provides:
- Random risk level generation
- Realistic analysis texts
- Network delay simulation
- Full UI/UX testing capability

## 📚 Documentation

Detailed documentation is available in the `notes/` folder:

- **Setup & Configuration**
  - `notes/WORKFLOW_SETUP_GUIDE.md` - n8n workflow setup
  - `notes/N8N_BAGLANTI_VE_BACKUP.md` - n8n connection & backup
  - `notes/API_INTEGRATION_GUIDE.md` - API integration guide

- **Development**
  - `notes/MOCK_MODE_GUIDE.md` - Mock mode usage
  - `notes/HIZLI_BASLANGIC.md` - Quick start guide
  - `notes/CODE_IMPROVEMENTS.md` - Code improvements log

- **Features**
  - `notes/YENILIKLER.md` - New features (Turkish)
  - `notes/NEW_FEATURES_SUMMARY.md` - Phase A summary

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with specific device
flutter run -d <device_id>

# Build APK
flutter build apk --release
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Your Name** - *Initial work*

## 🙏 Acknowledgments

- Google Gemini AI for powerful image analysis
- n8n community for workflow automation platform
- Flutter team for the amazing framework

## 📞 Support

For questions or support, please open an issue in the GitHub repository.

---

**Built with ❤️ using Flutter and AI**
