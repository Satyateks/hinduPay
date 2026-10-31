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
  void didUpdateWidget(covariant ProductGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (selectedIndex >= widget.images.length) selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (widget.images.isEmpty) {
      return Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F0EB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 40,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main product image
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 255,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.images[selectedIndex],
                    key: ValueKey(widget.images[selectedIndex]),
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) {
                      return Container(
                        color: const Color(0xFFF4F0EB),
                        child: Icon(
                          Icons.image_outlined,
                          size: 88,
                          color: colors.primary,
                        ),
                      );
                    },
                  ),

                  // Page indicator
                  if (widget.images.length > 1)
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(widget.images.length, (index) {
                          final active = index == selectedIndex;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: active ? 13 : 6,
                            height: 4,
                            decoration: BoxDecoration(
                              color: active
                                  ? const Color(0xFF087D3B)
                                  : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Thumbnail images
        SizedBox(
          height: 65,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final selected = selectedIndex == index;

              return GestureDetector(
                onTap: () => setState(() => selectedIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF087D3B)
                          : const Color(0xFFE0E0E0),
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      widget.images[index],
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          color: colors.surfaceContainerHighest,
                          child: const Icon(Icons.image_outlined, size: 18),
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