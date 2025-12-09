import 'package:streamplay/models/video.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerState {
  final VideoPlayerController? controller;
  final Video? video;
  final bool isInitialized;
  final bool showControls;
  final bool isFullscreen;
  final bool isPlaying;
  final double volume;

  VideoPlayerState({
    this.controller,
    this.video,
    this.isInitialized = false,
    this.showControls = true,
    this.isFullscreen = false,
    this.isPlaying = false,
    this.volume = 1.0,
  });

  VideoPlayerState copyWith({
    VideoPlayerController? controller,
    Video? video,
    bool? isInitialized,
    bool? showControls,
    bool? isFullscreen,
    bool? isPlaying,
    double? volume,
  }) {
    return VideoPlayerState(
      controller: controller ?? this.controller,
      video: video ?? this.video,
      isInitialized: isInitialized ?? this.isInitialized,
      showControls: showControls ?? this.showControls,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      isPlaying: isPlaying ?? this.isPlaying,
      volume: volume ?? this.volume,
    );
  }
}
