import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/core/utils/url_luncher.dart';
import 'package:flutter_application_1/core/widgets/custom_cache_image.dart';
import 'package:flutter_application_1/features/bookmark/data/bookmark_helpers.dart';
import 'package:flutter_application_1/features/bookmark/data/models/bookmark_model.dart';
import 'package:flutter_application_1/features/books/data/models/book_model.dart';
import 'package:flutter_application_1/features/history/data/models/history_item.dart';
import 'package:flutter_application_1/features/history/logic/cubit/history_cubit.dart';
import 'package:flutter_application_1/features/news/presentation/detail_news_view.dart';
import 'package:flutter_application_1/features/videos/data/models/video_model.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarkCard extends StatelessWidget {
  final BookmarkItem item;

  const BookmarkCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final categoryInfo = BookmarkHelpers.getCategoryInfo(item);
    final imageEmoji = BookmarkHelpers.getImageEmoji(item);
    final String languageLabel = item.extraData['lan'] ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.transparent
                  : Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onItemTap(context),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildThumbnail(categoryInfo.color, imageEmoji),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildContent(
                      context,
                      isDark: isDark,
                      categoryInfo: categoryInfo,
                      languageLabel: languageLabel,
                    ),
                  ),
                  Assets.icons.angleSmallLeft.image(
                    width: 16,
                    height: 16,
                    color: const Color(0xFF9CA3AF),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTap(BuildContext context) {
    switch (item.category) {
      case 'video':
        final video = VideoModel(
          id: item.id,
          title: item.title,
          description: '',
          image: item.image,
          youtubeId: item.extraData['youtubeId'] ?? '',
          category: item.category,
          date: item.createdAt,
          views: '',
          duration: '',
        );
        context.read<HistoryCubit>().addItem(HistoryItem.fromVideo(video));
        LaunchUrlService.videoOpener(
          context,
          item.extraData['youtubeId'] ?? '',
        );
      case 'book':
        final book = BookModel(
          id: item.id,
          title: item.title,
          image: item.image,
          pdf: item.extraData['pdfUrl'] ?? '',
          category: item.category,
          date: item.createdAt,
          code: '',
          number: '',
        );
        context.read<HistoryCubit>().addItem(HistoryItem.fromBook(book));
        LaunchUrlService.urlOpener(
          context,
          "${Api.baseImageUrl}${item.extraData['pdfUrl'] ?? ''}",
        );
      case 'news':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(newsId: item.id),
          ),
        );
    }
  }

  Widget _buildThumbnail(Color categoryColor, String imageEmoji) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            categoryColor.withOpacity(0.15),
            categoryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: item.image.isNotEmpty
            ? CustomCacheImage(imageUrl: "${Api.baseImageUrl}${item.image}")
            : Center(
                child: Text(imageEmoji, style: const TextStyle(fontSize: 32)),
              ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required bool isDark,
    required ({Color color, String icon, String text}) categoryInfo,
    required String languageLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildCategoryBadge(categoryInfo),
            const Spacer(),
            if (languageLabel.isNotEmpty)
              _buildLanguageBadge(languageLabel, categoryInfo.color),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          item.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1A1F36),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          item.intro ?? '',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey.shade400 : const Color(0xFF9CA3AF),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Assets.icons.calendar.image(
              width: 10,
              height: 10,
              color: const Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 4),
            Text(
              item.createdAt.toRelativeTime(),
              style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryBadge(
    ({Color color, String icon, String text}) categoryInfo,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: categoryInfo.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            categoryInfo.icon,
            width: 12,
            height: 12,
            color: categoryInfo.color,
          ),
          const SizedBox(width: 4),
          Text(
            categoryInfo.text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: categoryInfo.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
