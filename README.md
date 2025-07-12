# Advanced Notepad App

This is an advanced Android Notepad application built with Flutter and Dart, featuring a clean architecture, local SQLite storage, rich text editing capabilities, note tagging, search functionality, autosave, sorting options, responsive card-based UI, and dark/light mode toggles.

## Features

*   **Create, Edit, Delete Notes**: Full CRUD operations for notes.
*   **Rich Text Editor**: Supports bold, italic, underline, and bullet points.
*   **Local Storage**: All notes are stored locally using SQLite.
*   **Note Tagging**: Organize notes with tags (e.g., Work, Personal).
*   **Search Functionality**: Search notes by title and content.
*   **Autosave**: Notes are automatically saved while typing.
*   **Sorting Options**: Sort notes by title, creation date, or last modified date.
*   **Responsive Card-based Layout**: Optimized for various screen sizes.
*   **Dark/Light Mode**: Toggle between dark and light themes.
*   **Clean Architecture**: Separated UI, logic, and data layers.
*   **State Management**: Implemented using Provider.

## Getting Started

Follow these instructions to set up and run the project on your local machine.

### Prerequisites

*   Flutter SDK (version 3.0.0 or higher recommended)
*   Android Studio or VS Code with Flutter and Dart plugins

### Installation

1.  **Clone the repository (or unzip the provided project file):**

    ```bash
    git clone <repository_url> # If provided as a Git repository
    # Or unzip advanced_notepad_app.zip
    ```

2.  **Navigate to the project directory:**

    ```bash
    cd advanced_notepad_app
    ```

3.  **Install dependencies:**

    Run `flutter pub get` to download all the required packages.

    ```bash
    flutter pub get
    ```

4.  **Run the application:**

    Connect an Android device or start an Android emulator, then run the app:

    ```bash
    flutter run
    ```

    Alternatively, you can open the project in Android Studio or VS Code and run it from there.

## Building the APK

To build a release APK file for Android, use the following command:

```bash
flutter build apk --release
```

The generated APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.

## Important Notes on Rich Text Editor

Due to environmental constraints during development, the rich text editor functionality (bold, italic, underline, bullet points) is implemented using a basic `TextEditingController` and manual text manipulation. This is a simplified approach and does not offer the full capabilities of a dedicated rich text editor library like `flutter_quill`.

If you require a more robust rich text editing experience, you can integrate `flutter_quill` or a similar library. The `pubspec.yaml` file was initially configured to include `flutter_quill`, but it was removed to ensure the project could build successfully within the given environment. To re-enable `flutter_quill`, you would need to:

1.  **Add `flutter_quill` back to `pubspec.yaml`:**

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      cupertino_icons: ^1.0.2
      sqflite: ^2.2.8+4
      path_provider: ^2.0.15
      shared_preferences: ^2.1.2
      provider: ^6.0.5
      flutter_quill: ^11.0.0 # Or the latest stable version
    ```

2.  **Run `flutter pub get`**.

3.  **Update `lib/screens/note_detail_screen.dart`**: You would need to replace the current `TextField` for content with `QuillEditor` and `QuillToolbar` widgets, and adjust the note saving/loading logic to handle Quill's Delta format (JSON representation of rich text).

This project provides a solid foundation, and the rich text editor can be enhanced further based on your specific needs.

