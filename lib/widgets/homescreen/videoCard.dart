import 'package:cluedin_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:shimmer/shimmer.dart';

class VideoCard extends StatefulWidget {
  final String videoUrl;

  const VideoCard({super.key, required this.videoUrl});

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool isMuted = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    String convertedLink = convertDriveLink(widget.videoUrl);
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(convertedLink),
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.pause(); // Pause initially
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
      _controller.setVolume(isMuted ? 0.0 : 1.0);
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        isPlaying = false;
      } else {
        _controller.play();
        isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _togglePlayPause,
          child: VisibilityDetector(
            key: const Key('video_card_visibility_detector'),
            onVisibilityChanged: (visibilityInfo) {
              setState(() {
                if (visibilityInfo.visibleFraction > 0.6) {
                  // Widget is visible, start playing
                  _controller.play();
                  isPlaying = true;
                } else {
                  // Widget is not visible, pause
                  _controller.pause();
                  isPlaying = false;
                }
              });
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  child: FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        double aspectRatio = _controller.value.aspectRatio;
                        return AspectRatio(
                          aspectRatio: aspectRatio,
                          child: VideoPlayer(_controller),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        // Shimmer effect while video is loading
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: Container(
                              height: 260, // Adjust the max height as needed
                              color: Colors.grey[300],
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 4.0,
                  right: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Opacity(
                      opacity: 0.7,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: IconButton(
                          icon: Icon(
                            isMuted ? Icons.volume_off : Icons.volume_up,
                            color: Colors.white,
                            size: 14,
                          ),
                          onPressed: _toggleMute,
                        ),
                      ),
                    ),
                  ),
                ),
                if (!isPlaying)
                  Positioned.fill(
                    child: Center(
                      child: Opacity(
                        opacity: 0.7,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ), // Background color
                          child: const Icon(
                            Icons.play_arrow,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Add your card content here
      ],
    );
  }
}
