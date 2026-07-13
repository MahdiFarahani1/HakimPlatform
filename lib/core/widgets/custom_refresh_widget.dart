
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';

class SimpleRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const SimpleRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      color: AppColor.primaryOrange,
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      strokeWidth: 3,
      displacement: 40,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
