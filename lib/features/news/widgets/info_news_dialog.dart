import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/core/utils/share.dart';
import 'package:flutter_application_1/core/widgets/snackbar_common.dart';
import 'package:flutter_application_1/features/bookmark/data/models/bookmark_model.dart';
import 'package:flutter_application_1/features/bookmark/logic/cubit/book_mark_cubit.dart';
import 'package:flutter_application_1/features/bookmark/logic/cubit/book_mark_state.dart';
import 'package:flutter_application_1/features/news/data/models/news_model.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showNewsInfoDialog(BuildContext context, NewsModel news) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => NewsInfoDialog(news: news),
  );
}

class NewsInfoDialog extends StatelessWidget {
  final NewsModel news;

  const NewsInfoDialog({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.onPrimaryContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: news.image.isNotEmpty
                          ? Image.network(
                              news.image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildPlaceholder(),
                            )
                          : _buildPlaceholder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          news.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: context.theme.brightness == Brightness.dark
                                ? Colors.white
                                : const Color(0xFF1E293B),
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: news.languageColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          news.languageName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(
                        context: context,
                        icon: Assets.icons.clockThree.path,
                        label: news.createdAt.toRelativeTime(),
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        context: context,
                        icon: Assets.icons.category.path,
                        label: news.categoryId.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 4,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    news.intro ?? 'لا يوجد وصف لهذا الخبر',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: context.theme.brightness == Brightness.dark
                          ? Colors.grey.shade300
                          : Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          context,
                          icon: Assets.icons.shareSquare.path,
                          label: 'مشاركة',
                          color: AppColor.primaryOrange,
                          onTap: () {
                            ShareHelper.shareContent(
                              title: news.title,
                              content: news.intro ?? "no intro",
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          context,
                          icon: Assets.icons.browser.path,
                          label: 'نسخ الرابط',
                          color: AppColor.primaryOrange,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BlocBuilder<BookmarkCubit, BookmarkState>(
                          builder: (context, state) {
                            final isSaved = state.savedItems.any(
                              (item) => item.id == news.id,
                            );
                            return _buildActionButton(
                              context,
                              icon: isSaved
                                  ? Assets.icons.wishlistStarFill.path
                                  : Assets.icons.wishlistStar.path,
                              label: 'حفظ',
                              color: AppColor.primaryOrange,
                              onTap: () {
                                final newsbookmark = BookmarkItem.fromNews(
                                  news,
                                );
                                context.read<BookmarkCubit>().toggleBookmark(
                                  newsbookmark,
                                );
                                AppSnackBar.success(
                                  context,
                                  isSaved
                                      ? 'تمَّ حذف الخبر من المحفوظات'
                                      : 'تمَّ حفظ الخبر',
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required String icon,
    required String label,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.theme.brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            color: context.theme.brightness == Brightness.dark
                ? Colors.grey.shade400
                : Colors.grey.shade600,
            width: 10,
            height: 10,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: context.theme.brightness == Brightness.dark
                  ? Colors.grey.shade300
                  : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Image.asset(icon, color: color, width: 20, height: 20),

            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColor.primaryBlue.withOpacity(0.1),
      child: Center(
        child: Assets.icons.newspaper.image(
          width: 60,
          height: 60,
          color: AppColor.primaryBlue.withOpacity(0.5),
        ),
      ),
    );
  }
}
