import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../style/video_progress_style.dart';

class VideoDefaultProgressBar extends StatelessWidget {
  const VideoDefaultProgressBar(
    this.controller, {
    super.key,
    this.allowScrubbing,
    this.progressStyle,
  });
  final VideoPlayerController? controller;
  final bool? allowScrubbing;
  final VideoProgressStyle? progressStyle;

  @override
  Widget build(BuildContext context) {
    return VideoProgressIndicator(
      controller!,
      allowScrubbing: allowScrubbing!,
      colors: VideoProgressColors(
        playedColor: progressStyle!.playedColor!,
        bufferedColor: progressStyle!.bufferedColor,
        backgroundColor: progressStyle!.backgroundColor,
      ),
      padding: progressStyle!.padding,
    );
  }
}
