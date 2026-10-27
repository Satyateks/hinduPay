import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/home_data.dart';

class TempleSection extends StatelessWidget {
  final List<HomeTemple> temples;

  const TempleSection({super.key, required this.temples});

  @override
  Widget build(BuildContext context) {
    if (temples.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Popular Temples', onTap: ()=>context.push('/donation/templeList')),
        SizedBox(
          height: 231,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            itemCount: temples.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return _TempleCard(temple: temples[index]);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _TempleCard extends StatelessWidget {
  final HomeTemple temple;
  const _TempleCard({required this.temple});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primaryRedLight,width: 1),
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [BoxShadow(blurRadius: 8,offset: const Offset(0, 2),color: Colors.black.withValues(alpha: 0.08))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 135,
            width: double.infinity,
            child: Image.asset(
              temple.image,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                return const Icon(Icons.temple_hindu, size: 51);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(9, 7, 9, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  temple.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 20 / 14, // 20px line-height
                    letterSpacing: 0,
                  ),
                ),

                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color:AppColors.primary),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        temple.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12,height: 16 / 12,fontFamily: 'Plus Jakarta Sans',fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {context.push('/main/donation');},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: colors.onSecondary,
                      elevation: 1,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(44)),
                    ),
                    child: const Text(
                      'Donate Now',
                      style: TextStyle(
                        fontSize: 14,height: 20 / 14,fontFamily: 'Plus Jakarta Sans', 
                        fontWeight: FontWeight.w600,
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SectionHeader({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 8),
      child: InkWell(onTap: onTap,
        child: Row(
          children: [
            Text(title,style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            // const Spacer(),
            // Text('View All', style: TextStyle(color:  colors.surface,fontSize: 10,fontWeight: FontWeight.w600)),
            Icon(Icons.chevron_right, size: 24,color:  AppColors.error),// color: colors.onSurface
          ],
        ),
      ),
    );
  }
}
