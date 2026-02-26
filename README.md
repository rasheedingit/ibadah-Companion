# Ibadah Companion

Ibadah Companion is a Flutter-based mobile application designed to help users track their Quran reading progress. It features a unique, tactile skeuomorphic (Neumorphic) UI and provides a seamless way to bookmark your last read position and maintain a history of your reading sessions.

## 🌟 Features

- **Progress Tracking:** Easily bookmark your last read Surah and Ayah.
- **Reading History:** Keep a detailed log of all your reading sessions with dates.
- **Skeuomorphic Design:** A modern Neumorphic UI that provides a clean and interactive experience.
- **Local Persistence:** Your data stays on your device using Shared Preferences.
- **Validation:** Built-in validation ensures Ayah numbers are correct for each Surah.

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/)
- **Language:** [Dart](https://dart.dev/)
- **Storage:** [Shared Preferences](https://pub.dev/packages/shared_preferences)
- **Formatting:** [Intl](https://pub.dev/packages/intl) (for date and time)

## 📁 Project Structure

The project follows a clean and modular architecture:

- `lib/models/`: Data structures like `Bookmark` and `ReadingSession`.
- `lib/services/`: Business logic and data persistence (e.g., `StorageService`).
- `lib/widgets/`: Reusable Neumorphic UI components (e.g., `SkeuoContainer`, `SkeuoButton`).
- `lib/screens/`: 
    - `HomeScreen`: Dashboard for the last bookmark.
    - `HistoryScreen`: Overview of reading history.
    - `SessionListScreen`: Detailed list of reading sessions.
    - `SplashScreen`: App entry animation.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed.
- Android Studio or VS Code with Flutter extension.
- A connected device or emulator.

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```

2. Navigate to the project directory:
   ```bash
   cd ibadah_companion
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the application:
   ```bash
   flutter run
   ```

## 🧪 Development Commands

- **Run Tests:** `flutter test`
- **Static Analysis:** `flutter analyze`
- **Build Android APK:** `flutter build apk`
- **Build iOS:** `flutter build ios`

---
Developed by Kifftech.
