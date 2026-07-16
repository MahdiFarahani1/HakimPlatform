import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/core/widgets/back_btn.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AppFeaturesPage extends StatelessWidget {
  const AppFeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> features = [
      {
        'title': 'المكتبة الرقمية',
        'desc':
            'تضم أكثر من ۱۰۰۰ كتاب فكري وعلمي وثقافي متميز، مع إمكانية القراءة المباشرة وتخصيص النصوص.',
        'icon': Assets.icons.books.path,
        'gradient': [
          AppColor.primaryBlue,
          const Color.fromARGB(255, 21, 41, 104),
        ],
      },
      {
        'title': 'المشغل الصوتي',
        'desc':
            'مشغل متكامل للاستماع إلى المحاضرات والكتب الصوتية والملفات الصوتية بجودة عالية في الخلفية.',
        'icon': Assets.icons.headphonesRhythm.path,
        'gradient': [
          AppColor.primaryBlue,
          const Color.fromARGB(255, 21, 41, 104),
        ],
      },
      {
        'title': 'معرض الفيديوهات',
        'desc':
            'تغطية مرئية متكاملة لجميع المحاضرات واللقاءات التلفزيونية والندوات بجودة عالية مع خيارات تحكم مرنة.',
        'icon': Assets.icons.video.path,
        'gradient': [
          AppColor.primaryBlue,
          const Color.fromARGB(255, 21, 41, 104),
        ],
      },
      {
        'title': 'الأخبار والمقالات',
        'desc':
            'تغطية إخبارية حية وشاملة لآخر التطورات والبيانات والمقالات التحليلية والفكرية أولاً بأول.',
        'icon': Assets.icons.newspaper.path,
        'gradient': [
          AppColor.primaryBlue,
          const Color.fromARGB(255, 21, 41, 104),
        ],
      },
      {
        'title': 'معرض الصور',
        'desc':
            'أرشيف صوري متكامل يوثق الأنشطة واللقاءات والمناسبات الرسمية بدقة وجودة عالية.',
        'icon': Assets.icons.gallery.path,
        'gradient': [
          AppColor.primaryBlue,
          const Color.fromARGB(255, 21, 41, 104),
        ],
      },
      {
        'title': 'العلامات المرجعية',
        'desc':
            'إمكانية حفظ كتبك ومقالاتك وفيديوهاتك المفضلة للوصول إليها مباشرة في أي وقت لاحق.',
        'icon': Assets.icons.bookmark.path,
        'gradient': [
          AppColor.primaryBlue,
          const Color.fromARGB(255, 21, 41, 104),
        ],
      },
      {
        'title': 'سجل النشاط',
        'desc':
            'سجل تفاعلي ذكي يوثق قراءاتك واستماعك الأخير ليسهل عليك إكمال تصفحك للكتب والصوتيات.',
        'icon': Assets.icons.clockThree.path,
        'gradient': [
          AppColor.primaryBlue,
          const Color.fromARGB(255, 21, 41, 104),
        ],
      },
      {
        'title': 'التخصيص والوضع الداكن',
        'desc':
            'خيارات واسعة للتحكم بنوع وحجم الخط والتبديل التلقائي أو اليدوي لنسق المظهر الداكن لراحة العين.',
        'icon': Assets.icons.nightDay.path,
        'gradient': [
          AppColor.primaryBlue,
          const Color.fromARGB(255, 21, 41, 104),
        ],
      },
    ];

    return Scaffold(
      appBar: _buildModernAppBar(context),
      body: Container(
        decoration: BoxDecoration(gradient: context.appTheme.scaffoldGradient),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Top Hero header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildIntroBanner(context, isDark),
                          const SizedBox(height: 24),
                          Text(
                                'المميزات والخدمات الرقمية',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : AppColor.primaryBlue,
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideX(begin: 0.1),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),

                  // Features Grid
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio:
                            0.72.w, // Dynamic aspect ratio for screens
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final feature = features[index];
                        return _buildFeatureCard(
                          context,
                          title: feature['title'],
                          desc: feature['desc'],
                          iconPath: feature['icon'],
                          gradient: feature['gradient'],
                          isDark: isDark,
                          index: index,
                        );
                      }, childCount: features.length),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              "مميزات التطبيق",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Align(alignment: Alignment.centerRight, child: AppBackButton()),
        ],
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.primaryBlue.withOpacity(0.08),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroBanner(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColor.primaryBlue.withOpacity(0.12),
                  const Color(0xff6B4EFF).withOpacity(0.05),
                ]
              : [
                  AppColor.primaryBlue.withOpacity(0.06),
                  const Color(0xff6B4EFF).withOpacity(0.03),
                ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColor.primaryBlue.withOpacity(isDark ? 0.2 : 0.08),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.primaryOrange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: AppColor.primaryOrange,
                  size: 26.sp,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'بوابة المعرفة الرقمية',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: isDark ? Colors.white : AppColor.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'نضع بين يديك تطبيقاً شاملاً يجمع الكتب والصوتيات والغطيات التلفزيونية والخبرية، لتوفير تجربة معرفية وثقافية متكاملة وسهلة الاستخدام.',
            style: TextStyle(
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              fontSize: 12.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.15);
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String desc,
    required String iconPath,
    required List<Color> gradient,
    required bool isDark,
    required int index,
  }) {
    return ZoomTapAnimation(
          beginDuration: const Duration(milliseconds: 50),
          endDuration: const Duration(milliseconds: 100),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.appTheme.cardBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.grey.withOpacity(0.06),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon with soft glowing background
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        gradient[0].withOpacity(0.12),
                        gradient[1].withOpacity(0.04),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: gradient[0].withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Image.asset(
                    iconPath,
                    width: 24,
                    height: 24,
                    color: gradient[0],
                  ),
                ),
                const SizedBox(height: 14),

                // Feature Title
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5.sp,
                    color: isDark ? Colors.white : const Color(0xff2C3E50),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // Feature Desc
                Expanded(
                  child: Text(
                    desc,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 10.5.sp,
                      height: 1.5,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(delay: Duration(milliseconds: 100 + (index * 60)))
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack);
  }
}
