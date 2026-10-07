import 'package:flutter/material.dart';

import '../../../../pooja/presentation/widgets/pooja_banner.dart';
import '../../../../pooja/presentation/widgets/pooja_categories.dart';
import '../../../../pooja/presentation/widgets/popular_pooja_section.dart';
import '../../../../pooja/presentation/widgets/recommended_pooja_section.dart';

class PoojaHomeView extends StatelessWidget {
  const PoojaHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: PoojaBanner()),
        SliverToBoxAdapter(child: PoojaCategories()),
        SliverToBoxAdapter(child: PopularPoojaSection()),
        SliverToBoxAdapter(child: RecommendedPoojaSection()),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}
