import 'package:cached_network_image/cached_network_image.dart';
import 'package:cluedin_app/models/home.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CarouselCard extends StatelessWidget {
  const CarouselCard({Key? key, required this.slide}) : super(key: key);

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
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: CachedNetworkImage(
            imageUrl: "http://cluedin.creast.in:5000/${slide.photoUrl}",
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
    );
  }
}
