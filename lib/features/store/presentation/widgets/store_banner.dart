import 'package:flutter/material.dart';
import '../../domain/entities/store_home.dart';
import 'store_image.dart';

class StoreBanner extends StatelessWidget {
  final StoreHomeBanner banner;

  const StoreBanner({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 132,
          width: double.infinity,
          decoration: BoxDecoration(color: colors.surfaceContainerHighest),
          child: Stack(
            fit: StackFit.expand,
            children: [
              StoreImage(image: banner.image, icon: Icons.temple_hindu),

              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      colors.scrim.withValues(alpha: 0.55),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SizedBox(
                  width: 190,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        banner.title,
                        maxLines: 2,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        banner.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),

                      if (banner.buttonText != null) ...[
                        const SizedBox(height: 7),
                        SizedBox(
                          height: 27,
                          child: FilledButton(
                            onPressed: () {},
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                            ),
                            child: Text(
                              banner.buttonText!,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
