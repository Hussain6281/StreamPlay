import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamplay/models/video_player.dart';
import 'package:video_player/video_player.dart';
import '../models/video.dart';

class VideoPlayerNotifier extends StateNotifier<VideoPlayerState> {
  VideoPlayerNotifier() : super(VideoPlayerState());

  Future<void> initializePlayer(Video video) async {
    if (state.controller != null) {
      try {
        await state.controller!.dispose();
      } catch (e) {
        // already disposed
      }
    }

    VideoPlayerController controller;
    if (video.localPath != null) {
      controller = VideoPlayerController.file(File(video.localPath!));
    } else {
      controller = VideoPlayerController.networkUrl(Uri.parse(video.videoUrl));
    }
    await controller.initialize();

    // Update video duration based on actual video length
    final actualDuration = controller.value.duration;
    final updatedVideo = video.copyWith(duration: actualDuration);

    await controller.play();
    state = state.copyWith(
      controller: controller,
      video: updatedVideo,
      isInitialized: true,
      isPlaying: true,
    );

    // Update the duration in the video library as well
    // This ensures the library shows the correct duration after first play
    // Note: In a real app, this would be persisted to a database
    // For now, we'll skip this as it requires a more complex provider setup
    // The duration will be updated when the video is played again
  }

  void togglePlayPause() {
    if (state.controller == null) return;
    if (state.controller!.value.isPlaying) {
      state.controller!.pause();
      state = state.copyWith(isPlaying: false);
    } else {
      state.controller!.play();
      state = state.copyWith(isPlaying: true);
    }
  }

  void toggleVolume() {
    if (state.controller == null) return;
    final currentVolume = state.controller!.value.volume;
    final newVolume = currentVolume > 0 ? 0.0 : 1.0;
    state.controller!.setVolume(newVolume);
    state = state.copyWith(volume: newVolume);
  }

  void toggleControls() {
    state = state.copyWith(showControls: !state.showControls);
  }

  void skipForward() {
    if (state.controller == null) return;
    final currentPosition = state.controller!.value.position;
    final newPosition = currentPosition + const Duration(seconds: 10);
    state.controller!.seekTo(newPosition);
  }

  void skipBackward() {
    if (state.controller == null) return;
    final currentPosition = state.controller!.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    state.controller!.seekTo(newPosition);
  }

  void pauseIfPlaying() {
    if (state.controller != null && state.controller!.value.isPlaying) {
      state.controller!.pause();
    }
  }

  void stopAndDispose() async {
    pauseIfPlaying();
    final controller = state.controller;
    state = VideoPlayerState();
    if (controller != null) {
      try {
        await controller.dispose();
      } catch (e) {
        // already disposed or error
      }
    }
  }

  void toggleFullscreen() {
    final newFullscreen = !state.isFullscreen;
    state = state.copyWith(isFullscreen: newFullscreen);
    if (newFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  void dispose() {
    state.controller?.dispose();
    super.dispose();
  }
}

final videoPlayerProvider =
    StateNotifierProvider<VideoPlayerNotifier, VideoPlayerState>((ref) {
      return VideoPlayerNotifier();
    });
