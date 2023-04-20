import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class AwesomeVideoValue {
  AwesomeVideoValue({
    this.aspectRatio,
    this.autoInitialize = false,
    this.autoPlay = false,
    this.startPosition,
    this.loop = false,
    this.allowScrubbing = true,
    this.fullScreenByDefault = false,
    this.showControlsOnInitialize = true,
    this.showControls = true,
    this.allowedScreenSleep = true,
    this.systemOverlaysAfterFullScreen = SystemUiOverlay.values,
    this.deviceOrientationsAfterFullScreen = const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
    this.seekSeconds = 15,
    this.progressGestureUnit = 1,
    this.volumeGestureUnit = 0.05,
    this.brightnessGestureUnit = 0.05,
  });

  final double? aspectRatio;

  final bool autoInitialize;

  final bool autoPlay;

  final Duration? startPosition;

  final bool loop;

  final bool allowScrubbing;

  final bool fullScreenByDefault;

  final bool showControlsOnInitialize;

  final bool showControls;

  final bool allowedScreenSleep;

  /// Defines the system overlays visible after exiting fullscreen
  final List<SystemUiOverlay> systemOverlaysAfterFullScreen;

  /// Defines the set of allowed device orientations after exiting fullscreen
  final List<DeviceOrientation> deviceOrientationsAfterFullScreen;

  final num seekSeconds;

  final num progressGestureUnit;

  final double volumeGestureUnit;

  final double brightnessGestureUnit;
}

class AwesomeVideoController extends ChangeNotifier {
  late VideoPlayerController videoPlayerController;

  AwesomeVideoController({
    required this.videoPlayerController,
    required AwesomeVideoValue options,
  }) : options = options ?? AwesomeVideoValue() {
    _initialize();
  }

  AwesomeVideoController.network(
    this.dataSource, {
    required this.options,
    required this.formatHint,
    this.closedCaptionFile,
  }) {
    options = options ?? AwesomeVideoValue();
    videoPlayerController = VideoPlayerController.network(
      dataSource!,
      formatHint: formatHint,
      closedCaptionFile: closedCaptionFile,
    );
    _initialize();
  }

  AwesomeVideoController.asset(
    this.dataSource, {
    required this.options,
    this.package,
    this.closedCaptionFile,
  }) {
    options = options ?? AwesomeVideoValue();
    videoPlayerController = VideoPlayerController.asset(
      dataSource!,
      package: package,
      closedCaptionFile: closedCaptionFile,
    );
    _initialize();
  }

  AwesomeVideoController.file(
    this.file, {
    required this.options,
    this.closedCaptionFile,
  }) {
    options = options ?? AwesomeVideoValue();
    videoPlayerController = VideoPlayerController.file(
      file!,
      closedCaptionFile: closedCaptionFile,
    );
    _initialize();
  }

  String? dataSource;

  File? file;

  AwesomeVideoValue options;

  dynamic package;

  VideoFormat? formatHint;

  dynamic closedCaptionFile;

  bool _isFullScreen = false;

  bool get isFullScreen => _isFullScreen;

  bool get isPlaying => videoPlayerController.value.isPlaying;

  Future _initialize() async {
    await videoPlayerController.setLooping(options.loop);

    if ((options.autoInitialize || options.autoPlay) &&
        !videoPlayerController.value.isInitialized) {
      await videoPlayerController.initialize();
    }

    if (options.autoPlay) {
      if (options.fullScreenByDefault) {
        requestFullScreen();
      }

      await videoPlayerController.play();
    }

    if (options.startPosition != null) {
      await videoPlayerController.seekTo(options.startPosition!);
    }

    if (!options.autoPlay && options.fullScreenByDefault) {
      videoPlayerController.addListener(_fullScreenListener);
    }
  }

  void _fullScreenListener() async {
    if (isPlaying && !_isFullScreen) {
      requestFullScreen();
      videoPlayerController.removeListener(_fullScreenListener);
    }
  }

  // void createController(String sourceType, dynamic datasource,
  //     {AwesomeVideoValue? options, formatHint, closedCaptionFile}) {
  //   // videoPlayerController
  //   _initialize();
  //   options = options ?? AwesomeVideoValue();

  //   if (sourceType == "file") {
  //     file = datasource;
  //     videoPlayerController = VideoPlayerController.file(file!,
  //         closedCaptionFile: closedCaptionFile);
  //   } else if (sourceType == "network") {
  //     videoPlayerController = VideoPlayerController.network(dataSource!,
  //         formatHint: formatHint, closedCaptionFile: closedCaptionFile);
  //   } else if (sourceType == "asset") {
  //     videoPlayerController = VideoPlayerController.asset(dataSource!,
  //         package: package, closedCaptionFile: closedCaptionFile);
  //   }
  // }

  void requestFullScreen() {
    _isFullScreen = true;
    notifyListeners();
  }

  void exitFullScreen() {
    _isFullScreen = false;
    notifyListeners();
  }

  void toggleFullScreen() {
    _isFullScreen = !_isFullScreen;
    notifyListeners();
  }

  Future<void> setLooping(bool looping) async {
    await videoPlayerController.setLooping(looping);
  }

  Future<void> play() async {
    if (!videoPlayerController.value.isInitialized) {
      await videoPlayerController.initialize();
    }
    if (isPlaying ||
        videoPlayerController.value.position >=
            videoPlayerController.value.duration) return;
    await videoPlayerController.play();
  }

  Future<void> pause() async {
    if (!isPlaying) return;
    await videoPlayerController.pause();
  }

  Future<void> togglePlay() async {
    isPlaying ? pause() : play();
  }

  Future<void> seekTo(Duration moment) async {
    await videoPlayerController.seekTo(moment);
  }

  Future<void> setVolume(double volume) async {
    await videoPlayerController.setVolume(volume);
  }

  void end() {
    videoPlayerController.dispose();
    // videoPlayerController.value = VideoPlayerValue(duration: null);
    notifyListeners();
  }

  void updateVideoSource(dataSource) {
    videoPlayerController.pause();
    videoPlayerController.seekTo(const Duration(seconds: 0));
    videoPlayerController.value = const VideoPlayerValue.uninitialized();
    final netRegx = RegExp(r'^(http|https):\/\/([\w.]+\/?)\S*');
    // final netRegx = new RegExp(r'^(http|https):\/\/([\w.]+\/?)\S*');
    final isNetwork = netRegx.hasMatch(dataSource);
    if (isNetwork) {
      videoPlayerController = VideoPlayerController.network(dataSource,
          formatHint: formatHint, closedCaptionFile: closedCaptionFile);
    } else if (dataSource is File) {
      videoPlayerController = VideoPlayerController.file(file!,
          closedCaptionFile: closedCaptionFile);
    }

    notifyListeners();
    _initialize();
  }

  void disposeVideoController() {
    // TODO: implement dispose
    videoPlayerController.dispose();
  }

  // void changeDataSource(dataSource) {
  //   if (dataSource is File) {
  //     if (this.file != dataSource) {
  //       videoPlayerController = AwesomeVideoController.file(this.file, options: this.options, closedCaptionFile: this.closedCaptionFile)
  //     }
  //   }
  // }
}
