import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';

class CustomErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String message;

  const CustomErrorWidget({
    super.key,
    required this.onRetry,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                  width: context.screenWidth * 0.35,
                  height: context.screenWidth * 0.35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.primaryBlue.withOpacity(0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Image.asset(
                      Assets.icons.squareInfo.path,
                      color: AppColor.primaryBlue,
                      width: 30,
                      height: 30,
                    ),
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                ),

            context.gap(24),

            Text(
                  'حدثت مشكلة!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: context.theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(duration: 400.ms, delay: 200.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOutQuad),

            context.gap(12),

            Text(
                  message,
                  style: TextStyle(
                    fontSize: 15,
                    color: context.theme.brightness == Brightness.dark
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(duration: 400.ms, delay: 300.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

            context.gap(32),

            Material(
                  elevation: 0,
                  borderRadius: BorderRadius.circular(8),
                  color: AppColor.primaryBlue,
                  child: InkWell(
                    onTap: onRetry,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                                Assets.icons.refresh.path,
                                color: AppColor.primaryOrange,
                                width: 10,
                                height: 10,
                              )
                              .animate(
                                onPlay: (controller) =>
                                    controller.repeat(period: 2.seconds),
                              )
                              .rotate(
                                begin: 0,
                                end: 360,
                                duration: 1500.ms,
                                curve: Curves.linear,
                              ),
                          context.gap(8),
                          const Text(
                            'إعادة المحاولة',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColor.primaryOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 400.ms, delay: 400.ms)
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1, 1),
                  curve: Curves.easeOutBack,
                )
                .shake(duration: 500.ms, delay: 500.ms),
          ],
        ),
      ),
    );
  }
}
