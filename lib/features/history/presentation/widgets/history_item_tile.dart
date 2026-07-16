import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/core/utils/url_luncher.dart';
import 'package:flutter_application_1/core/widgets/custom_cache_image.dart';
import 'package:flutter_application_1/features/history/data/models/history_item.dart';
import 'package:flutter_application_1/features/history/data/models/history_type.dart';
import 'package:flutter_application_1/features/news/presentation/detail_news_view.dart';
import 'package:flutter_application_1/features/sounds/data/models/song.dart';
import 'package:flutter_application_1/features/sounds/logic/cubit/player_cubit.dart';
import 'package:flutter_application_1/features/sounds/presentation/music_list_view.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryItemTile extends StatelessWidget {
  final HistoryItem item;

  const HistoryItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final typeColor = AppColor.primaryBlue;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onTap(context),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      typeColor.withValues(alpha: 0.15),
                      typeColor.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: item.image.isNotEmpty
                      ? CustomCacheImage(
                          imageUrl: item.type == HistoryType.audio
                              ? item.image
                              : "${Api.baseImageUrl}${item.image}",
                          fit: BoxFit.cover,
                        )
                      : _buildEmojiPlaceholder(),
                ),
              ),

              const SizedBox(width: 14),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1A1F36),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.type.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: typeColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Relative time
                        Text(
                          item.openedAt.toRelativeTime(),
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? Colors.grey.shade500
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Assets.icons.angleSmallLeft.image(
                width: 16,
                height: 16,
                color: isDark ? Colors.grey.shade600 : const Color(0xFFD1D5DB),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiPlaceholder() {
    return Center(
      child: Text(item.type.emoji, style: const TextStyle(fontSize: 24)),
    );
  }

  void _onTap(BuildContext context) {
    Navigator.pop(context);

    switch (item.type) {
      case HistoryType.news:
        final newsId = item.extraData['newsId'] as int? ?? item.id;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewsDetailScreen(newsId: newsId)),
        );
      case HistoryType.book:
        final pdfUrl = item.extraData['pdfUrl'] as String? ?? '';
        LunchUrlService.urlOpener(context, "${Api.baseImageUrl}$pdfUrl");
      case HistoryType.video:
        final youtubeId = item.extraData['youtubeId'] as String? ?? '';
        LunchUrlService.videoOpener(context, youtubeId);
      case HistoryType.audio:
        final songId = item.extraData['songId'] as String? ?? '';
        final song = sampleSongs.cast<Song?>().firstWhere(
          (s) => s?.id == songId,
          orElse: () => null,
        );
        if (song != null) {
          context.read<PlayerCubit>().playSong(song);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MusicListScreen()),
          );
        }
    }
  }
}
