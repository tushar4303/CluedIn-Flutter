// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cluedin_app/models/home.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class CarouselCard extends StatelessWidget {
//   const CarouselCard({Key? key, required this.slide}) : super(key: key);

//   final CarouselSlide slide;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//         left: 8.0,
//         right: 8.0,
//       ),
//       child: GestureDetector(
//         onTap: () async {
//           final url = Uri.parse(slide.redirectUrl);
//           if (!await launchUrl(url)) {
//             throw 'Could not launch $url';
//           }
//         },
//         child: ClipRRect(
//           borderRadius: const BorderRadius.all(Radius.circular(16.0)),
//           child: CachedNetworkImage(
//             imageUrl: "http://cluedin.creast.in:5000/${slide.photoUrl}",
//             fit: BoxFit.cover,
//             placeholder: (context, url) {
//               return Image.asset(
//                 "assets/images/placeholder_landscape.png",
//                 fit: BoxFit.cover,
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cluedin_app/models/home.dart';
import 'package:cluedin_app/utils/links.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CarouselCard extends StatelessWidget {
  const CarouselCard({super.key, required this.slide});

  final CarouselSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: GestureDetector(
        onTap: () async {
          final url = Uri.parse(slide.redirectUrl);
          if (!await launchUrl(url)) {
            throw 'Could not launch $url';
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.grey.withOpacity(0.025)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 3,
                  offset: const Offset(0.0, 0.75))
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: CachedNetworkImage(
              imageUrl: "$baseServerUrl${slide.photoUrl}",
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Image.asset(
                  "assets/images/placeholder_landscape.png",
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
