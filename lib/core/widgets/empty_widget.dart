import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptySearchWidget extends StatelessWidget {
  const EmptySearchWidget({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.a404.image(
            width: 55.w,
            height: 55.h,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            controller.text.isEmpty
                ? 'لا توجد فيديوهات'
                : 'لا توجد نتائج لـ "${controller.text}"',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    ).animate().scale().fade();
  }
}
