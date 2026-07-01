import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/features/bookmark/logic/cubit/book_mark_state.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_application_1/features/bookmark/logic/cubit/book_mark_cubit.dart';
import 'package:flutter_application_1/features/news/data/models/news_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Get filtered bookmarks from cubit state
  List<NewsModel> _getFilteredBookmarks(List<NewsModel> savedNews) {
    return savedNews.where((news) {
      // Category filter - using news type or category field
      final matchesCategory =
          _selectedCategory == 'all' || 'news' == _selectedCategory;

      // Search filter
      final matchesSearch =
          _searchQuery.isEmpty ||
          news.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (news.intro?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Get category icon and color
  (Color color, String icon, String text) _getCategoryInfo(NewsModel news) {
    final category = 'news';
    switch (category) {
      case 'audio':
        return (
          const Color.fromARGB(255, 132, 0, 255),
          Assets.icons.headphonesRhythm.path,
          'پادکست',
        );
      case 'book':
        return (
          const Color.fromARGB(255, 89, 197, 161),

          Assets.icons.bookOpenCover.path,
          'كتاب',
        );
      default:
        return (
          Color.fromARGB(255, 0, 98, 255),
          Assets.icons.newspaper.path,
          'الأخبار',
        );
    }
  }

  // Get category counts
  int _getCategoryCount(List<NewsModel> savedNews, String category) {
    if (category == 'all') return savedNews.length;
    return savedNews.where((news) => 'news' == category).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: context.appTheme.scaffoldGradient),
        child: SafeArea(
          child: BlocBuilder<BookmarkCubit, BookmarkState>(
            builder: (context, state) {
              final savedNews = state.savedNews;
              final filteredNews = _getFilteredBookmarks(savedNews);

              return CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColor.primaryBlue,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF667EEA,
                                      ).withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Assets.icons.bookmarkFill.image(
                                  color: AppColor.primaryOrange,
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'علاماتي المرجعية',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      context.theme.brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : const Color(0xFF1A1F36),
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "إدارة ذكية للكتب والبودكاست والمقالات",
                            style: TextStyle(
                              fontSize: 14,
                              color: context.theme.brightness == Brightness.dark
                                  ? Colors.grey.shade400
                                  : const Color(0xFF6B7280),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Stats Cards
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _buildCategoryStatCard(
                            'الكل',
                            _getCategoryCount(savedNews, 'all'),
                            Assets.icons.bookmark.path,
                            const Color.fromARGB(255, 255, 0, 0),
                          ),
                          const SizedBox(width: 12),
                          _buildCategoryStatCard(
                            'الأصوات',
                            _getCategoryCount(savedNews, 'audio'),
                            Assets.icons.headphonesRhythm.path,
                            const Color.fromARGB(255, 132, 0, 255),
                          ),
                          const SizedBox(width: 12),
                          _buildCategoryStatCard(
                            'الكتب',
                            _getCategoryCount(savedNews, 'book'),
                            Assets.icons.bookOpenCover.path,
                            const Color.fromARGB(255, 89, 197, 161),
                          ),
                          const SizedBox(width: 12),
                          _buildCategoryStatCard(
                            'الأخبار',
                            _getCategoryCount(savedNews, 'news'),
                            Assets.icons.newspaper.path,
                            const Color.fromARGB(255, 0, 98, 255),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Category Chips
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "التصنيفات",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: context.theme.brightness == Brightness.dark
                                  ? Colors.white
                                  : const Color(0xFF1A1F36),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildCategoryChip(
                                  'الكل',
                                  'all',
                                  Assets.icons.bookmark.path,
                                ),
                                const SizedBox(width: 12),
                                _buildCategoryChip(
                                  'الأصوات',
                                  'audio',
                                  Assets.icons.headphonesRhythm.path,
                                ),
                                const SizedBox(width: 12),
                                _buildCategoryChip(
                                  'الكتب',
                                  'book',
                                  Assets.icons.bookOpenCover.path,
                                ),
                                const SizedBox(width: 12),
                                _buildCategoryChip(
                                  'الأخبار',
                                  'news',
                                  Assets.icons.newspaper.path,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Search Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.onPrimaryContainer,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: context.theme.brightness == Brightness.dark
                                  ? Colors.transparent
                                  : Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                            color: context.theme.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'جستجو در بوکمارک‌ها...',
                            hintStyle: const TextStyle(
                              color: Color(0xFF9CA3AF),
                            ),
                            prefixIcon: Container(
                              margin: EdgeInsets.all(14),
                              child: Assets.icons.search.image(
                                color: Color(0xFF9CA3AF),
                                width: 2,
                                height: 2,
                              ),
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bookmarks List
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                    sliver: filteredNews.isEmpty
                        ? SliverToBoxAdapter(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(28),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.primaryOrange.withOpacity(
                                        0.1,
                                      ),

                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.6),
                                        width: 2,
                                      ),
                                    ),
                                    child: Assets.icons.bookmarkSlash.image(
                                      width: 70,
                                      height: 70,
                                      color: AppColor.primaryOrange,
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  Text(
                                    "لم يتم حفظ أي عنصر",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // متن فرعی
                                  Text(
                                    "يمكنك الحفظ من القسم المرتبط",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),

                                  const SizedBox(height: 24),
                                ],
                              ),
                            ).animate().scale(),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final news = filteredNews[index];
                              return _buildBookmarkCard(news);
                            }, childCount: filteredNews.length),
                          ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: context.screenHeight * 0.15),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryStatCard(
    String title,
    int count,
    String icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: context.theme.brightness == Brightness.dark
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
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(icon, width: 16, height: 16, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: context.theme.brightness == Brightness.dark
                    ? Colors.grey.shade400
                    : const Color(0xFF6B7280),
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

  Widget _buildCategoryChip(String label, String category, String icon) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryBlue
              : context.theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (context.theme.brightness == Brightness.dark
                      ? Colors.white10
                      : const Color(0xFFE5E7EB)),
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
                    : (context.theme.brightness == Brightness.dark
                          ? Colors.grey.shade300
                          : const Color(0xFF374151)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkCard(NewsModel news) {
    final (categoryColor, categoryIcon, categoryText) = _getCategoryInfo(news);
    final imageEmoji = _getImageEmoji(news);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: context.theme.brightness == Brightness.dark
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
            onTap: () {},
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Image or Emoji
                  Container(
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: news.image.isNotEmpty
                          ? Image.network(
                              news.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    imageEmoji,
                                    style: const TextStyle(fontSize: 36),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                imageEmoji,
                                style: const TextStyle(fontSize: 36),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: categoryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    categoryIcon,
                                    width: 12,
                                    height: 12,
                                    color: categoryColor,
                                  ),

                                  const SizedBox(width: 4),
                                  Text(
                                    categoryText,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: categoryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            // Language badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: news.languageColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                news.languageName,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: news.languageColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          news.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.theme.brightness == Brightness.dark
                                ? Colors.white
                                : const Color(0xFF1A1F36),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          news.intro ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: context.theme.brightness == Brightness.dark
                                ? Colors.grey.shade400
                                : const Color(0xFF9CA3AF),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Assets.icons.clockThree.image(
                              width: 10,
                              height: 10,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getTimeAgo(news.createdAt),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Assets.icons.calendar.image(
                              width: 10,
                              height: 10,
                              color: Color(0xFF9CA3AF),
                            ),

                            const SizedBox(width: 4),
                            Text(
                              _formatDate(news.createdAt),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF9CA3AF),
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
                    color: Color(0xFF9CA3AF),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getImageEmoji(NewsModel news) {
    final category = 'news';
    switch (category) {
      case 'audio':
        return '🎧';
      case 'book':
        return '📚';
      default:
        return '📰';
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays == 0) return 'اليوم';
      if (diff.inDays == 1) return 'الأمس';
      if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
      return 'منذ ${(diff.inDays / 7).floor()} أسابيع';
    } catch (e) {
      return dateString;
    }
  }

  String _getTimeAgo(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) return 'قبل لحظات';
      if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
      if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';

      return _formatDate(dateString);
    } catch (e) {
      return dateString;
    }
  }
}
