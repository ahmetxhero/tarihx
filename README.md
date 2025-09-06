# 📅 TarihX

<div align="center">
  <img src="assets/icon/app_icon.png" alt="TarihX Logo" width="120" height="120">
  
  **Tarihte Bugün Ne Oldu? - Yarın Ne Oldu?**
  
  *Discover historical events that happened today and tomorrow*
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.27.0+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.8.1+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
  [![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux-blue)](https://flutter.dev)
</div>

## 🌟 Features

- **📱 Multi-Platform Support**: Works on Android, iOS, Web, Windows, macOS, and Linux
- **🌍 Multi-Language Support**: Available in 9 languages (Turkish, English, German, French, Spanish, Italian, Russian, Ukrainian, Chinese)
- **🤖 AI-Powered Explanations**: Get detailed explanations of historical events using Google's Gemini AI
- **🔔 Smart Notifications**: Daily reminders about historical events
- **🎨 Modern UI**: Beautiful Material Design 3 interface with dark/light theme support
- **📖 Wikipedia Integration**: Direct access to Wikipedia articles for detailed information
- **💰 Monetization Ready**: Integrated Google Mobile Ads for banner and interstitial ads
- **⚡ Fast & Lightweight**: Optimized performance with efficient data loading

## 📱 Screenshots

<div align="center">
  <img src="assets/screenshots/today_screen.png" alt="Today Screen" width="200">
  <img src="assets/screenshots/detail_screen.png" alt="Detail Screen" width="200">
  <img src="assets/screenshots/settings_screen.png" alt="Settings Screen" width="200">
</div>

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.27.0 or higher)
- Dart SDK (3.8.1 or higher)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/ahmetxhero/tarihx.git
   cd tarihx
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK version: 21
- Target SDK version: 34
- Google Mobile Ads integration included

#### iOS
- Minimum iOS version: 12.0
- Google Mobile Ads integration included
- Push notifications support

#### Web
- Modern web browsers support
- Responsive design

## 🏗️ Project Structure

```
lib/
├── main.dart                 # Main application entry point
├── models/                   # Data models
├── services/                 # API services and utilities
├── widgets/                  # Reusable UI components
└── screens/                  # Application screens

assets/
├── fonts/                    # Custom fonts (Inter)
├── icon/                     # App icons
└── translations/             # Multi-language support files
    ├── tr.json              # Turkish
    ├── en.json              # English
    ├── de.json              # German
    ├── fr.json              # French
    ├── es.json              # Spanish
    ├── it.json              # Italian
    ├── ru.json              # Russian
    ├── uk.json              # Ukrainian
    └── zh.json              # Chinese
```

## 🛠️ Technologies Used

- **Framework**: Flutter 3.27.0+
- **Language**: Dart 3.8.1+
- **State Management**: Built-in Flutter StatefulWidget
- **Localization**: Easy Localization
- **HTTP Client**: Dart HTTP package
- **WebView**: WebView Flutter
- **Ads**: Google Mobile Ads
- **Notifications**: Flutter Local Notifications
- **AI Integration**: Google Gemini API
- **Data Source**: Wikipedia On This Day API

## 📊 API Integration

### Wikipedia On This Day API
- Fetches historical events for specific dates
- Supports multiple languages
- Includes images and detailed information

### Google Gemini AI
- Provides educational explanations of historical events
- Multi-language support
- Contextual and engaging content

## 🎨 UI/UX Features

- **Material Design 3**: Modern, adaptive design system
- **Dark/Light Theme**: Automatic system theme detection
- **Responsive Layout**: Optimized for all screen sizes
- **Smooth Animations**: Fluid transitions and interactions
- **Accessibility**: Screen reader support and high contrast

## 🔧 Configuration

### Google Mobile Ads Setup

1. Add your Ad Unit IDs in `main.dart`:
   ```dart
   const String bannerAdUnitIdAndroid = 'YOUR_BANNER_AD_UNIT_ID';
   const String interstitialAdUnitIdAndroid = 'YOUR_INTERSTITIAL_AD_UNIT_ID';
   ```

2. Update `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)

### AI API Configuration

Update the Gemini API key in `main.dart`:
```dart
const apiKey = 'YOUR_GEMINI_API_KEY';
```

## 📱 Supported Platforms

| Platform | Status | Notes |
|----------|--------|-------|
| Android | ✅ | Full support with ads |
| iOS | ✅ | Full support with ads |
| Web | ✅ | Responsive design |
| Windows | ✅ | Desktop support |
| macOS | ✅ | Desktop support |
| Linux | ✅ | Desktop support |

## 🌍 Supported Languages

- 🇹🇷 Turkish (Türkçe)
- 🇬🇧 English
- 🇩🇪 German (Deutsch)
- 🇫🇷 French (Français)
- 🇪🇸 Spanish (Español)
- 🇮🇹 Italian (Italiano)
- 🇷🇺 Russian (Русский)
- 🇺🇦 Ukrainian (Українська)
- 🇨🇳 Chinese (中文)

## 📈 Performance

- **Fast Loading**: Optimized API calls and caching
- **Low Memory Usage**: Efficient image loading and disposal
- **Smooth Scrolling**: Optimized list rendering
- **Battery Efficient**: Smart notification scheduling

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Flutter/Dart style guidelines
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Wikipedia](https://www.wikipedia.org/) for providing historical data
- [Google Gemini](https://ai.google.dev/) for AI-powered explanations
- [Flutter](https://flutter.dev/) for the amazing framework
- [Material Design](https://material.io/) for design guidelines

## 📞 Contact

- **Developer**: Ahmet X Hero
- **GitHub**: [@ahmetxhero](https://github.com/ahmetxhero)
- **Project Link**: [https://github.com/ahmetxhero/tarihx](https://github.com/ahmetxhero/tarihx)

## 📊 Project Stats

![GitHub stars](https://img.shields.io/github/stars/ahmetxhero/tarihx?style=social)
![GitHub forks](https://img.shields.io/github/forks/ahmetxhero/tarihx?style=social)
![GitHub issues](https://img.shields.io/github/issues/ahmetxhero/tarihx)
![GitHub pull requests](https://img.shields.io/github/issues-pr/ahmetxhero/tarihx)

---

<div align="center">
  Made with ❤️ using Flutter
  
  **⭐ Star this repository if you found it helpful!**
</div>
