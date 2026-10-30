import 'package:flutter/material.dart';

import '../../domain/entities/product_details.dart';

class IncludedItems extends StatelessWidget {
  final List<ProductIncludedItem> items;

  const IncludedItems({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section heading
        Row(
          children: [
            const Text(
              "What's Included",
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${items.length} Items)',
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 11,
                color: Color(0xFF777777),
              ),
            ),
          ],
        ),
    
        const SizedBox(height: 7),
    
        // Included product items
        SizedBox(
          height: 91,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 7),
            itemBuilder: (context, index) {
              final item = items[index];
    
              return SizedBox(
                width: 42,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Item image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset(
                          item.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Container(
                              color: const Color(0xFFF1EEE9),
                              child: const Icon(
                                Icons.inventory_2_outlined,
                                size: 18,
                                color: Color(0xFF8A7765),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
    
                    const SizedBox(height: 4),
    
                    // Item name
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 8,
                        height: 1.15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
    
                    const SizedBox(height: 2),
    
                    // Quantity
                    Text('(${item.quantity})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 7,color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
