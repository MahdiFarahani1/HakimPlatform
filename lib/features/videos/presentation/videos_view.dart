import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/di.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/widgets/error_widget.dart';
import 'package:flutter_application_1/core/widgets/snackbar_common.dart';
import 'package:flutter_application_1/features/videos/data/models/video_model.dart';
import 'package:flutter_application_1/features/videos/logic/cubit/videos_cubit.dart';
import 'package:flutter_application_1/features/videos/widgets/loading_videos.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/core/utils/extension.dart';

class VideoGalleryScreen extends StatelessWidget {
  const VideoGalleryScreen({super.key});

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
    return BlocProvider(
      create: (context) => getIt<VideosCubit>()..fetchVideos(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: context.appTheme.scaffoldGradient,
            ),

            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
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
                          BlocBuilder<VideosCubit, VideosState>(
                            builder: (context, state) {
                              int videoCount = 0;
                              if (state is VideosSuccess) {
                                videoCount = state.displayVideos.length;
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'مكتبة الفيديو',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Search Bar
                      BlocBuilder<VideosCubit, VideosState>(
                        builder: (context, state) {
                          String currentQuery = '';
                          if (state is VideosSuccess) {
                            currentQuery = state.searchQuery;
                          }
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              onChanged: (value) {
                                context.read<VideosCubit>().searchVideos(value);
                              },
                              controller: TextEditingController(
                                text: currentQuery,
                              ),
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: 'بحث...',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 14,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Assets.icons.search.image(
                                    width: 10,
                                    height: 10,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                suffixIcon: currentQuery.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 18,
                                          color: Colors.grey.shade400,
                                        ),
                                        onPressed: () {
                                          context
                                              .read<VideosCubit>()
                                              .clearSearch();
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
                    ],
                  ),
                ),

                // Body
                Expanded(
                  child: BlocBuilder<VideosCubit, VideosState>(
                    builder: (context, state) {
                      if (state is VideosLoading) {
                        return SkeletonLoaderVideos();
                      } else if (state is VideosError) {
                        return CustomErrorWidget(
                          onRetry: () =>
                              context.read<VideosCubit>().fetchVideos(),
                        );
                      } else if (state is VideosSuccess) {
                        if (state.displayVideos.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Assets.icons.a404.image(
                                  width: 55.w,
                                  height: 55.h,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  state.searchQuery.isEmpty
                                      ? 'لا توجد فيديوهات'
                                      : 'لا توجد نتائج لـ "${state.searchQuery}"',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return AnimationLimiter(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.7,
                                ),
                            itemCount: state.displayVideos.length,
                            itemBuilder: (context, index) {
                              final video = state.displayVideos[index];
                              return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 350),
                                columnCount: 2,
                                child: ScaleAnimation(
                                  child: FadeInAnimation(
                                    child: VideoCard(
                                      video: video,
                                      onTap: () =>
                                          openYouTube(video.youtubeId, context),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
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
}

// Video Card
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Section
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
                    // تصویر
                    video.image.isNotEmpty
                        ? Image.network(
                            video.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) =>
                                Container(color: Colors.grey.shade200),
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.video_library,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                    // آیکون پلی در مرکز
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
                    // تعداد بازدید
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
                  ],
                ),
              ),
            ),
            // Info Section
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
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
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          video.category,
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.grey.shade600,
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
