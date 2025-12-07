import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/video_library_screen.dart';
import '../screens/video_player_screen.dart';
import '../models/video.dart';

class AppRoutes {
  static const String splash = '/';
  static const String videoLibrary = '/video-library';
  static const String videoPlayer = '/video-player';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      videoLibrary: (context) => const VideoLibraryScreen(),
    };
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case videoPlayer:
        final video = settings.arguments as Video;
        return MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(video: video),
        );
      default:
        return null;
    }
  }
}
