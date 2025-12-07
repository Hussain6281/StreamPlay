class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String videoUrl;
  final Duration duration;
  final String? localPath;

  Video({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    this.localPath,
  });

  Video copyWith({
    String? id,
    String? title,
    String? thumbnailUrl,
    String? videoUrl,
    Duration? duration,
    String? localPath,
  }) {
    return Video(
      id: id ?? this.id,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      duration: duration ?? this.duration,
      localPath: localPath ?? this.localPath,
    );
  }
}
