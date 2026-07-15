import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/config/di.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/logic/search/search_cubit.dart';
import 'package:flutter_application_1/core/widgets/custom_refresh_widget.dart';
import 'package:flutter_application_1/core/widgets/custom_text_field.dart';
import 'package:flutter_application_1/core/widgets/empty_widget.dart';
import 'package:flutter_application_1/core/widgets/error_widget.dart';
import 'package:flutter_application_1/core/widgets/snackbar_common.dart';
import 'package:flutter_application_1/features/bookmark/data/models/bookmark_model.dart';
import 'package:flutter_application_1/features/bookmark/logic/cubit/book_mark_cubit.dart';
import 'package:flutter_application_1/features/bookmark/logic/cubit/book_mark_state.dart';
import 'package:flutter_application_1/features/videos/data/models/video_model.dart';
import 'package:flutter_application_1/features/videos/logic/cubit/videos_cubit.dart';
import 'package:flutter_application_1/features/videos/widgets/loading_videos.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/features/history/data/models/history_item.dart';
import 'package:flutter_application_1/features/history/logic/cubit/history_cubit.dart';

class VideoGalleryScreen extends StatefulWidget {
  const VideoGalleryScreen({super.key});

  @override
  State<VideoGalleryScreen> createState() => _VideoGalleryScreenState();
}

