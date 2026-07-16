import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/widgets/back_btn.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget icon;
  final List<Color>? gradientColors;
  final bool showBackButton;

  const CustomHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.gradientColors,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 12,
        bottom: 16,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.85),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (showBackButton) ...[
            const AppBackButton(),
            const SizedBox(width: 12),
          ],
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors ?? [
                  AppColor.primaryBlue,
                  AppColor.primaryBlue.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: (gradientColors?.first ?? AppColor.primaryBlue).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: icon,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    subtitle,
                    key: ValueKey<String>(subtitle),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColor.primaryBlue.withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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
