import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeCard extends StatefulWidget {
  final String youtubeLink;

  const YoutubeCard({
    Key? key,
    required this.youtubeLink,
  }) : super(key: key);

  @override
  State<YoutubeCard> createState() => _YoutubeCardState();
}

class _YoutubeCardState extends State<YoutubeCard> {
  final _ytController = YoutubePlayerController(
    params: const YoutubePlayerParams(
      showFullscreenButton: false,
      mute: true,
      showControls: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    _play();
  }

  Future<void> _play() async {
    final videoId = _getVideoId(widget.youtubeLink);
    if (videoId == null) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Please make sure it is in either "https://youtu.be/\$id" or "https://www.youtube.com/watch?v=\$id" format!',
            ),
          ),
        );
      return;
    }
    await _ytController.loadVideoById(videoId: videoId);
  }

  String? _getVideoId(String url) {
    if (url.startsWith('https://youtu.be/')) {
      return url.substring('https://youtu.be/'.length);
    } else if (url.startsWith('https://www.youtube.com/watch?v=')) {
      return url.substring('https://www.youtube.com/watch?v='.length);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.youtubeLink), // Ensure a unique key for each instance
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.6) {
          // Video is not visible, pause it
          _ytController.playVideo();
        } else {
          // Video is visible, play or resume it
          _ytController.pauseVideo();
        }
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: YoutubePlayerScaffold(
          autoFullScreen: false,
          enableFullScreenOnVerticalDrag: false,
          lockedOrientations: const [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown
          ],
          builder: (ctx, player) => SingleChildScrollView(
            child: Column(
              children: [
                player,
              ],
            ),
          ),
          controller: _ytController,
        ),
      ),
    );
  }
}
