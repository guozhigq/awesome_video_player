import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import './style/video_style.dart';

import 'controls/video_controls.dart';
import '../contoller/video_controller.dart';
import '../model/changenotify_provider.dart';

typedef VideoCallback<T> = void Function(T t);

class PlayerWithControls extends StatelessWidget {
  const PlayerWithControls({
    Key? key,
    this.videoStyle,
    this.onpop,
    this.ontimeupdate,
    this.onended,
    this.onprogressdragStart,
    this.onprogressdragUpdate,
    this.onprogressdragEnd,
    this.children,
  }) : super(key: key);

  final VideoStyle? videoStyle;
  final VideoCallback? onpop;
  final VideoCallback<VideoPlayerValue>? ontimeupdate;
  final VideoCallback<VideoPlayerValue>? onended;
  final Function? onprogressdragStart;
  final Function(Duration position, Duration duration)? onprogressdragUpdate;
  final Function? onprogressdragEnd;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    final AwesomeVideoController awesomeController =
        ChangeNotifierProvider.of(context);
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
          aspectRatio: awesomeController.options.aspectRatio ??
              _calculateAspectRatio(context),
          child: PlayerControls(
            videoStyle: videoStyle,
            onpop: onpop,
            ontimeupdate: ontimeupdate,
            onprogressdragStart: onprogressdragStart,
            onprogressdragUpdate: onprogressdragUpdate,
            onprogressdragEnd: onprogressdragEnd,
            children: children,
          ),
        ),
      ),
    );
  }

  double _calculateAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return width > height ? width / height : height / width;
  }
}
