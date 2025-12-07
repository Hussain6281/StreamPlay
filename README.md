# StreamPlay - Video Library + Video Player

A Flutter application that displays a video library and allows users to play videos with automatic orientation switching.

## Features

- **Video Library Screen**: Displays a grid/list of videos with thumbnails, titles, and durations.
- **Video Player Screen**: Full-screen video player with play/pause, seek bar, and fullscreen toggle.
- **Automatic Orientation Switching**: Automatically switches between portrait and landscape when device is rotated.
- **Light/Dark Mode**: Toggle between light and dark themes.
- **Custom Controls**: Custom video progress indicator with scrubbing support.

## Requirements

- Flutter 3+
- Dart SDK ^3.9.0

## Setup Steps

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd streamplay
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

### iOS Setup

If you need to access videos using http (rather than https) URLs, you will need to add the appropriate NSAppTransportSecurity permissions to your app's Info.plist file, located in `<project root>/ios/Runner/Info.plist`. See Apple's documentation to determine the right combination of entries for your use case and supported iOS versions.

## Packages Used

- `video_player: ^2.8.6` - For video playback functionality
- `flutter_riverpod: ^2.5.1` - For state management

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── video.dart               # Video model
├── providers/
│   ├── theme_provider.dart      # Theme state management
│   ├── video_provider.dart      # Video library state management
│   └── video_player_provider.dart # Video player state management
├── screens/
│   ├── splash_screen.dart       # Splash screen
│   ├── video_library_screen.dart # Video library screen
│   └── video_player_screen.dart # Video player screen
├── widgets/
│   ├── app_background.dart      # App background widget
│   └── custom_video_progress_indicator.dart # Custom seek bar
└── test/
    ├── video_provider_test.dart # Unit tests for video provider
    └── widget_test.dart         # Widget tests
```

## Notes/Assumptions

- The app uses dummy video URLs from Google's test video bucket for demonstration.
- Orientation switching is handled automatically by Flutter's orientation detection.
- Videos can be downloaded for offline playback using the download functionality.
- The app supports both network and local video playback.
- Custom video controls are implemented using Flutter's built-in widgets.
- The app uses Material Design 3 for UI components.
- State management is handled using Riverpod for reactive state updates.
