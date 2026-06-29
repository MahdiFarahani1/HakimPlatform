// lib/features/news/presentation/screens/news_detail_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/core/widgets/error_widget.dart';
import 'package:flutter_application_1/features/bookmark/logic/cubit/book_mark_cubit.dart';
import 'package:flutter_application_1/features/bookmark/logic/cubit/book_mark_state.dart';
import 'package:flutter_application_1/features/news/data/models/news_detail.dart';
import 'package:flutter_application_1/features/news/data/models/news_model.dart';
import 'package:flutter_application_1/features/news/logic/detail-news/detail_news_cubit.dart';
import 'package:flutter_application_1/features/news/widgets/loading_news.dart';
import 'package:flutter_application_1/features/settings/logic/cubit/settings_cubit.dart';
import 'package:flutter_application_1/features/settings/presentation/setting_view.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constans/app_color.dart';
import '../../../config/di.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel newsModel;

  const NewsDetailScreen({super.key, required this.newsModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NewsDetailCubit(getIt())..fetchNewsDetail(postId: newsModel.id),
      child: Scaffold(
        backgroundColor: const Color(0xffF6F8FC),
        body: BlocBuilder<NewsDetailCubit, NewsDetailState>(
          builder: (context, state) {
            if (state is NewsDetailLoading) {
              return const SkeletonLoadingWidget();
            } else if (state is NewsDetailSuccess) {
              return NewsDetailsContent(
                news: state.newsDetail,
                newsModel: newsModel,
              );
            } else if (state is NewsDetailError) {
              return CustomErrorWidget(
                onRetry: () {
                  context.read<NewsDetailCubit>().fetchNewsDetail(
                    postId: newsModel.id,
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class NewsDetailsContent extends StatelessWidget {
  final NewsDetailModel news;
  final NewsModel newsModel;
  const NewsDetailsContent({
    super.key,
    required this.news,
    required this.newsModel,
  });

  @override
  Widget build(BuildContext context) {
    final hasMoreImages = news.hasMoreImages;
    final hasImgTitle = news.imgTitle.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),
      body: Stack(
        children: [
          /// MAIN SCROLL
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              /// MODERN HEADER
              SliverAppBar(
                stretch: true,
                expandedHeight: 520.h,
                elevation: 0,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                collapsedHeight: 90.h,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    return FlexibleSpaceBar(
                      stretchModes: const [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                      ],

                      centerTitle: false,
                      titlePadding: const EdgeInsets.symmetric(horizontal: 16),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Hero(
                            tag: "news_${news.id}",
                            child: Image.network(
                              news.fullImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: AppColor.primaryBlue.withOpacity(0.1),
                                child: Assets.icons.imageSlash.image(
                                  width: 80.w,
                                  height: 80.h,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),

                          /// ADVANCED GRADIENT OVERLAY
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.2),
                                  Colors.black.withOpacity(0.7),
                                  Colors.black.withOpacity(0.9),
                                ],
                                stops: const [0.0, 0.2, 0.5, 1.0],
                              ),
                            ),
                          ),

                          /// IMAGE TITLE (بالای عکس، وسط)
                          if (hasImgTitle)
                            Positioned(
                              top: 100,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    news.imgTitle,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),

                          /// BLUR EFFECT ON BOTTOM
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 20,
                                  sigmaY: 20,
                                ),
                                child: Container(
                                  height: 120,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),

                          /// TITLE SECTION (پایین عکس)
                          Positioned(
                            left: 24,
                            right: 24,
                            bottom: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// ANIMATED TAGS
                                Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: [
                                        _ModernTag(
                                          news.category,
                                          Assets.icons.newspaper.path,
                                        ),
                                        _ModernTag(
                                          news.date,
                                          Assets.icons.calendar.path,
                                        ),
                                        _ModernTag(
                                          "${_getReadTime(news.content)} دقيقة",
                                          Assets.icons.clockThree.path,
                                        ),
                                      ],
                                    )
                                    .animate()
                                    .fadeIn(duration: 500.ms)
                                    .slideY(begin: 0.2),

                                const SizedBox(height: 16),

                                /// TITLE WITH GRADIENT
                                ShaderMask(
                                      shaderCallback: (bounds) =>
                                          const LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.white70,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ).createShader(bounds),
                                      child:
                                          BlocBuilder<
                                            SettingsCubit,
                                            SettingsState
                                          >(
                                            builder: (context, state) {
                                              return Text(
                                                news.title,
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                    255,
                                                    255,
                                                    255,
                                                    255,
                                                  ),
                                                  fontFamily:
                                                      state.selectedFont,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w800,
                                                  height: 1.3,
                                                  letterSpacing: -0.3,
                                                ),
                                              );
                                            },
                                          ),
                                    )
                                    .animate()
                                    .fadeIn(duration: 600.ms)
                                    .slideY(begin: 0.3),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// BODY
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -25),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 30,
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (news.summary.isNotEmpty) ...[
                          SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColor.primaryOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xff4F8CFF).withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.format_quote_rounded,
                                  size: 20,
                                  color: AppColor.primaryOrange,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child:
                                      BlocBuilder<SettingsCubit, SettingsState>(
                                        builder: (context, state) {
                                          return Text(
                                            news.summary,
                                            style: TextStyle(
                                              fontFamily: state.selectedFont,
                                              fontSize: state.fontSize,
                                              fontWeight: FontWeight.w500,
                                              height: 1.5,
                                              color: Color(0xff444444),
                                            ),
                                          );
                                        },
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        /// CONTENT WITH HTML
                        BlocBuilder<SettingsCubit, SettingsState>(
                          builder: (context, state) {
                            return Html(
                              data: news.content,

                              style: {
                                "p": Style(
                                  fontSize: FontSize(state.fontSize),
                                  fontFamily: state.selectedFont,
                                  textAlign: TextAlign.justify,
                                  lineHeight: LineHeight(1.8),
                                  color: const Color(0xff444444),
                                  margin: Margins.only(bottom: 16),
                                ),
                                "strong": Style(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                "h1": Style(
                                  fontSize: FontSize(24),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  margin: Margins.only(top: 16, bottom: 12),
                                ),
                                "h2": Style(
                                  fontSize: FontSize(20),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  margin: Margins.only(top: 16, bottom: 12),
                                ),
                                "br": Style(margin: Margins.only(bottom: 8)),
                              },
                            );
                          },
                        ).animate().fadeIn(duration: 600.ms),

                        const SizedBox(height: 24),

                        /// MORE IMAGES GALLERY
                        if (hasMoreImages) ...[
                          const Divider(height: 32, color: Color(0xffE0E0E0)),
                          const Text(
                            "صور إضافية",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 120,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: news.moreImages.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final imageUrl = news.moreImages[index];
                                return GestureDetector(
                                      onTap: () => _showFullImage(
                                        context,
                                        news.getFullImageUrl(imageUrl),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          news.getFullImageUrl(imageUrl),
                                          width: 140,
                                          height: 120,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                                width: 140,
                                                height: 120,
                                                color: Colors.grey.shade200,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    12.0,
                                                  ),
                                                  child: Assets.icons.imageSlash
                                                      .image(
                                                        width: 48.w,
                                                        height: 48.h,
                                                        color: Colors
                                                            .grey
                                                            .shade400,
                                                      ),
                                                ),
                                              ),
                                        ),
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(delay: (700 + index * 100).ms)
                                    .scale(
                                      begin: const Offset(0.9, 0.9),
                                      end: const Offset(1, 1),
                                    );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// BOTTOM ACTION BAR (دکمه‌های خانه، بوکمارک، شیر، برگشت به لیست)
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SafeArea(
              child: _modernBottomBar(
                newsId: news.id,
                onHomeTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
                onBookmarkTap: () {
                  context.read<BookmarkCubit>().toggleBookmark(newsModel);
                },
                onShareTap: () {
                  // TODO: Share news
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('مشاركة الخبر')));
                },
                onBackToListTap: () {
                  Navigator.pop(context);
                },
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 1),
          ),
        ],
      ),
    );
  }

  int _getReadTime(String content) {
    final plainText = content.replaceAll(RegExp(r'<[^>]*>'), '');
    final wordCount = plainText.split(' ').length;
    return (wordCount / 200).ceil().clamp(1, 10);
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: _modernGlassButton(
                icon: Icons.close,
                onTap: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= BOTTOM NAVIGATION BAR =================

Widget _modernBottomBar({
  required VoidCallback onHomeTap,
  required VoidCallback onBookmarkTap,
  required VoidCallback onShareTap,
  required VoidCallback onBackToListTap,
  required int newsId,
}) {
  return Container(
    height: 70,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.95),
      borderRadius: BorderRadius.circular(35),
      boxShadow: [
        BoxShadow(
          blurRadius: 25,
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // خانه
        _bottomActionItem(
          icon: Assets.icons.settings.path,
          label: "الإعدادات",
          color: AppColor.primaryOrange,
          onTap: onHomeTap,
        ),
        // بوکمارک
        BlocBuilder<BookmarkCubit, BookmarkState>(
          builder: (context, state) {
            final isSaved = state.savedNews.any((item) => item.id == newsId);
            return _bottomActionItem(
              icon: isSaved
                  ? Assets.icons.wishlistStarFill.path
                  : Assets.icons.wishlistStar.path,
              label: "حفظ",
              color: AppColor.primaryOrange,
              onTap: onBookmarkTap,
            );
          },
        ),
        // شیر
        _bottomActionItem(
          icon: Assets.icons.shareSquare.path,
          label: "مشاركة",
          color: AppColor.primaryOrange,
          onTap: onShareTap,
        ),
        // برگشت به لیست اخبار
        _bottomActionItem(
          icon: Assets.icons.angleSmallLeft.path,
          label: "رجوع",
          color: AppColor.primaryBlue,
          onTap: onBackToListTap,
        ),
      ],
    ),
  );
}

Widget _bottomActionItem({
  required String icon,
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(icon, width: 24, height: 24, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

// ================= MODERN GLASS BUTTON =================

Widget _modernGlassButton({required IconData icon, VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    ),
  );
}

// ================= MODERN TAG =================

class _ModernTag extends StatelessWidget {
  final String text;
  final String icon;

  const _ModernTag(this.text, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(icon, color: Colors.white, width: 14, height: 14),

          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
