import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';

class PremiumBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PremiumBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<PremiumBottomNav> createState() => _PremiumBottomNavState();
}

class _PremiumBottomNavState extends State<PremiumBottomNav> {
  final List<String> icons = [
    Assets.icons.home.path,
    Assets.icons.search.path,
    Assets.icons.bookmark.path,
    Assets.icons.video.path,
    Assets.icons.gallery.path,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(icons.length, (index) {
          final isActive = widget.currentIndex == index;

          return GestureDetector(
            onTap: () => widget.onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColor.primaryBlue.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    duration: const Duration(milliseconds: 250),
                    scale: isActive ? 1.2 : 1.0,
                    child: Image.asset(
                      icons[index],
                      width: 20,
                      height: 20,
                      color: isActive ? AppColor.primaryBlue : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 4,
                    width: isActive ? 8 : 0,
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
