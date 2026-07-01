import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/widgets/custom_cache_image.dart';
import 'package:flutter_application_1/core/widgets/custom_loading.dart';
import 'package:flutter_application_1/features/dialogue/data/models/dialogue_model.dart';
import 'package:flutter_application_1/features/home/widgets/header.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class InterviewsSection extends StatelessWidget {
  final List<DialogueModel> interviews;

  const InterviewsSection({super.key, required this.interviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeHeader(title: "آخر المقابلات", onTap: () {}),
        SizedBox(height: 20.h),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: interviews.length,
          separatorBuilder: (_, __) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            return _buildModernInterviewCard(context, interviews[index]);
          },
        ),
      ],
    );
  }

  Widget _buildModernInterviewCard(
    BuildContext context,
    DialogueModel interview,
  ) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          boxShadow: [
            BoxShadow(
              blurRadius: 20.r,
              color: Colors.black.withOpacity(0.06),
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE WITH OVERLAY
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                  child: CustomCacheImage(
                    imageUrl: "${Api.baseUrl}${interview.image}",
                    width: double.infinity,
                    height: 180.h,
                    fit: BoxFit.cover,
                  ),
                ),
                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.r),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                ),
                // Play Button
                Positioned(
                  bottom: 16.h,
                  left: 16.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8.r,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          size: 19.sp,
                          color: AppColor.primaryBlue,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "مشاهدة المقابلة",
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            /// CONTENT
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    interview.title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF1E293B),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 12.h),

                  /// METADATA ROW
                  Row(
                    children: [
                      /// INTERVIEWER
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Assets.icons.circleMicrophoneLines.image(
                              width: 14.w,
                              height: 14.h,
                              color: AppColor.primaryOrange,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              _getInterviewerName(interview.interviewer),
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColor.primaryOrange,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 12.w),

                      /// DATE
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryOrange.withOpacity(0.1),

                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Assets.icons.calendar.image(
                              width: 14.w,
                              height: 14.h,
                              color: AppColor.primaryOrange,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              _formatDate(interview.date),
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.primaryOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  /// EXCERPT (if available)
                  if (interview.excerpt.isNotEmpty) ...[
                    Text(
                      interview.excerpt,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade400
                            : const Color(0xFF64748B),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12.h),
                  ],

                  /// VIEW DETAILS BUTTON
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white24
                              : Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "تفاصيل المقابلة",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColor.primaryBlue,
                          ),
                        ),
                        Assets.icons.angleSmallLeft.image(
                          width: 15.w,
                          height: 15.h,
                          color: AppColor.primaryBlue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInterviewerName(String interviewer) {
    if (interviewer.contains("قناة")) {
      return "مقابلة تلفزيونية";
    }
    if (interviewer.contains("ملتقى")) {
      return "ملتقى استراتيجي";
    }
    if (interviewer.length > 15) {
      return "${interviewer.substring(0, 12)}...";
    }
    return interviewer;
  }

  String _formatDate(String dateString) {
    try {
      final parts = dateString.split('/');
      if (parts.length == 3) {
        final date = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
        final formatter = DateFormat('dd MMMM yyyy', 'ar');
        return formatter.format(date);
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
  }
}
