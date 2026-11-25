import 'package:flutter/material.dart';

class UpiServiceIcon extends StatelessWidget {
  final String label;
  final Widget iconWidget;
  final VoidCallback onTap;
  final double circleSize;
  final Color? glowColor;

  const UpiServiceIcon({
    super.key,
    required this.label,
    required this.iconWidget,
    required this.onTap,
    this.circleSize = 66,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.orange.withValues(alpha: 0.12),
      highlightColor: Colors.orange.withValues(alpha: 0.06),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconWidget,//const SizedBox(height: 6),
            SizedBox(
              height: 32,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C2C2C),
                  height: 1.2,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper to render stylized 3D-like icons for various UPI services
class ServiceIconGraphic extends StatelessWidget {
  final String icon;
  // final List<Color> gradientColors;
  final IconData? secondaryIcon;
  final Color? badgeColor;

  const ServiceIconGraphic({
    super.key,
    required this.icon,
    // required this.gradientColors,
    this.secondaryIcon,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 61,
      height: 61,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Gradient background container for icon
          // Container(
            // width: 56,height: 56,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10),
            //   gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: gradientColors),
            //   boxShadow: [
            //     BoxShadow(
            //       color: gradientColors.first.withValues(alpha: 0.3),
            //       blurRadius: 6,
            //       offset: const Offset(0, 2),
            //     ),
            //   ],
            // ),child: 
            Image.asset(icon),
          //  ),
          if (secondaryIcon != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: badgeColor ?? Colors.amber,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Icon(secondaryIcon, size: 9, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
