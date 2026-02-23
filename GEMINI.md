# Quran Bookmark App - Project Context

This project is a Flutter-based mobile application designed for bookmarking Quran reading progress. It features a unique skeuomorphic (Neumorphic) UI and local data persistence.

## Project Overview

-   **Purpose:** Allow users to bookmark their last read position (Surah and Ayah) in the Quran and maintain a history of these bookmarks.
-   **Core Technologies:**
    -   **Flutter:** UI framework.
    -   **Dart:** Programming language.
    -   **Shared Preferences:** Local data storage for bookmarks and history.
    -   **Intl:** Date formatting.
-   **Architecture:**
    -   `lib/models/`: Data structures (e.g., `Bookmark`).
    -   `lib/services/`: Business logic and data persistence (e.g., `StorageService`).
    -   `lib/widgets/`: Reusable UI components (e.g., `SkeuoContainer`, `SkeuoButton`).
    -   `lib/screens/`: Main application screens (`HomeScreen`, `HistoryScreen`).

## Building and Running

-   **Prerequisites:** Flutter SDK installed and configured.
-   **Install Dependencies:** `flutter pub get`
-   **Run Application:** `flutter run`
-   **Run Tests:** `flutter test`
-   **Static Analysis:** `flutter analyze`
-   **Build Android:** `flutter build apk`
-   **Build iOS:** `flutter build ios`

## Development Conventions

-   **UI Style:** Neumorphic/Skeuomorphic design. Use the `SkeuoContainer` and `SkeuoButton` widgets for consistent styling. The base color is `0xFFE0E5EC`.
-   **State Management:** Local state management using `StatefulWidget` where appropriate.
-   **Data Storage:** All bookmark data should be handled through `StorageService` to ensure consistency between "Last Read" and "History".
-   **Validation:** Always validate Ayah numbers against the `ayahs` count provided in the Surah list (defined in `HomeScreen`).
-   **Linting:** Adheres to `flutter_lints` as defined in `analysis_options.yaml`.
-   **Code Quality:**
    -   Check `context.mounted` before using `BuildContext` across asynchronous gaps.
    -   Prefer `const` constructors for performance optimization.
    -   Avoid deprecated members (e.g., use `.withValues()` instead of `.withOpacity()` for newer Flutter versions).

## Key Files

-   `lib/main.dart`: Entry point and app configuration.
-   `lib/screens/home_screen.dart`: Main dashboard for adding and viewing the last bookmark.
-   `lib/screens/history_screen.dart`: List view of all saved bookmarks.
-   `lib/services/storage_service.dart`: Handles all persistence logic.
-   `lib/widgets/skeuo_container.dart`: The foundation of the app's visual identity.
