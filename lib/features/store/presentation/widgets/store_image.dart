import 'package:flutter/material.dart';

class StoreImage extends StatelessWidget {
  final String image;
  final IconData icon;

  const StoreImage({super.key, required this.image, required this.icon});

  @override
  Widget build(BuildContext context) {
    return image.startsWith('http')
        ? Image.network(
            image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return _fallback(context);
            },
          )
        : Image.asset(
            image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return _fallback(context);
            },
          );
  }

  Widget _fallback(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(child: Icon(icon, size: 38, color: colors.primary));
  }
}
