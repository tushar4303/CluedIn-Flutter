import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EventWidgetShimmer extends StatelessWidget {
  const EventWidgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Container(
              height: 260,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.topLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 18,
                color: Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
