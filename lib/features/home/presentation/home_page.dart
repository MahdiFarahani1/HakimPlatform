import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/widgets/error_widget.dart';
import 'package:flutter_application_1/core/widgets/snackbar_common.dart';
import 'package:flutter_application_1/features/articles/presentation/articles_veiw.dart';
import 'package:flutter_application_1/features/books/presentation/all_books_view.dart';
import 'package:flutter_application_1/features/dialogue/presentation/dialouge_view.dart';

import 'package:flutter_application_1/features/home/logic/bloc/bloc/home_bloc.dart';
import 'package:flutter_application_1/features/home/widgets/news_section.dart';
import 'package:flutter_application_1/features/home/widgets/comment_section.dart';
import 'package:flutter_application_1/features/home/widgets/drop_down_btn.dart';
import 'package:flutter_application_1/features/home/widgets/home_loading.dart';
import 'package:flutter_application_1/features/home/widgets/video_section.dart';
import 'package:flutter_application_1/features/search/presentation/search_view.dart';
import 'package:flutter_application_1/features/sounds/presentation/music_list_view.dart';
import 'package:flutter_application_1/features/sounds/widgets/home_random_player_box.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/features/books/data/models/book_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController searchController = TextEditingController();

  ValueNotifier<int> selectedIndex = ValueNotifier(0);

  List<BookModel> get _dummyBooks => List.generate(
    4,
    (index) => BookModel(
      id: index,
      title: 'عنوان کتاب تست شیک و مدرن',
      image: '',
      number: 'جلد ۱',
      category: 'تست',
      pdf: '',
      date: '1300/4/2',
      code: '',
    ),
  );

  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(FetchHomeData());
    super.initState();
  }

  @override
  void dispose() {
    selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: context.appTheme.scaffoldGradient,
          ),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeError) {
                return CustomErrorWidget(
                  onRetry: () {
                    BlocProvider.of<HomeBloc>(context).add(FetchHomeData());
                  },
                );
              }
              if (state is HomeLoading) {
                return HomeLoadingWidget();
              }
              if (state is HomeLoaded) {
                final isBooksLoading = state.isBooksLoading;
                final data = state.data;
                final books = data.books;
                final sliders = data.sliders;
                final news = data.news;
                final videos = data.videos;
                final dialogues = data.dialogues;
                final categoryBook = data.bookCategories;

                return ListView(
                  padding: EdgeInsets.all(20.w),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              color:
                                  context.theme.colorScheme.onPrimaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0.w),
                              child: Form(
                                child: TextField(
                                  controller: searchController,
                                  style: TextStyle(
                                    color:
                                        context.theme.brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onSubmitted: (value) {
                                    if (value.isEmpty) {
                                      AppSnackBar.error(
                                        context,

                                        "البحث لا يمكن أن يكون فارغ",
                                      );
                                      return;
                                    }
                                    if (value.length < 3) {
                                      AppSnackBar.error(
                                        context,
                                        "البحث يجب أن يكون أطول من 3 أحرف",
                                      );
                                      return;
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SearchPage(),
                                      ),
                                    );
                                  },
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: GestureDetector(
                                      onTap: () {
                                        if (searchController.text.isEmpty) {
                                          AppSnackBar.error(
                                            context,
                                            "البحث لا يمكن أن يكون فارغ",
                                          );
                                          return;
                                        }
                                        if (searchController.text.length < 3) {
                                          AppSnackBar.error(
                                            context,
                                            "البحث يجب أن يكون أطول من 3 أحرف",
                                          );
                                          return;
                                        }

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SearchPage(),
                                          ),
                                        );
                                      },
                                      child: Assets.icons.search.image(
                                        color: AppColor.primaryBlue,
                                      ),
                                    ),
                                    hintStyle: TextStyle(
                                      color:
                                          context.theme.brightness ==
                                              Brightness.dark
                                          ? Colors.grey.shade400
                                          : Colors.grey,
                                      fontSize: 12.sp,
                                    ),
                                    hintText: "ابحث هنا...",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        const SimpleDropdown(),
                      ],
                    ),

                    SizedBox(height: 25.h),

                    CarouselSlider.builder(
                      itemCount: sliders.length,
                      options: CarouselOptions(
                        height: 170,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                      ),
                      itemBuilder: (context, index, realIndex) {
                        final slider = sliders[index];

                        return _bannerCard(
                          title: slider.title,
                          subtitle: slider.subtitle,
                          img: slider.img,
                        );
                      },
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      height: 90.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryItem(
                            onTab: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BooksPage(),
                                ),
                              );
                            },
                            icon: Assets.icons.bookOpenCover.path,
                            title: "الكتب",
                          ),
                          CategoryItem(
                            onTab: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MusicListScreen(),
                                ),
                              );
                            },
                            icon: Assets.icons.waveformPath.path,
                            title: "الصوتيات",
                          ),
                          CategoryItem(
                            onTab: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DialogueScreen(),
                                ),
                              );
                            },
                            icon: Assets.icons.browser.path,
                            title: "المقالات",
                          ),
                          CategoryItem(
                            onTab: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ArticlesPage(),
                                ),
                              );
                            },
                            icon: Assets.icons.settings.path,
                            title: "الإعدادات",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.h),

                    SizedBox(
                      height: 40.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryBook.length,
                        itemBuilder: (_, i) {
                          return ValueListenableBuilder<int>(
                            valueListenable: selectedIndex,
                            builder: (context, value, child) {
                              final isSelected = i == value;

                              return GestureDetector(
                                onTap: () {
                                  selectedIndex.value = i;

                                  BlocProvider.of<HomeBloc>(context).add(
                                    FetchBooksByCategory(
                                      titleSelected: categoryBook[i].title,
                                    ),
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColor.primaryBlue
                                        : context
                                              .theme
                                              .colorScheme
                                              .onPrimaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 500),
                                    style: TextStyle(
                                      fontSize: isSelected ? 14 : 12,
                                      color: isSelected
                                          ? AppColor.primaryOrange
                                          : (context.theme.brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.black),
                                    ),
                                    child: Text(categoryBook[i].title),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (books.isEmpty && !isBooksLoading) ...[
                      SizedBox(
                        width: context.screenWidth,
                        height: context.screenHeight * 0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.grey.shade50,
                                    Colors.grey.shade100,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.8),
                                    blurRadius: 10,
                                    offset: const Offset(-4, -4),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.6),
                                  width: 2,
                                ),
                              ),
                              child: Assets.icons.bookOpenCover.image(
                                width: 70,
                                height: 70,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 24),

                            Text(
                              "لا توجد أي كتب في هذا التصنيف",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                                letterSpacing: 0.5,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'ستتم إضافة كتب جديدة قريباً',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ).animate().scale(),
                      ),
                    ] else
                      Skeletonizer(
                        enabled: isBooksLoading,
                        child: SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: isBooksLoading ? 4 : books.length,
                            physics: isBooksLoading
                                ? const NeverScrollableScrollPhysics()
                                : const BouncingScrollPhysics(),
                            itemBuilder: (_, i) {
                              final book = isBooksLoading
                                  ? _dummyBooks[i]
                                  : books[i];
                              return GestureDetector(
                                onTap: isBooksLoading
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const BooksPage(),
                                          ),
                                        );
                                      },

                                child: Hero(
                                  tag: isBooksLoading
                                      ? 'dummy_tag_$i'
                                      : book.title,
                                  child: Container(
                                    width: 150,
                                    margin: const EdgeInsets.only(right: 16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 8,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                      image: book.image.isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(book.image),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.75),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Positioned(
                                          bottom: 12,
                                          left: 12,
                                          right: 12,
                                          child: Text(
                                            book.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                    const SizedBox(height: 35),
                    HomeRandomPlayerBox(),
                    const SizedBox(height: 20),

                    VideoListSection(videos: videos),
                    SizedBox(height: 20),

                    NewsListSection(news: news),
                    SizedBox(height: 20),

                    InterviewsSection(interviews: dialogues),
                    SizedBox(height: 120),
                  ],
                );
              }
              return SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _bannerCard({
    required String title,
    required String subtitle,
    required String img,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.bottomRight,

                child: Text(
                  subtitle,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              SizedBox(height: 43.h),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    "استكشف",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CategoryItem extends StatelessWidget {
  final String icon;
  final String title;
  final Function()? onTab;
  const CategoryItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTab,
            child: Container(
              height: 60.h,
              width: 60.w,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.onPrimaryContainer,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Image.asset(icon, color: AppColor.primaryBlue),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
