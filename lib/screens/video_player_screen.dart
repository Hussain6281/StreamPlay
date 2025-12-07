import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/video.dart';
import '../providers/video_player_provider.dart';
import '../widgets/video_player_widget.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final Video video;

  const VideoPlayerScreen({super.key, required this.video});

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(videoPlayerProvider.notifier).initializePlayer(widget.video);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ref.read(videoPlayerProvider.notifier).stopAndDispose();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(child: VideoPlayerWidget(video: widget.video)),
      ),
    );
  }
}
