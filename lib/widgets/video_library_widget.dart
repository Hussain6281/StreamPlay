import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/video_provider.dart';
import '../routes/routes.dart';

class VideoLibraryWidget extends ConsumerWidget {
  const VideoLibraryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoLibraryState = ref.watch(videoLibraryProvider);
    final videos = videoLibraryState.videos;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.videoPlayer,
                arguments: video,
              );
            },

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    video.thumbnailUrl,
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
                      height: 80,
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Icon(
                        Icons.broken_image,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${video.duration.inMinutes}:${(video.duration.inSeconds % 60).toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
