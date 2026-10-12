import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hindu_pay/app/theme/app_colors.dart';
import '../../domain/entities/home_data.dart';

class PoojaSection extends StatelessWidget {
  final List<HomePooja> poojas;

  const PoojaSection({super.key, required this.poojas});

  @override
  Widget build(BuildContext context) {
    if (poojas.isEmpty) return const SizedBox.shrink();
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 14, 10, 8),
          child: Text(
            'Popular Pujas',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
        ),

        SizedBox(
          height: 220,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            itemCount: poojas.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final pooja = poojas[index];

              return Container(
                width: 145,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all( color: AppColors.primaryRedLight,width: 1),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,//spreadRadius: 2,
                      offset: const Offset(0, 4),
                      color: Colors.black.withValues(alpha: 0.12),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 105,
                      width: double.infinity,
                      child: Image.asset(
                        pooja.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Icon(
                            Icons.auto_awesome,
                            size: 40,
                            color: primary,
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [const SizedBox(height: 9),
                          Text(
                            pooja.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Row(
                            children: [
                              Text(
                                '₹${pooja.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 13,color: AppColors.error,
                                  fontWeight: FontWeight.w500,
                              )),SizedBox(width: 8),
                              Text('Onwards',style: TextStyle(fontSize:9),),
                            ],
                          ),

                          const SizedBox(height: 7),

                          SizedBox(
                            width: double.infinity,
                            height: 27,
                            child: ElevatedButton(
                              onPressed: () {context.push('/main/donation');},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Donate Now',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
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
            },
          ),
        ),

        const SizedBox(height: 14),
      ],
    );
  }
}
