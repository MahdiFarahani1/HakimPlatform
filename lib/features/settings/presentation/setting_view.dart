import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/config/app_version.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/features/settings/logic/cubit/settings_cubit.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<SettingsCubit>().refreshNotificationStatus();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  final List<String> fonts = [
    GoogleFonts.rubik().fontFamily!,
    GoogleFonts.notoKufiArabic().fontFamily!,
    GoogleFonts.amiri().fontFamily!,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();

        return Scaffold(
          appBar: _buildModernAppBar(),
          body: Container(
            decoration: BoxDecoration(
              gradient: context.appTheme.scaffoldGradient,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildSection(
                        context: context,

                        title: "المظهر",
                        children: [
                          _buildModernSwitch(
                            icon: Assets.icons.nightDay.path,
                            title: "الوضع الداكن",
                            value: state.isDarkMode,
                            onChanged: cubit.toggleDarkMode,
                          ),
                          _buildDivider(),
                          _buildModernSlider(
                            icon: Assets.icons.textSize.path,
                            title: "حجم الخط",
                            value: state.fontSize,
                            min: 12,
                            max: 24,
                            onChanged: cubit.updateFontSize,
                          ),
                          _buildDivider(),
                          _buildModernDropdown(
                            context,
                            icon: Assets.icons.textCheck.path,
                            title: "نوع الخط",
                            value: state.selectedFont,
                            items: fonts,
                            onChanged: cubit.updateFontFamily,
                          ),
                        ],
                      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),

                      const SizedBox(height: 20),

                      _buildSection(
                        context: context,

                        title: "الإشعارات",
                        children: [
                          _buildModernSwitch(
                            icon: Assets.icons.cowbell.path,
                            title: "تفعيل الإشعارات",
                            value: state.notifications,
                            onChanged: cubit.toggleNotifications,
                          ),
                        ],
                      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),

                      const SizedBox(height: 20),

                      _buildSection(
                        context: context,
                        title: "الخصوصية",
                        children: [
                          _buildModernTile(
                            icon: Assets.icons.privacySettings.path,
                            title: "سياسة الخصوصية",
                            onTap: () {},
                          ),
                        ],
                      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: Colors.transparent,
                  child: SafeArea(
                    top: false,
                    child: Center(
                      child: Text(
                        AppVersion.instance.fullVersion,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      title: const Text(
        "الإعدادات",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
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

  Widget _buildSection({
    required String title,
    required List<Widget> children,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.appTheme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.1),
                ),
              ],
            ),
          ),

          Column(children: children),
        ],
      ),
    );
  }

  Widget _buildModernSwitch({
    required String icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColor.primaryBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Image.asset(
              icon,
              width: 22,
              height: 22,
              color: AppColor.primaryBlue,
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),

          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColor.primaryBlue,
            activeTrackColor: AppColor.primaryBlue.withOpacity(0.3),
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSlider({
    required String icon,
    required String title,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset(
                  icon,
                  width: 22,
                  height: 22,
                  color: AppColor.primaryBlue,
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColor.primaryBlue,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
            activeColor: AppColor.primaryBlue,
            inactiveColor: AppColor.primaryBlue.withOpacity(0.15),
          ),
        ],
      ),
    );
  }

  Widget _buildModernDropdown(
    BuildContext context, {
    required String icon,
    required String title,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          backgroundColor: Theme.of(context).cardColor,
          builder: (_) {
            return Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  ...items.map((item) {
                    final isSelected = item == value;
                    return ListTile(
                      leading: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: AppColor.primaryBlue,
                              size: 20,
                            )
                          : null,
                      title: Text(
                        item,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected ? AppColor.primaryBlue : null,
                        ),
                      ),
                      onTap: () {
                        onChanged(item);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Image.asset(
                icon,
                width: 22,
                height: 22,
                color: AppColor.primaryBlue,
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),

            Text(
              value,
              style: TextStyle(
                color: AppColor.primaryBlue,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildModernTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Image.asset(
                icon,
                width: 22,
                height: 22,
                color: AppColor.primaryBlue,
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),

            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.withOpacity(0.1),
      indent: 20,
      endIndent: 20,
    );
  }
}