class _VideoGalleryScreenState extends State<VideoGalleryScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController textEditingController = TextEditingController();

  Future<void> openYouTube(String youtubeId, BuildContext context) async {
    final url = 'https://www.youtube.com/watch?v=$youtubeId';

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        AppSnackBar.show(
          context: context,
          message: 'تعذر فتح الفيديو. الرجاء المحاولة مرة أخرى.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SearchCubit<VideoModel>()),
        BlocProvider(create: (context) => getIt<VideosCubit>()..fetchVideos()),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: context.appTheme.scaffoldGradient,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColor.primaryBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Assets.icons.video.image(
                              width: 28.w,
                              height: 28.h,
                              color: AppColor.primaryOrange,
                            ),
                          ),
                          const SizedBox(width: 14),
                          BlocBuilder<
                            SearchCubit<VideoModel>,
                            SearchState<VideoModel>
                          >(
                            builder: (context, searchState) {
                              return BlocBuilder<VideosCubit, VideosState>(
                                builder: (context, state) {
                                  int videoCount = 0;
                                  if (state is VideosSuccess) {
                                    videoCount =
                                        textEditingController.text.isEmpty
                                        ? state.allVideos.length
                                        : searchState.results.length;
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'مكتبة الفيديو',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : const Color(0xFF1E293B),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '$videoCount فيديو',
                                        style: TextStyle(
                                          color: AppColor.primaryBlue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      BlocListener<VideosCubit, VideosState>(
                        listener: (context, state) {
                          if (state is VideosSuccess) {
                            context.read<SearchCubit<VideoModel>>().clear(
                              state.allVideos,
                            );
                          }
                        },
                        child: BlocBuilder<VideosCubit, VideosState>(
                          builder: (context, state) {
                            if (state is VideosSuccess) {
                              final data = state.allVideos;
                              return CustomSearchBar(
                                controller: textEditingController,
                                onChanged: (query) {
                                  context
                                      .read<SearchCubit<VideoModel>>()
                                      .search(
                                        query: query,
                                        source: data,
                                        title: (video) => video.title,
                                      );
                                },
                                onClear: () {
                                  context.read<SearchCubit<VideoModel>>().clear(
                                    data,
                                  );
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: BlocBuilder<VideosCubit, VideosState>(
                    builder: (context, state) {
                      if (state is VideosLoading) {
                        return SkeletonLoaderVideos();
                      } else if (state is VideosError) {
                        return CustomErrorWidget(
                          message: state.message,
                          onRetry: () =>
                              context.read<VideosCubit>().fetchVideos(),
                        );
                      } else if (state is VideosSuccess) {
                        return BlocBuilder<
                          SearchCubit<VideoModel>,
                          SearchState<VideoModel>
                        >(
                          builder: (context, searchState) {
                            final displayVideos =
                                textEditingController.text.isEmpty
                                ? state.allVideos
                                : searchState.results;

                            if (displayVideos.isEmpty) {
                              return EmptySearchWidget(
                                controller: textEditingController,
                              );
                            }
                            return SimpleRefreshIndicator(
                              onRefresh: () =>
                                  context.read<VideosCubit>().fetchVideos(),
                              child: AnimationLimiter(
                                child: GridView.builder(
                                  padding: const EdgeInsets.all(16),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 14,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: 0.7,
                                      ),
                                  itemCount: displayVideos.length,
                                  itemBuilder: (context, index) {
                                    final video = displayVideos[index];
                                    return AnimationConfiguration.staggeredGrid(
                                      position: index,
                                      duration: const Duration(
                                        milliseconds: 350,
                                      ),
                                      columnCount: 2,
                                      child: ScaleAnimation(
                                        child: FadeInAnimation(
                                          child: VideoCard(
                                            video: video,
                                            onTap: () {
                                              context.read<HistoryCubit>().addItem(
                                                HistoryItem.fromVideo(video),
                                              );
                                              openYouTube(
                                                video.youtubeId,
                                                context,
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
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class VideoCard extends StatelessWidget {
  final VideoModel video;
  final VoidCallback onTap;

  const VideoCard({super.key, required this.video, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: context.theme.brightness == Brightness.dark
                  ? Colors.transparent
                  : Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 140,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    video.image.isNotEmpty
                        ? Image.network(
                            video.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) => Container(
                              color: context.theme.brightness == Brightness.dark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade200,
                            ),
                          )
                        : Container(
                            color: context.theme.brightness == Brightness.dark
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                            child: const Icon(
                              Icons.video_library,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColor.primaryBlue,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Assets.icons.play.image(
                          width: 20,
                          height: 20,
                          color: AppColor.primaryOrange,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Assets.icons.eye1.image(
                              width: 8,
                              height: 8,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              video.duration,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _SaveButton(video: video),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.theme.brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF1E293B),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Assets.icons.calendar.image(
                              width: 9,
                              height: 9,
                              color: AppColor.primaryBlue,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              video.date,
                              style: const TextStyle(
                                fontSize: 8,
                                color: AppColor.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.theme.brightness == Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          video.category,
                          style: TextStyle(
                            fontSize: 8,
                            color: context.theme.brightness == Brightness.dark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends StatefulWidget {
  final VideoModel video;

  const _SaveButton({required this.video});

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.82,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap(BuildContext context, bool isSaved) async {
    HapticFeedback.lightImpact();
    await _controller.forward();
    await _controller.reverse();

    if (!context.mounted) return;
    context.read<BookmarkCubit>().toggleBookmark(
      BookmarkItem.fromVideo(widget.video),
    );

    if (!context.mounted) return;
    AppSnackBar.success(
      context,
      isSaved ? 'تمت إزالته من المحفوظات' : 'تمت الإضافة إلى المحفوظات ✓',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkCubit, BookmarkState>(
      builder: (context, state) {
        final isSaved = state.savedItems.any(
          (item) => item.id == widget.video.id && item.category == 'video',
        );

        return GestureDetector(
          onTap: () => _handleTap(context, isSaved),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) =>
                Transform.scale(scale: _scaleAnimation.value, child: child),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isSaved
                    ? AppColor.primaryOrange.withOpacity(0.92)
                    : Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSaved
                      ? AppColor.primaryOrange
                      : Colors.white.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSaved
                        ? AppColor.primaryOrange.withOpacity(0.35)
                        : Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: Icon(
                      isSaved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      key: ValueKey(isSaved),
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      isSaved ? 'محفوظ' : 'حفظ',
                      key: ValueKey(isSaved),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
