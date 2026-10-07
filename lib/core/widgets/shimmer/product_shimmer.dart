import 'package:flutter/material.dart';

import 'shimmer_box.dart';

class ProductShimmer extends StatelessWidget {
  const ProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerBox(width: double.infinity, height: 180, radius: 12),
        const SizedBox(height: 12),
        const ShimmerBox(width: 150, height: 16),
        const SizedBox(height: 8),
        const ShimmerBox(width: 90, height: 16),
      ],
    );
  }
}
