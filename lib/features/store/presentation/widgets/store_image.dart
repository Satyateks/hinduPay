import 'package:flutter/material.dart';

class CardImage extends StatelessWidget {
  final String image;
  final IconData icon;

  const CardImage({super.key, required this.image, required this.icon});

  @override
  Widget build(BuildContext context) {
    return image.startsWith('http')
        ? Image.network(image, fit: BoxFit.cover,errorBuilder: (_, _, _) {return _fallback(context);})
        : Image.asset(image, fit: BoxFit.cover,errorBuilder: (_, _, _) {return _fallback(context);});
  }

  Widget _fallback(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(child: Icon(icon, size: 38, color: colors.primary));
  }
}


class StoreImage extends StatelessWidget {
  final String image;
  final IconData icon;

  const StoreImage({super.key, required this.image, required this.icon});

  @override
  Widget build(BuildContext context) {
    return image.startsWith('http')
        ? Image.network(
            image, fit: BoxFit.cover,
            errorBuilder: (_, _, _) {return _fallback(context);},
          )
        : Image.asset(
            image, // fit: BoxFit.cover,
            height: 45,width: 35,
            errorBuilder: (_, _, _) {return _fallback(context);},
          );
  }

  Widget _fallback(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(child: Icon(icon, size: 38, color: colors.primary));
  }
}
