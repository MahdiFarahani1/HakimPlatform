// lib/features/news/presentation/screens/news_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/di.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/widgets/custom_loading.dart';
import 'package:flutter_application_1/features/news/logic/all-news/news_cubit.dart';
import 'package:flutter_application_1/features/news/presentation/detail_news_view.dart';
import 'package:flutter_application_1/features/news/widgets/news_card.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_application_1/core/utils/extension.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<NewsCubit>().state;
      if (state is NewsSuccess && state.hasMore) {
        context.read<NewsCubit>().fetchNews();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NewsCubit>()..fetchNews(isRefresh: true),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: context.appTheme.scaffoldGradient,
            ),

            child: Column(
              children: [
                _buildHeader(),
                _buildSearchBar(),
                _buildLanguageFilter(),
                Expanded(
                  child: BlocBuilder<NewsCubit, NewsState>(
                    builder: (context, state) {
                      if (state is NewsLoading) {
                        return _buildSkeletonLoader();
                      } else if (state is NewsError) {
                        return _buildErrorWidget(state.message, context);
                      } else if (state is NewsSuccess) {
                        if (state.displayNews.isEmpty) {
                          return _buildEmptyWidget(state);
                        }
                        return NotificationListener<ScrollNotification>(
                          onNotification: (scrollInfo) {
                            if (scrollInfo.metrics.pixels >=
                                scrollInfo.metrics.maxScrollExtent - 200) {
                              if (state.hasMore) {
                                context.read<NewsCubit>().fetchNews();
                              }
                            }
                            return false;
                          },
                          child: AnimationLimiter(
                            child: GridView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 14,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.75,
                                  ),
                              itemCount:
                                  state.displayNews.length +
                                  (state.hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index >= state.displayNews.length) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: CustomLoading(),
                                    ),
                                  );
                                }
                                final news = state.displayNews[index];
                                return AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  duration: const Duration(milliseconds: 400),
                                  columnCount: 2,
                                  child: ScaleAnimation(
                                    child: FadeInAnimation(
                                      child: NewsCard(
                                        news: news,
                                        onTap: () {
                                          // در صفحه لیست اخبار
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => NewsDetailScreen(
                                                newsModel: news,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          int total = 0;
          if (state is NewsSuccess) {
            total = state.total;
          }
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.primaryBlue,
                      AppColor.primaryBlue.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Assets.icons.newspaper.image(
                  width: 28.w,
                  height: 28.h,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الأخبار',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    total > 0 ? '$total خبر' : 'تحميل...',
                    style: TextStyle(
                      color: AppColor.primaryBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          String currentQuery = '';
          if (state is NewsSuccess) {
            currentQuery = state.searchQuery;
          }
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                context.read<NewsCubit>().searchNews(value);
              },
              controller: TextEditingController(text: currentQuery),
              style: const TextStyle(color: Color(0xFF1E293B), fontSize: 14),
              decoration: InputDecoration(
                hintText: 'بحث في الأخبار...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Assets.icons.search.image(
                    width: 18,
                    height: 18,
                    color: Colors.grey.shade400,
                  ),
                ),
                suffixIcon: currentQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Colors.grey.shade400,
                        ),
                        onPressed: () {
                          context.read<NewsCubit>().clearSearch();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageFilter() {
    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        if (state is! NewsSuccess) {
          return const SizedBox.shrink();
        }

        final languages = ['الكل', 'العربية', 'English', 'كوردی'];

        return SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final lang = languages[index];
              final isSelected = _selectedLanguage == lang;
              return Padding(
                padding: const EdgeInsets.only(left: 10),
                child: FilterChip(
                  label: Text(lang),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedLanguage = isSelected ? null : lang;
                    });
                    final langCode = lang == 'العربية'
                        ? 'ar'
                        : lang == 'English'
                        ? 'en'
                        : lang == 'كوردی'
                        ? 'ku'
                        : null;
                    context.read<NewsCubit>().filterByLanguage(langCode);
                  },
                  backgroundColor: Colors.white,
                  selectedColor: AppColor.primaryBlue.withOpacity(0.1),
                  checkmarkColor: AppColor.primaryBlue,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColor.primaryBlue
                        : Colors.grey.shade700,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppColor.primaryBlue
                        : Colors.grey.shade300,
                  ),
                  shape: StadiumBorder(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSkeletonLoader() {
    return Skeletonizer(
      enabled: true,
      effect: const ShimmerEffect(
        duration: Duration(milliseconds: 1500),
        highlightColor: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 14,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 60,
                              color: Colors.grey.shade300,
                            ),
                            const Spacer(),
                            Container(
                              height: 10,
                              width: 50,
                              color: Colors.grey.shade300,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message, BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              context.read<NewsCubit>().fetchNews(isRefresh: true);
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(NewsSuccess state) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.a404.image(
            width: 80.w,
            height: 80.h,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            state.searchQuery.isEmpty
                ? 'لا توجد أخبار'
                : 'لا توجد نتائج لـ "${state.searchQuery}"',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          if (state.searchQuery.isNotEmpty)
            TextButton(
              onPressed: () {
                context.read<NewsCubit>().clearSearch();
              },
              child: const Text('مسح البحث'),
            ),
        ],
      ),
    );
  }
}
