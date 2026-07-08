// lib/pages/about_page.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/di.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/widgets/error_widget.dart';
import 'package:flutter_application_1/features/wrapper/data/models/about_model.dart';
import 'package:flutter_application_1/features/wrapper/logic/cubit/about_cubit.dart';
import 'package:flutter_application_1/features/wrapper/widgets/about_loading.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/core/utils/extension.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AboutCubit(getIt())..fetchAboutInfo(),
      child: const _AboutView(),
    );
  }
}

class _AboutView extends StatelessWidget {
  const _AboutView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AboutCubit, AboutState>(
          builder: (context, state) {
            if (state.apiState is AboutLoaded) {
              return Text(
                state.isAr ? 'عني' : 'About Me',
                style: TextStyle(
                  color: AppColor.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
            if (state.apiState is AboutLoading) {
              return SizedBox(
                width: 30.w,
                child: LinearProgressIndicator(
                  color: AppColor.primaryOrange,
                  backgroundColor: AppColor.primaryOrange.withOpacity(0.2),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ).animate().fade(duration: 300.ms).slideX(begin: -0.2),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          BlocBuilder<AboutCubit, AboutState>(
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.1)
                      : AppColor.primaryBlue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      !state.isAr ? 'EN' : 'عربي',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.primaryBlue,
                      ),
                    ),
                    Switch(
                      value: state.isAr,
                      onChanged: (val) =>
                          context.read<AboutCubit>().changeLanguage(val),
                      activeColor: AppColor.primaryOrange,
                      activeTrackColor: AppColor.primaryOrange.withOpacity(0.5),
                      inactiveThumbColor: AppColor.primaryBlue,
                      inactiveTrackColor: AppColor.primaryBlue.withOpacity(0.3),
                    ),
                  ],
                ),
              );
            },
          ).animate().fade(duration: 300.ms).slideX(begin: 0.2),
          SizedBox(width: 8.w),
        ],
      ),
      body: BlocBuilder<AboutCubit, AboutState>(
        builder: (context, state) {
          if (state.apiState is AboutLoading) {
            return const AboutSkeletonLoading();
          } else if (state.apiState is AboutError) {
            return CustomErrorWidget(
              onRetry: () => context.read<AboutCubit>().refresh(),
            );
          } else if (state.apiState is AboutLoaded) {
            final loadedState = state.apiState as AboutLoaded;
            return _AboutContent(
              aboutData: loadedState.aboutData,
              isArabic: state.isAr,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _AboutContent extends StatelessWidget {
  final AboutModel aboutData;
  final bool isArabic;

  const _AboutContent({required this.aboutData, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(gradient: context.appTheme.scaffoldGradient),

        child: Column(
          children: [
            // Header Section with Animation
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.primaryBlue, AppColor.primaryOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
              child: Column(
                children: [
                  Container(
                        width: 120.w,
                        height: 120.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.2),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.r),
                          child: aboutData.aboutImageUrl.isNotEmpty
                              ? Image.network(
                                  aboutData.aboutImageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Assets
                                      .images
                                      .icon
                                      .image(width: 40, height: 40),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 50.sp,
                                  color: AppColor.primaryBlue,
                                ),
                        ),
                      )
                      .animate()
                      .scale(duration: 600.ms, curve: Curves.easeOutBack)
                      .fade(),
                  SizedBox(height: 16.h),
                  Text(
                    aboutData.getAboutImageName(isArabic),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fade(duration: 400.ms).slideY(begin: 0.2),
                  SizedBox(height: 8.h),
                  Text(
                    aboutData.getAboutImageRole(isArabic),
                    style: TextStyle(
                      color: Colors.white.withOpacity(.9),
                      fontSize: 14.sp,
                    ),
                  ).animate().fade(duration: 500.ms).slideY(begin: 0.3),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      aboutData.getAboutBirthInfo(isArabic),
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                  ).animate().fade(duration: 600.ms).slideY(begin: 0.4),
                ],
              ),
            ).animate().fade(duration: 500.ms),

            // Content Section
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    children: [
                      Text(
                        aboutData.getAboutTitle(isArabic),
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryBlue,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        aboutData.getAboutTitleHighlight(isArabic),
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryOrange,
                        ),
                      ),
                    ],
                  ).animate().fade(duration: 400.ms).slideX(begin: -0.2),
                  SizedBox(height: 8.h),
                  Text(
                    aboutData.getAboutSubtitle(isArabic),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ).animate().fade(duration: 500.ms).slideX(begin: -0.15),
                  SizedBox(height: 24.h),

                  // Description Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.transparent
                              : AppColor.primaryBlue.withOpacity(.08),
                          blurRadius: 25,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          aboutData.getAboutDescTitle(isArabic),
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryBlue,
                          ),
                        ).animate().fade(duration: 400.ms),
                        SizedBox(height: 12.h),
                        Text(
                          aboutData.getAboutDescText(isArabic),
                          style: TextStyle(height: 1.6, fontSize: 15.sp),
                          textAlign: TextAlign.justify,
                        ).animate().fade(duration: 600.ms),
                        SizedBox(height: 24.h),
                        Row(
                          children: [
                            Expanded(
                              child:
                                  _infoTile(
                                    Icons.auto_awesome,
                                    aboutData.getAboutMethodLabel(isArabic),
                                    aboutData.getAboutMethodValue(isArabic),
                                    AppColor.primaryBlue,
                                  ).animate().scale(
                                    delay: 300.ms,
                                    duration: 400.ms,
                                  ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child:
                                  _infoTile(
                                    Icons.bolt,
                                    aboutData.getAboutActivityLabel(isArabic),
                                    aboutData.getAboutActivityValue(isArabic),
                                    AppColor.primaryOrange,
                                  ).animate().scale(
                                    delay: 400.ms,
                                    duration: 400.ms,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fade(duration: 500.ms).slideY(begin: 0.1),
                  SizedBox(height: 20.h),

                  // Metric Card
                  if (aboutData.getAboutMetricTitle(isArabic).isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColor.primaryBlue.withOpacity(.15),
                            AppColor.primaryOrange.withOpacity(.15),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                      child: Column(
                        children: [
                          Text(
                            aboutData.getAboutMetricTitle(isArabic),
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryBlue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            aboutData.getAboutMetricSubtitle(isArabic),
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ).animate().fade(duration: 500.ms).scale(delay: 200.ms),
                  SizedBox(height: 20.h),

                  // Pillars Section
                  if (aboutData.getPillars(isArabic).isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? 'أهداف المشروع' : 'Project Goals',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryBlue,
                          ),
                        ).animate().fade(duration: 400.ms),
                        SizedBox(height: 16.h),
                        ...aboutData
                            .getPillars(isArabic)
                            .asMap()
                            .entries
                            .map(
                              (entry) =>
                                  _pillarTile(context, entry.value, entry.key),
                            ),
                      ],
                    ),
                  SizedBox(height: 20.h),

                  // Social Links Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue,
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryBlue.withOpacity(.3),
                          blurRadius: 25,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.share,
                          size: 48,
                          color: AppColor.primaryOrange,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          isArabic ? 'تابعنا على' : 'Follow Us',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryOrange,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Wrap(
                          spacing: 16.w,
                          runSpacing: 16.h,
                          alignment: WrapAlignment.center,
                          children: aboutData.socialLinks
                              .asMap()
                              .entries
                              .map(
                                (entry) => _socialIcon(
                                  context,
                                  entry.value,
                                  entry.key,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ).animate().fade(duration: 500.ms).slideY(begin: 0.1),
                  SizedBox(height: 40.h),

                  // Footer
                  Center(
                    child: Text(
                      '© ${DateTime.now().year} ${isArabic ? 'جميع الحقوق محفوظة' : 'All Rights Reserved'}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12.sp,
                      ),
                    ),
                  ).animate().fade(delay: 600.ms, duration: 400.ms),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(.1), color.withOpacity(.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28.sp),
          SizedBox(height: 10.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _pillarTile(BuildContext context, PillarModel pillar, int index) {
    return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.transparent
                    : AppColor.primaryBlue.withOpacity(.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 54.w,
                height: 54.h,
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Center(
                  child: Text(
                    pillar.icon,
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryOrange,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pillar.label,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryBlue,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      pillar.desc,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fade(duration: 500.ms)
        .slideX(begin: -0.1)
        .then(delay: Duration(milliseconds: 50 * index));
  }

  Widget _socialIcon(BuildContext context, SocialLinkModel link, int index) {
    IconData icon;
    Color color;

    switch (link.platform.toLowerCase()) {
      case 'telegram':
        icon = Icons.telegram;
        color = const Color(0xff26A5E4);
        break;
      case 'youtube':
        icon = Icons.play_circle_filled;
        color = const Color(0xffFF0000);
        break;
      case 'instagram':
        icon = Icons.camera_alt;
        color = const Color(0xffE4405F);
        break;
      case 'twitter':
        icon = Icons.edit_note;
        color = const Color(0xff1DA1F2);
        break;
      case 'facebook':
        icon = Icons.facebook;
        color = const Color(0xff1877F2);
        break;
      case 'tiktok':
        icon = Icons.music_note;
        color = const Color(0xff000000);
        break;
      case 'whatsapp':
        icon = Icons.chat;
        color = const Color(0xff25D366);
        break;
      default:
        icon = Icons.link;
        color = Colors.grey;
    }

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(40.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(
                  context,
                ).colorScheme.onPrimaryContainer.withOpacity(.95)
              : Colors.white.withOpacity(.95),
          borderRadius: BorderRadius.circular(40.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.transparent
                  : Colors.black.withOpacity(.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 26.sp),
      ),
    ).animate().scale(
      delay: Duration(milliseconds: 100 * index),
      duration: 400.ms,
    );
  }
}
