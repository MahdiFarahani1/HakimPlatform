import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/config/app_version.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void drawerApp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,

    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) =>
            Container(
                  height: MediaQuery.of(context).size.height * .72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: Theme.of(context).brightness == Brightness.dark
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
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
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
                              borderRadius: BorderRadius.circular(50),
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .scale(begin: const Offset(.8, .8)),

                      const SizedBox(height: 30),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(children: [const Spacer()]),
                      ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.2),

                      Expanded(
                        child: ListView(
                          controller: controller,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            _buildMenuItem(
                              context,
                              Assets.icons.home.path,
                              "الصفحة الرئيسية",
                              0,
                              Icons.home_outlined,
                            ),
                            _buildMenuItem(
                              context,
                              Assets.icons.search.path,
                              "جستجو",
                              1,
                              Icons.search_outlined,
                            ),
                            _buildMenuItem(
                              context,
                              Assets.icons.bookmark.path,
                              "ذخیره شده",
                              2,
                              Icons.bookmark_border_outlined,
                            ),
                            _buildMenuItem(
                              context,
                              Assets.icons.video.path,
                              "ویدئوها",
                              3,
                              Icons.play_circle_outline,
                            ),

                            const SizedBox(height: 12),

                            Container(
                              height: 1,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white10
                                  : Colors.grey[200],
                            ),

                            const SizedBox(height: 4),

                            _buildMenuItem(
                              context,
                              Assets.icons.user.path,
                              "تنظیمات",
                              4,
                              Icons.settings_outlined,
                            ),

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
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white10
                                  : Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          AppVersion.instance.fullVersion,
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade500
                                : Colors.grey[400],
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 250.ms)
                .slideY(begin: 1, duration: 500.ms, curve: Curves.easeOutCubic)
                .scale(
                  begin: const Offset(.98, .98),
                  duration: 450.ms,
                  curve: Curves.easeOut,
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
  IconData materialIcon,
) {
  return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            borderRadius: BorderRadius.circular(20),
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
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColor.primaryBlue.withOpacity(0.1),
                        const Color(0xff6B4EFF).withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    materialIcon,
                    color: AppColor.primaryBlue,
                    size: 22,
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade500
                        : Colors.grey[400],
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
  return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
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
          borderRadius: BorderRadius.circular(24),
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
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.info_outline,
                color: AppColor.primaryBlue,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'درباره برنامه',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'کتابخانه دیجیتال با بیش از ۱۰۰۰ کتاب و محتوای صوتی',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
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
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.transparent
                        : Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: AppColor.primaryBlue,
              ),
            ),
          ],
        ),
      )
      .animate(delay: 500.ms)
      .fadeIn(duration: 400.ms)
      .slideX(begin: 0.2, curve: Curves.easeOutCubic);
}
