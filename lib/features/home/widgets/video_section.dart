import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/core/widgets/custom_cache_image.dart';
import 'package:flutter_application_1/features/home/logic/cubit/navigation_cubit.dart';
import 'package:flutter_application_1/features/home/widgets/header.dart';
import 'package:flutter_application_1/features/videos/data/models/video_model.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoListSection extends StatelessWidget {
  final List<VideoModel> videos;
  const VideoListSection({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeHeader(
          title: "أحدث المرئيات",
          onTap: () {
            BlocProvider.of<NavigationCubit>(context).changeNavState(3);
            context.read<NavigationCubit>().pageController.jumpToPage(3);
          },
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 260.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: videos.length,
            separatorBuilder: (_, __) => SizedBox(width: 14.w),
            itemBuilder: (context, index) {
              final video = videos[index];
              return _buildVideoCard(context, video);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCard(BuildContext context, VideoModel video) {
    return GestureDetector(
      onTap: () => _launchYouTube(video.youtubeId),
      child: Container(
        width: 300.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              blurRadius: 16.r,
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomCacheImage(
                  imageUrl: "${Api.baseUrl}${video.image}",
                  fit: BoxFit.cover,
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.85),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.video_library,
                              size: 10.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              _getCategoryText(video.category),
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),

                      Text(
                        video.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 6.h),

                      Row(
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 10.sp,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            video.duration,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Icon(
                            Icons.calendar_today,
                            size: 10.sp,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _formatDate(video.date),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Center(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.25),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Assets.icons.playCircle.image(
                    width: 40.w,
                    height: 40.w,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchYouTube(String videoId) async {
    final uri = Uri.parse("https://www.youtube.com/watch?v=$videoId");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _getCategoryText(String category) {
    switch (category) {
      case "زيارات":
        return "زیارت‌ها";
      case "مشاركات اجتماعية":
        return "اجتماعی";
      case "ندوات":
        return "ندوت‌ها";
      default:
        return category;
    }
  }

  String _formatDate(String date) {
    try {
      final parts = date.split('/');
      if (parts.length == 3) {
        return "${parts[2]}/${parts[1]}/${parts[0]}";
      }
      return date;
    } catch (e) {
      return date;
    }
  }
}
