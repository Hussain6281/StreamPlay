import 'package:flutter/material.dart';
import 'package:streamplay/widgets/video_library_widget.dart';

class VideoLibraryScreen extends StatelessWidget {
  const VideoLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Scaffold(body: VideoLibraryWidget()));
  }
}
