import 'package:flutter/material.dart';

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
          image: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
          rating: '4.9',
          reviews: '320',
          location: 'Delhi NCR',
          services: 'Puja • Havan • Vivah • Muhurat',
          primary: primary,
        ),

        const SizedBox(height: 10),

        _PanditCard(
          name: 'Pandit Manoj',
          image: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
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
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 2),
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 78,
              height: 90,
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Icon(Icons.person, size: 40, color: primary);
                },
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
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
                          fontSize: 8,
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
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    Icon(Icons.location_on, size: 11, color: primary),
                    const SizedBox(width: 2),
                    Text(location, style: const TextStyle(fontSize: 9)),
                  ],
                ),

                const SizedBox(height: 3),

                Text(
                  services,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 8, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),

          SizedBox(
            height: 31,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 11),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
              child: const Text(
                'Book Now',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
