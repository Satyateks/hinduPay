import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hindu_pay/app/theme/app_colors.dart';

import '../../../../core/widgets/app_img.dart';
import '../../domain/entities/home_data.dart';

class QuickActions extends StatelessWidget {
  final List<HomeQuickAction> actions;
  const QuickActions({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    final items = actions.isNotEmpty ? actions : _defaultActions;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF70000), Color(0xFFFFFFFF)],
          stops: [0.422, 1.0],
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Darmik Seva',
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.4, // 28px line-height / 20px font-size
              letterSpacing: 0,color: AppColors.surface,
            ),
          ),
 
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 6,
              childAspectRatio: 0.90,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return _QuickActionItem(
                item: item,
                onTap: () {
                   switch (item.icon.toLowerCase()) {
                    case 'donation':context.push('/main/donation');break;
                    case 'pooja':context.push('/main/pooja');break;
                    case 'pandit':context.push('/main/pandits');break;
                    case 'mandir':context.push('/main/mandir');break;
                    case 'prasad':context.push('/prasad');break;
                    case 'sanskar':context.push('/sanskar');break;
                    case 'vivah sanskar':context.push('/vivah-sanskar');break;
                    case 'yatra':context.push('/yatra');break;
                  }
                },
              );
            },
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(21),
            child: Image.asset(
              AppImg.bannerImg,
              fit: BoxFit.cover,
              width: double.maxFinite,
            ),
          ),          
          SizedBox(height: 14),
       ],
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final HomeQuickAction item;
  final VoidCallback onTap;

  const _QuickActionItem({required this.item, required this.onTap});

  String _getImage(String value) {
    switch (value.toLowerCase()) {
      case 'donation':
      case 'daan':
      case 'daan & seva':return AppImg.daanSevaImg;
      case 'pooja':
      case 'pooja & anushthan':return AppImg.poojaAnushthanImg;
      case 'pandit':
      case 'pandit ji':return AppImg.panditjiImg;
      case 'mandir':
      case 'temple':return AppImg.mandirImg;
      case 'prasad':return AppImg.prasadImg;
      case 'sanskar':return AppImg.sanskarImg;
      case 'vivah':
      case 'vivah sanskar':return AppImg.vivahSanskarImg;
      case 'yatra':return AppImg.yatraImg;
      default:return AppImg.daanSevaImg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      // borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(_getImage(item.icon),// width: 46,height: 46,fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12,height: 1.4,letterSpacing: 0.1,color: AppColors.surface, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

const List<HomeQuickAction> _defaultActions = [
  HomeQuickAction(id: '1', title: 'Daan & Seva', icon: 'donation'),
  HomeQuickAction(id: '2', title: 'Pooja & Anushthan', icon: 'pooja'),
  HomeQuickAction(id: '3', title: 'Pandit Ji', icon: 'pandit'),
  HomeQuickAction(id: '4', title: 'Mandir', icon: 'mandir'),
  HomeQuickAction(id: '5', title: 'Prasad', icon: 'prasad'),
  HomeQuickAction(id: '6', title: 'Sanskar', icon: 'sanskar'),
  HomeQuickAction(id: '7', title: 'Vivah Sanskar', icon: 'vivah sanskar'),
  HomeQuickAction(id: '8', title: 'Yatra', icon: 'yatra'),
];
