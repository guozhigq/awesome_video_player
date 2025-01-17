import 'package:flutter/material.dart';
import '../style/video_loading_style.dart';

class VideoLoadingView extends StatelessWidget {
  VideoLoadingView({this.loadingStyle});

  final VideoLoadingStyle? loadingStyle;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            loadingStyle!.customLoadingIcon ??
                const CircularProgressIndicator(strokeWidth: 2.0),
            loadingStyle!.customLoadingText != null
                ? loadingStyle!.customLoadingText!
                : Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      loadingStyle!.loadingText,
                      style: TextStyle(
                        color: loadingStyle!.loadingTextFontColor,
                        fontSize: loadingStyle!.loadingTextFontSize,
                      ),
                    ))
          ],
        ),
      ),
    );
  }
}
