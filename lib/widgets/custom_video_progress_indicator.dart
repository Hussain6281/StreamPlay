import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/video.dart';

class CustomVideoProgressIndicator extends StatefulWidget {
  final VideoPlayerController controller;
  final Video video;
  final bool allowScrubbing;
  final VideoProgressColors colors;

  const CustomVideoProgressIndicator({
    super.key,
    required this.controller,
    required this.video,
    this.allowScrubbing = false,
    this.colors = const VideoProgressColors(),
  });

  @override
  State<CustomVideoProgressIndicator> createState() =>
      _CustomVideoProgressIndicatorState();
}

class _CustomVideoProgressIndicatorState
    extends State<CustomVideoProgressIndicator> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateProgress);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateProgress);
    super.dispose();
  }

  void _updateProgress() {
    if (mounted) {
      final position = widget.controller.value.position.inMilliseconds;
      final duration = widget.video.duration.inMilliseconds;
      if (duration > 0) {
        setState(() {
          _progress = position / duration;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4.0,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
      ),
      child: Slider(
        value: _progress.clamp(0.0, 1.0),
        onChanged: widget.allowScrubbing
            ? (value) {
                final newPosition = Duration(
                  milliseconds: (value * widget.video.duration.inMilliseconds)
                      .toInt(),
                );
                widget.controller.seekTo(newPosition);
              }
            : null,
        activeColor: widget.colors.playedColor,
        inactiveColor: widget.colors.backgroundColor,
      ),
    );
  }
}
