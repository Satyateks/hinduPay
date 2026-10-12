import 'package:flutter/material.dart';
import 'package:hindu_pay/app/theme/app_colors.dart';
import 'package:hindu_pay/core/widgets/app_img.dart';

class PanditSection extends StatelessWidget {
  const PanditSection({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 4, 10, 8),
          child: Text(
            'Find Pandit Ji',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
        ),

        _PanditCard(
          name: 'Pandit Raj Sharma',
          image: AppImg.pandirmanImg,
          rating: '4.9',
          reviews: '320',
          location: 'Delhi NCR',
          services: 'Puja • Havan • Vivah • Muhurat',
          primary: primary,
        ),

        const SizedBox(height: 10),

        _PanditCard(
          name: 'Pandit Manoj',
          image: AppImg.pandirmanImg,
          rating: '4.9',
          reviews: '210',
          location: 'Delhi NCR',
          services: 'Puja • Havan • Muhurat',
          primary: primary,
        ),
        const SizedBox(height: 10),
        _PanditCard(
          name: 'Pandit Raj Sharma',
          image: AppImg.panditjiImg,
          rating: '4.9',
          reviews: '320',
          location: 'Delhi NCR',
          services: 'Puja • Havan • Vivah • Muhurat',
          primary: primary,
        ),
        const SizedBox(height: 10),
        _PanditCard(
          name: 'Pandit Shivani Sharma',
          image: AppImg.panditjiImg,
          rating: '4.9',
          reviews: '320',
          location: 'Noida NCR',
          services: 'Puja • Havan • Vivah • Muhurat',
          primary: primary,
        ),
        const SizedBox(height: 10),
        _PanditCard(
          name: 'Pandit Manoj',
          image: AppImg.pandirmanImg,
          rating: '4.9',
          reviews: '210',
          location: 'Delhi NCR',
          services: 'Puja • Havan • Muhurat',
          primary: primary,
        ),
      ],
    );
  }
}

class _PanditCard extends StatelessWidget {
  final String name;
  final String image;
  final String rating;
  final String reviews;
  final String location;
  final String services;
  final Color primary;

  const _PanditCard({
    required this.name,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.location,
    required this.services,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,spreadRadius: 1,
            offset: const Offset(0, 2),
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 118,
            height: 162,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Icon(Icons.person, size: 40, color: primary);
              },
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        '✓ Verified',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text('⭐', style: TextStyle(fontSize: 9)),
                    Text(
                      ' $rating ($reviews reviews)',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 13, color: AppColors.primary),
                    const SizedBox(width: 2),
                    Text(location, style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  services,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Align(alignment: AlignmentGeometry.bottomRight,
                  child: SizedBox(
                    width: 102,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 11),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(44),
                        ),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
         
              ],
            ),
          ),
        ],
      ),
    );
  }
}
