import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamplay/providers/theme_provider.dart';
import 'package:streamplay/widgets/custom_video_progress_indicator.dart';
import 'package:video_player/video_player.dart';
import '../models/video.dart';
import '../providers/video_player_provider.dart';

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
    final videoPlayerState = ref.watch(videoPlayerProvider);

    return WillPopScope(
      onWillPop: () async {
        ref.read(videoPlayerProvider.notifier).stopAndDispose();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: OrientationBuilder(
            builder: (context, orientation) {
              return GestureDetector(
                onTap: () =>
                    ref.read(videoPlayerProvider.notifier).toggleControls(),
                child: videoPlayerState.isInitialized
                    ? Stack(
                        children: [
                          Positioned.fill(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: SizedBox(
                                width: videoPlayerState
                                    .controller!
                                    .value
                                    .size
                                    .width,
                                height: videoPlayerState
                                    .controller!
                                    .value
                                    .size
                                    .height,
                                child: VideoPlayer(
                                  videoPlayerState.controller!,
                                ),
                              ),
                            ),
                          ),
                          if (videoPlayerState.showControls)
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: AppBar(
                                backgroundColor: Colors.red,
                                title: Text(
                                  videoPlayerState.video?.title ?? 'Loading...',
                                ),
                                leading: IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () {
                                    ref
                                        .read(videoPlayerProvider.notifier)
                                        .stopAndDispose();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                actions: [
                                  IconButton(
                                    icon: const Icon(Icons.brightness_6),
                                    onPressed: () => ref
                                        .read(themeProvider.notifier)
                                        .toggleTheme(),
                                  ),
                                ],
                              ),
                            ),
                          if (videoPlayerState.showControls)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.black.withValues(alpha: 0.5),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomVideoProgressIndicator(
                                      controller: videoPlayerState.controller!,
                                      video: widget.video,
                                      allowScrubbing: true,
                                      colors: const VideoProgressColors(
                                        playedColor: Colors.blue,
                                        bufferedColor: Colors.lightBlue,
                                        backgroundColor: Colors.grey,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () => ref
                                              .read(
                                                videoPlayerProvider.notifier,
                                              )
                                              .skipBackward(),
                                          icon: const Icon(
                                            Icons.replay_10,
                                            color: Colors.white,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => ref
                                              .read(
                                                videoPlayerProvider.notifier,
                                              )
                                              .togglePlayPause(),
                                          icon: Icon(
                                            videoPlayerState.isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.white,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => ref
                                              .read(
                                                videoPlayerProvider.notifier,
                                              )
                                              .skipForward(),
                                          icon: const Icon(
                                            Icons.forward_10,
                                            color: Colors.white,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => ref
                                              .read(
                                                videoPlayerProvider.notifier,
                                              )
                                              .toggleVolume(),
                                          icon: Icon(
                                            videoPlayerState.volume > 0
                                                ? Icons.volume_up
                                                : Icons.volume_off,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
