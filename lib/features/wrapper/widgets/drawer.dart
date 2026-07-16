import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/config/app_version.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/core/utils/review.dart';
import 'package:flutter_application_1/core/utils/share.dart';
import 'package:flutter_application_1/features/settings/logic/cubit/settings_cubit.dart';
import 'package:flutter_application_1/features/wrapper/presentation/aboutus_page.dart';
import 'package:flutter_application_1/features/wrapper/presentation/app_features_view.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void drawerApp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return SizedBox(
        height: context.screenHeight * 0.8,
        child: BlocSelector<SettingsCubit, SettingsState, bool>(
          selector: (state) {
            return state.isDarkMode;
          },
          builder: (context, isDark) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xff1A1C20),
                          const Color(0xff15161A),
                          const Color(0xff121212),
                        ]
                      : [
                          Colors.white,
                          const Color(0xffF8F9FF),
                          const Color(0xffF0F2FF),
                        ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 30,
                    color: Colors.black.withOpacity(0.15),
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                        height: 5,
                        width: 60,
                        decoration: BoxDecoration(
                          color: AppColor.primaryBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .scale(begin: const Offset(.8, .8)),

                  const SizedBox(height: 30),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildMenuItem(
                          context,
                          '',
                          "دعوة الأصدقاء",
                          0,
                          Assets.icons.share.path,
                          onTap: () {
                            ShareHelper.shareApp(context);
                          },
                        ),

                        _buildMenuItem(
                          context,
                          '',
                          "تقييم التطبيق",
                          1,
                          Assets.icons.starCommentAlt.path,
                          onTap: () {
                            ReviewService.requestReview();
                          },
                        ),

                        _buildMenuItem(
                          context,
                          '',
                          "تابعنا على وسائل التواصل",
                          2,
                          Assets.icons.socialMediaHand.path,
                          onTap: () {
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const AboutPage(isSocialMediaNav: true),
                              ),
                            );
                          },
                        ),

                        Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColor.primaryBlue.withOpacity(0.1),
                                          const Color(
                                            0xff6B4EFF,
                                          ).withOpacity(0.05),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Assets.icons.nightDay.image(
                                      color: AppColor.primaryBlue,
                                      width: 22,
                                      height: 22,
                                    ),
                                  ),
                                  title: const Text(
                                    "الوضع الداكن",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  trailing: Switch(
                                    value: isDark,
                                    activeColor: AppColor.primaryBlue,
                                    onChanged: (value) => context
                                        .read<SettingsCubit>()
                                        .toggleDarkMode(value),
                                  ),
                                ),
                              ),
                            )
                            .animate(delay: 280.ms)
                            .fadeIn(duration: 400.ms)
                            .slideX(begin: 0.2, curve: Curves.easeOutCubic),

                        const SizedBox(height: 20),

                        _buildAppInfoCard(context),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.w,
                      horizontal: 20.w,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: isDark ? Colors.white10 : Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      AppVersion.instance.fullVersion,
                      style: TextStyle(
                        color: isDark ? Colors.grey.shade500 : Colors.grey[400],
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

Widget _buildMenuItem(
  BuildContext context,
  String icon,
  String title,
  int index,
  String materialIcon, {
  required VoidCallback onTap,
}) {
  return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.transparent
                    : Colors.black.withOpacity(0.03),
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onTap,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.primaryBlue.withOpacity(0.1),
                        const Color(0xff6B4EFF).withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    materialIcon,
                    color: AppColor.primaryBlue,
                    height: 22,
                    width: 22,
                  ),
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xff2C3E50),
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Assets.icons.angleSmallLeft.image(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade500
                        : Colors.grey[400],
                    width: 12,
                    height: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      )
      .animate(delay: Duration(milliseconds: 100 + (index * 60)))
      .fadeIn(duration: 400.ms)
      .slideX(begin: 0.2, curve: Curves.easeOutCubic)
      .scale(begin: const Offset(.95, .95));
}

Widget _buildAppInfoCard(BuildContext context) {
  return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppFeaturesPage(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.primaryBlue.withOpacity(0.08),
                    const Color(0xff6B4EFF).withOpacity(0.04),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColor.primaryBlue.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Assets.icons.info.image(
                      color: AppColor.primaryBlue,
                      width: 22,
                      height: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'عن التطبيق', // درباره برنامه به عربی
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'المكتبة الرقمية التي تضم أكثر من ۱۰۰۰ كتاب ومحتوى صوتي', // توضیحات به عربی
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[400]
                                : Colors.grey[600],
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.transparent
                              : Colors.black.withOpacity(0.05),
                        ),
                      ],
                    ),
                    child: Assets.icons.angleSmallLeft.image(
                      color: AppColor.primaryBlue,
                      width: 12,
                      height: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
      .animate(delay: 350.ms)
      .fadeIn(duration: 400.ms)
      .slideX(begin: 0.2, curve: Curves.easeOutCubic);
}
