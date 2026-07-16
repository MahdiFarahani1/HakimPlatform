import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/core/widgets/back_btn.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Policy topics structure
    final List<Map<String, dynamic>> policyItems = [
      {
        'title': 'جمع المعلومات',
        'desc':
            'نحن لا نقوم بجمع أو حفظ أي من بياناتك الشخصية الحساسة. تفضيلات القراءة والاستماع الخاصة بك وتاريخ التصفح يتم تخزينها بالكامل محلياً وبشكل آمن على جهازك فقط.',
        'icon': Assets.icons.user.path,
        'gradient': [
          AppColor.primaryBlue,
          const Color.fromARGB(255, 21, 41, 104),
        ],
      },
      {
        'title': 'الأذونات المطلوبة',
        'desc':
            'يتطلب التطبيق أذونات محدودة جداً ليعمل بشكل سليم، مثل الوصول إلى شبكة الإنترنت لعرض المحتوى وتحديث الكتب والأخبار، وأذونات الإشعارات لتلقي تنبيهات التحديثات.',
        'icon': Assets.icons.cowbell.path,
        'gradient': [
          AppColor.primaryBlue,
          const Color.fromARGB(255, 21, 41, 104),
        ],
      },
      {
        'title': 'أمان وحماية البيانات',
        'desc':
            'جميع الاتصالات التي يجريها التطبيق مع الخادم تتم عبر بروتوكولات آمنة ومشفرة بالكامل لضمان سرية وسلامة البيانات ومنع أي وصول غير مصرح به.',
        'icon': Assets.icons.octagonCheck.path,
        'gradient': [
          AppColor.primaryBlue,
          const Color.fromARGB(255, 21, 41, 104),
        ],
      },
      {
        'title': 'التحديثات والمزامنة',
        'desc':
            'نقوم بتحديث سياسة الخصوصية بشكل دوري لمواكبة القوانين الجديدة والتغييرات البرمجية. سيتم إخطارك في حال طرأت أي تغييرات رئيسية تؤثر على خصوصيتك.',
        'icon': Assets.icons.clockThree.path,
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
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                children: [
                  // Beautiful Hero Info Section
                  _buildHeroCard(context, isDark),
                  const SizedBox(height: 24),

                  // Policy Section Title
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    child: Text(
                      'بنود السياسة والخصوصية',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColor.primaryBlue,
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1),
                  const SizedBox(height: 12),

                  // Staggered Policy cards
                  ...List.generate(policyItems.length, (index) {
                    final item = policyItems[index];
                    return _buildPolicyCard(
                      context,
                      title: item['title'],
                      desc: item['desc'],
                      iconPath: item['icon'],
                      gradient: item['gradient'],
                      isDark: isDark,
                      index: index,
                    );
                  }),

                  const SizedBox(height: 16),
                  _buildSupportSection(context, isDark),
                  const SizedBox(height: 30),
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
              "سياسة الخصوصية",
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

  Widget _buildHeroCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColor.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              Assets.icons.privacySettings.path,
              width: 38,
              height: 38,
              color: AppColor.primaryOrange,
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أمانك هو أولويتنا',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                    color: isDark ? Colors.white : AppColor.primaryBlue,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'نلتزم بحماية خصوصيتك وضمان تقديم تجربة استخدام آمنة وموثوقة خالية من أي تتبع.',
                  style: TextStyle(
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                    fontSize: 12.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildPolicyCard(
    BuildContext context, {
    required String title,
    required String desc,
    required String iconPath,
    required List<Color> gradient,
    required bool isDark,
    required int index,
  }) {
    return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: context.appTheme.cardBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey.withOpacity(0.08),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                childrenPadding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: gradient[0].withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    iconPath,
                    width: 22,
                    height: 22,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5.sp,
                    color: isDark ? Colors.white : const Color(0xff2C3E50),
                  ),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                children: [
                  Text(
                    desc,
                    style: TextStyle(
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                      fontSize: 13.sp,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ).animate().fadeIn(duration: 300.ms),
                ],
              ),
            ),
          ),
        )
        .animate(delay: Duration(milliseconds: 100 + (index * 80)))
        .fadeIn(duration: 450.ms)
        .slideY(begin: 0.15, curve: Curves.easeOutQuad);
  }

  Widget _buildSupportSection(BuildContext context, bool isDark) {
    final supportEmail = 'info@alhakim.iq';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appTheme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColor.primaryOrange.withOpacity(isDark ? 0.15 : 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.primaryOrange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  Assets.icons.info.path,
                  width: 24,
                  height: 24,
                  color: AppColor.primaryOrange,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'هل لديك أي استفسار؟',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'فريق الدعم الفني جاهز لمساعدتك في أي وقت.',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 11.5.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Divider(color: isDark ? Colors.white10 : Colors.grey[200]),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'البريد الإلكتروني للدعم:',
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: supportEmail));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 8),
                          const Text('تم نسخ البريد الإلكتروني بنجاح!'),
                        ],
                      ),
                      backgroundColor: AppColor.primaryBlue,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlue.withOpacity(0.08),
                    border: Border.all(
                      color: AppColor.primaryBlue.withOpacity(0.15),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        supportEmail,
                        style: TextStyle(
                          color: AppColor.primaryBlue,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.copy_rounded,
                        size: 14,
                        color: AppColor.primaryBlue,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: 500.ms).fadeIn(duration: 400.ms);
  }
}
