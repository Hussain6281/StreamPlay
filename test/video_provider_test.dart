import 'package:flutter_test/flutter_test.dart';
import 'package:streamplay/models/video.dart';
import 'package:streamplay/providers/video_provider.dart';

void main() {
  group('VideoLibraryState', () {
    test('initial state has empty videos list', () {
      final state = VideoLibraryState(videos: []);
      expect(state.videos, isEmpty);
    });

    test('copyWith returns new state with updated videos', () {
      final initialState = VideoLibraryState(videos: []);
      final newVideos = [
        Video(
          id: '1',
          title: 'Test Video',
          thumbnailUrl: 'test.jpg',
          videoUrl: 'test.mp4',
          duration: Duration.zero,
        ),
      ];
      final newState = initialState.copyWith(videos: newVideos);
      expect(newState.videos, equals(newVideos));
      expect(newState.videos.length, 1);
    });

    test('copyWith without parameters returns same state', () {
      final initialVideos = [
        Video(
          id: '1',
          title: 'Test Video',
          thumbnailUrl: 'test.jpg',
          videoUrl: 'test.mp4',
          duration: Duration.zero,
        ),
      ];
      final initialState = VideoLibraryState(videos: initialVideos);
      final newState = initialState.copyWith();
      expect(newState.videos, equals(initialVideos));
    });
  });

  group('VideoLibraryNotifier', () {
    late VideoLibraryNotifier notifier;

    setUp(() {
      notifier = VideoLibraryNotifier();
    });

    test('initial state loads dummy videos', () {
      expect(notifier.state.videos.length, 5);
    });

    test('loads dummy videos on initialization', () {
      // Since _loadDummyVideos is called in constructor, state should have videos
      expect(notifier.state.videos.length, 5); // Based on the dummy data
      expect(notifier.state.videos[0].id, '1');
      expect(notifier.state.videos[0].title, 'Sample Video 1');
      expect(notifier.state.videos[0].thumbnailUrl, 'assets/images/flower.jpg');
      expect(
        notifier.state.videos[0].videoUrl,
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      );
      expect(notifier.state.videos[0].duration, Duration.zero);
    });

    test('updateVideoDuration updates the correct video', () {
      const videoId = '1';
      const newDuration = Duration(seconds: 120);
      notifier.updateVideoDuration(videoId, newDuration);
      final updatedVideo = notifier.state.videos.firstWhere(
        (v) => v.id == videoId,
      );
      expect(updatedVideo.duration, newDuration);
    });

    test('updateVideoDuration does nothing if video id not found', () {
      const videoId = 'nonexistent';
      const newDuration = Duration(seconds: 120);
      final initialVideos = List<Video>.from(notifier.state.videos);
      notifier.updateVideoDuration(videoId, newDuration);
      expect(notifier.state.videos, equals(initialVideos));
    });
  });
}
