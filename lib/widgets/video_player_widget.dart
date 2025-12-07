// video_player_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../models/video.dart';
import '../providers/video_player_provider.dart';
import '../providers/theme_provider.dart';
import 'custom_video_progress_indicator.dart';

class VideoPlayerWidget extends ConsumerWidget {
  final Video video;

  const VideoPlayerWidget({super.key, required this.video});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoPlayerState = ref.watch(videoPlayerProvider);

    return GestureDetector(
      onTap: () => ref.read(videoPlayerProvider.notifier).toggleControls(),
      child: videoPlayerState.isInitialized
          ? Stack(
              children: [
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: videoPlayerState.controller!.value.size.width,
                      height: videoPlayerState.controller!.value.size.height,
                      child: VideoPlayer(videoPlayerState.controller!),
                    ),
                  ),
                ),
                if (videoPlayerState.showControls)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      title: Text(videoPlayerState.video?.title ?? 'Video'),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          ref
                              .read(videoPlayerProvider.notifier)
                              .stopAndDispose();
                          Navigator.pop(context);
                        },
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.brightness_6),
                          onPressed: () =>
                              ref.read(themeProvider.notifier).toggleTheme(),
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
                      color: Colors.black.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomVideoProgressIndicator(
                            controller: videoPlayerState.controller!,
                            video: video,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                              playedColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              bufferedColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surfaceVariant,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () => ref
                                    .read(videoPlayerProvider.notifier)
                                    .skipBackward(),
                                icon: Icon(
                                  Icons.replay_10,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              IconButton(
                                onPressed: () => ref
                                    .read(videoPlayerProvider.notifier)
                                    .togglePlayPause(),
                                icon: Icon(
                                  videoPlayerState.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              IconButton(
                                onPressed: () => ref
                                    .read(videoPlayerProvider.notifier)
                                    .skipForward(),
                                icon: Icon(
                                  Icons.forward_10,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              IconButton(
                                onPressed: () => ref
                                    .read(videoPlayerProvider.notifier)
                                    .toggleVolume(),
                                icon: Icon(
                                  videoPlayerState.volume > 0
                                      ? Icons.volume_up
                                      : Icons.volume_off,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              IconButton(
                                onPressed: () => ref
                                    .read(videoPlayerProvider.notifier)
                                    .toggleFullscreen(),
                                icon: Icon(
                                  videoPlayerState.isFullscreen
                                      ? Icons.fullscreen_exit
                                      : Icons.fullscreen,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
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
  }
}
