import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Offline extends StatelessWidget {
  const Offline({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        child: SvgPicture.asset("assets/images/offline.svg"));
  }
}
