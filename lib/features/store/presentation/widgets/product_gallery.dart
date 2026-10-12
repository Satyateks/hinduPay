import 'package:flutter/material.dart';

class ProductGallery extends StatefulWidget {
  final List<String> images;
  const ProductGallery({super.key, required this.images});

  @override
  State<ProductGallery> createState() => ProductGalleryState();
}

class ProductGalleryState extends State<ProductGallery> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (widget.images.isEmpty) {
      return const SizedBox(
        height: 280,
        child: Center(
          child: Icon(Icons.image_not_supported_outlined, size: 50),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.asset(
                widget.images[selectedIndex],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    color: colors.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_outlined,
                      size: 50,
                      color: colors.primary,
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        SizedBox(
          height: 58,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final selected = selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  width: 58,
                  height: 58,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selected ? colors.primary : colors.outlineVariant,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      widget.images[index],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Icon(
                          Icons.image_outlined,
                          color: colors.primary,
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
