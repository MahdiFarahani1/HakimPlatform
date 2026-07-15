import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/features/bookmark/logic/cubit/book_mark_cubit.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarkCategoryChips extends StatelessWidget {
  final String selectedCategory;

  const BookmarkCategoryChips({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "التصنيفات",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A1F36),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _CategoryChip(
                  label: 'الكل',
                  category: 'all',
                  icon: Assets.icons.bookmark.path,
                  isSelected: selectedCategory == 'all',
                ),
                const SizedBox(width: 12),
                _CategoryChip(
                  label: 'فيديو',
                  category: 'video',
                  icon: Assets.icons.video.path,
                  isSelected: selectedCategory == 'video',
                ),
                const SizedBox(width: 12),
                _CategoryChip(
                  label: 'الكتب',
                  category: 'book',
                  icon: Assets.icons.bookOpenCover.path,
                  isSelected: selectedCategory == 'book',
                ),
                const SizedBox(width: 12),
                _CategoryChip(
                  label: 'الأخبار',
                  category: 'news',
                  icon: Assets.icons.newspaper.path,
                  isSelected: selectedCategory == 'news',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final String category;
  final String icon;
  final bool isSelected;

  const _CategoryChip({
    required this.label,
    required this.category,
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.read<BookmarkCubit>().selectCategory(category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryBlue
              : context.theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? Colors.white10 : const Color(0xFFE5E7EB)),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon,
              width: 16,
              height: 16,
              color: isSelected
                  ? AppColor.primaryOrange
                  : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColor.primaryOrange
                    : (isDark
                          ? Colors.grey.shade300
                          : const Color(0xFF374151)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
