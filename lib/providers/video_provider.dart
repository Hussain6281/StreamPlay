import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../models/video.dart';

class VideoLibraryState {
  final List<Video> videos;

  VideoLibraryState({required this.videos});

  VideoLibraryState copyWith({List<Video>? videos}) {
    return VideoLibraryState(videos: videos ?? this.videos);
  }
}

class VideoLibraryNotifier extends StateNotifier<VideoLibraryState> {
  VideoLibraryNotifier() : super(VideoLibraryState(videos: [])) {
    _loadDummyVideos();
  }

  void _loadDummyVideos() {
    final videos = [
      Video(
        id: '1',
        title: 'Sample Video 1',
        thumbnailUrl: 'assets/images/flower.jpg',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        duration: Duration.zero, // Will be updated with actual duration
      ),
      Video(
        id: '2',
        title: 'Sample Video 2',
        thumbnailUrl: 'assets/images/industry.jpg',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        duration: Duration.zero, // Will be updated with actual duration
      ),
      Video(
        id: '3',
        title: 'Sample Video 3',
        thumbnailUrl: 'assets/images/mountain.jpeg',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        duration: Duration.zero, // Will be updated with actual duration
      ),
      Video(
        id: '4',
        title: 'Sample Video 4',
        thumbnailUrl: 'assets/images/rain.jpg',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        duration: Duration.zero, // Will be updated with actual duration
      ),
      Video(
        id: '5',
        title: 'Sample Video 5',
        thumbnailUrl: 'assets/images/waterfall.jpg',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
        duration: Duration.zero, // Will be updated with actual duration
      ),
    ];
    state = state.copyWith(videos: videos);
    // Preload actual video durations in the background
    _preloadVideoDurations();
  }

  void updateVideoDuration(String videoId, Duration newDuration) {
    final videoIndex = state.videos.indexWhere((v) => v.id == videoId);
    if (videoIndex != -1) {
      final updatedVideos = List<Video>.from(state.videos);
      updatedVideos[videoIndex] = updatedVideos[videoIndex].copyWith(
        duration: newDuration,
      );
      state = state.copyWith(videos: updatedVideos);
    }
  }

  Future<void> _preloadVideoDurations() async {
    for (final video in state.videos) {
      try {
        late VideoPlayerController controller;
        if (video.localPath != null) {
          controller = VideoPlayerController.file(File(video.localPath!));
        } else {
          controller = VideoPlayerController.networkUrl(
            Uri.parse(video.videoUrl),
          );
        }

        await controller.initialize();
        final actualDuration = controller.value.duration;
        await controller.dispose();

        // Update the video duration in the state
        updateVideoDuration(video.id, actualDuration);
      } catch (e) {
        // If duration loading fails, keep the zero duration or log error
        // In a real app, you might want to show a loading indicator or retry
      }
    }
  }
}

final videoLibraryProvider =
    StateNotifierProvider<VideoLibraryNotifier, VideoLibraryState>((ref) {
      return VideoLibraryNotifier();
    });
