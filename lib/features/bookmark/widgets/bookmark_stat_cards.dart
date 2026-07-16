import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/features/bookmark/logic/cubit/book_mark_state.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';

class BookmarkStatCards extends StatelessWidget {
  final BookmarkState state;

  const BookmarkStatCards({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _CategoryStatCard(
            title: 'الكل',
            count: state.getCategoryCount('all'),
            icon: Assets.icons.bookmark.path,
            color: AppColor.primaryOrange,
          ),
          const SizedBox(width: 12),
          _CategoryStatCard(
            title: 'فيديو',
            count: state.getCategoryCount('video'),
            icon: Assets.icons.video.path,
            color: AppColor.primaryBlue,
          ),
          const SizedBox(width: 12),
          _CategoryStatCard(
            title: 'الكتب',
            count: state.getCategoryCount('book'),
            icon: Assets.icons.bookOpenCover.path,
            color: AppColor.primaryBlue,
          ),
          const SizedBox(width: 12),
          _CategoryStatCard(
            title: 'الأخبار',
            count: state.getCategoryCount('news'),
            icon: Assets.icons.newspaper.path,
            color: AppColor.primaryBlue,
          ),
        ],
      ),
    );
  }
}

class _CategoryStatCard extends StatelessWidget {
  final String title;
  final int count;
  final String icon;
  final Color color;

  const _CategoryStatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.transparent
                  : Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(icon, width: 16, height: 16, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.grey.shade400 : const Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
