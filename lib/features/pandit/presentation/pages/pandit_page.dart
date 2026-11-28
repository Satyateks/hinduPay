import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_img.dart';
import '../../domain/entities/pandit.dart';
import '../bloc/pandit_bloc.dart';
import '../bloc/pandit_state.dart';

class PanditsPage extends StatelessWidget {
  const PanditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchHeader(context),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 10),
              child: Text(
                'Book Pandit Ji',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1E1E),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<PanditBloc, PanditState>(
                builder: (context, state) {
                  if (state.status == PanditStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFFFF6B00)),
                    );
                  }
                  if (state.services.isEmpty &&
                      state.status == PanditStatus.loaded) {
                    return const Center(
                      child: Text('No Pooja services available'),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 100),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.56,
                    ),
                    itemCount: state.services.length,
                    itemBuilder: (context, index) {
                      return _PoojaServiceCard(
                        service: state.services[index],
                        onBookNow: () {
                          context.push(
                            '/main/pandits/booking',
                            extra: state.services[index],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, size: 20, color: Color(0xFF9E9E9E)),
                  SizedBox(width: 8),
                  Text(
                    'Search',
                    style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                  ),
                  Spacer(),
                  Icon(Icons.mic_none, size: 20, color: Color(0xFF9E9E9E)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF5F5F5),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: const Icon(
              Icons.person_outline,
              size: 22,
              color: Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }
}

// ========================================================================
// Pooja Service Card  (matches Image 1 reference)
// ========================================================================

class _PoojaServiceCard extends StatelessWidget {
  final PanditPoojaService service;
  final VoidCallback onBookNow;

  const _PoojaServiceCard({required this.service, required this.onBookNow});

  static const Color _accentOrange = Color(0xFFFF6B00);

  String _getServiceImage(String visualKind) {
    switch (visualKind) {
      case 'rahu_ketu':
      case 'rudrabhishek':
      case 'satyanarayan':
        return AppImg.panditjiImg;
      case 'saraswati':
      case 'navgrah':
      case 'griha_pravesh':
        return AppImg.pandirmanImg;
      default:
        return AppImg.poojaAnushthanImg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service image
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              height: 115,
              width: double.infinity,
              child: Image.asset(
                _getServiceImage(service.visualKind),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFFFF3E0),
                  child: const Icon(Icons.temple_hindu,
                      size: 40, color: _accentOrange),
                ),
              ),
            ),
          ),

          // Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price + rating row
                  Row(
                    children: [
                      Text(
                        _fmt(service.price),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star,
                          size: 13, color: _accentOrange),
                      Text(
                        service.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  // Original price + review count
                  Row(
                    children: [
                      Text(
                        _fmt(service.originalPrice),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9E9E9E),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '(${service.reviewCountLabel})',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Title (2 lines)
                  Text(
                    service.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E1E1E),
                      height: 1.3,
                    ),
                  ),

                  const Spacer(),

                  // Book Now button
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: onBookNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentOrange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _fmt(int amount) {
    final raw = amount.toString();
    if (raw.length <= 3) return '₹$raw';
    final lastThree = raw.substring(raw.length - 3);
    final rest = raw.substring(0, raw.length - 3);
    final buffer = StringBuffer();
    for (var i = 0; i < rest.length; i++) {
      final posFromRight = rest.length - i;
      buffer.write(rest[i]);
      if (posFromRight > 1 && posFromRight.isOdd) buffer.write(',');
    }
    return '₹$buffer,$lastThree';
  }
}
