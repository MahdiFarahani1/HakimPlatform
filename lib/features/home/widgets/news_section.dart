import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/widgets/custom_cache_image.dart';
import 'package:flutter_application_1/core/widgets/custom_loading.dart';
import 'package:flutter_application_1/features/home/widgets/header.dart';
import 'package:flutter_application_1/features/news/data/models/news_home_model.dart';
import 'package:flutter_application_1/features/news/presentation/all_news_view.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class NewsListSection extends StatelessWidget {
  final List<NewsHomeModel> news;

  const NewsListSection({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeHeader(
          title: "آخر الاخبار",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NewsScreen()),
            );
          },
        ),

        const SizedBox(height: 16),

        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: news.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final newsItem = news[index];
            return _buildNewsCard(context, newsItem);
          },
        ),
      ],
    );
  }

  Widget _buildNewsCard(BuildContext context, NewsHomeModel newsItem) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          boxShadow: [
            BoxShadow(
              blurRadius: 12.r,
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
              child: CustomCacheImage(
                imageUrl: "${Api.baseUrl}${newsItem.image}",
                width: 110.w,
                height: 110.h,
                fit: BoxFit.cover,
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.primaryOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Assets.icons.newspaper.image(
                                width: 15.w,
                                height: 15.h,
                                color: AppColor.primaryOrange,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                newsItem.category,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColor.primaryOrange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Assets.icons.calendar.image(
                              width: 14.w,
                              height: 14.h,
                              color: AppColor.primaryOrange,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              _formatDate(newsItem.date),
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColor.primaryOrange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      newsItem.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.grey.shade800,
                        height: 1.3,
                      ),
                    ),

                    SizedBox(height: 6.h),

                    if (newsItem.excerpt.isNotEmpty) ...[
                      Text(
                        newsItem.excerpt,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Container(
              width: 40.w,
              height: 110.h, 
              alignment: Alignment.center,
              child: Assets.icons.angleSmallLeft.image(
                width: 15.w,
                height: 15.h,
                color: AppColor.primaryOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final formatter = DateFormat('dd MMMM yyyy', 'ar');
      return formatter.format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }
}
