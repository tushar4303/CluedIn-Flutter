// import 'package:flutter/material.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// class YoutubeVideoCard extends StatefulWidget {
//   final String videoUrl;

//   const YoutubeVideoCard({Key? key, required this.videoUrl}) : super(key: key);

//   @override
//   _YoutubeVideoCardState createState() => _YoutubeVideoCardState();
// }

// class _YoutubeVideoCardState extends State<YoutubeVideoCard> {
//   late YoutubePlayerController _controller;
//   bool isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: YoutubePlayerController.convertUrlToId(widget.videoUrl)!,
//       params: const YoutubePlayerParams(
//         showControls: false,
//         autoPlay: false,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _togglePlayPause() {
//     setState(() {
//       if (isPlaying) {
//         _controller.pause();
//         isPlaying = false;
//       } else {
//         _controller.play();
//         isPlaying = true;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: _togglePlayPause,
//           child: VisibilityDetector(
//             key: const Key('youtube_card_visibility_detector'),
//             onVisibilityChanged: (visibilityInfo) {
//               setState(() {
//                 if (visibilityInfo.visibleFraction > 0.6) {
//                   // Widget is visible, start playing
//                   _controller.play();
//                   isPlaying = true;
//                 } else {
//                   // Widget is not visible, pause
//                   _controller.pause();
//                   isPlaying = false;
//                 }
//               });
//             },
//             child: Stack(
//               children: [
//                 YoutubePlayerIFrame(
//                   controller: _controller,
//                   aspectRatio: 16 / 9,
//                 ),
//                 if (!isPlaying)
//                   Positioned.fill(
//                     child: Center(
//                       child: Opacity(
//                         opacity: 0.7,
//                         child: Container(
//                           height: 50,
//                           width: 50,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.black,
//                           ), // Background color
//                           child: const Icon(
//                             Icons.play_arrow,
//                             size: 30,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//         // Add your card content here
//       ],
//     );
//   }
// }
