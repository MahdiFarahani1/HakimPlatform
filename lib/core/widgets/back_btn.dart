import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AppBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(36),
        onTap: onTap ?? () => Navigator.of(context).pop(),
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(.08) : Colors.white,
            borderRadius: BorderRadius.circular(36),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(.06),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Assets.icons.angleSmallRight.image(
              width: 24,
              height: 24,
              color: AppColor.primaryOrange,
            ),
          ),
        ),
      ),
    );
  }
}
