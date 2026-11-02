import 'package:flutter/material.dart';
import '../../domain/entities/product_details.dart';

class ProductDetails extends StatelessWidget {
  final ProductDetail product;

  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final info = product.productInformation;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Details',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),

          const SizedBox(height: 10),

          // Two-column details grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DetailItem(title: 'Material', value: info.material),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DetailItem(title: 'Finish', value: info.finish),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DetailItem(
                  title: 'Thali Diameter',
                  value: info.diameter,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DetailItem(title: 'Usage', value: info.usage),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DetailItem(title: 'Weight', value: info.weight),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DetailItem(title: 'Package', value: info.packaging),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String title;
  final String value;

  const _DetailItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 9,
            height: 1.3,
            fontWeight: FontWeight.w400,
            color: Color(0xFF777777),
          ),
        ),

        const SizedBox(height: 2),

        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 9,
            height: 1.35,
            fontWeight: FontWeight.w600,
            color: Color(0xFF292929),
          ),
        ),
      ],
    );
  }
}
