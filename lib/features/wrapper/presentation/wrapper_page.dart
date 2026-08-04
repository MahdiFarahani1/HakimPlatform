import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/features/bookmark/presentation/bookmark_view.dart';
import 'package:flutter_application_1/features/gallery/presentation/gallery_view.dart';
import 'package:flutter_application_1/features/settings/presentation/setting_view.dart';
import 'package:flutter_application_1/features/videos/presentation/videos_view.dart';
import 'package:flutter_application_1/features/wrapper/presentation/aboutus_page.dart';
import 'package:flutter_application_1/features/wrapper/widgets/bottom_nav_bar.dart';
import 'package:flutter_application_1/features/home/logic/cubit/navigation_cubit.dart';
import 'package:flutter_application_1/features/home/presentation/home_page.dart';
import 'package:flutter_application_1/features/wrapper/widgets/drawer.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/config/di.dart';
import 'package:flutter_application_1/features/search/logic/cubit/search_cubit.dart';
import 'package:flutter_application_1/features/search/presentation/search_view.dart';

class WrapperPage extends StatefulWidget {
  const WrapperPage({super.key});

  @override
  State<WrapperPage> createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperPage> {
  final pages = [
    HomePage(),
    const SearchPage(),
    BookmarkScreen(),
    VideoGalleryScreen(),
    GalleryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(create: (context) => getIt<SearchCubit>()),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      icon: Assets.icons.menu.image(
                        width: 25,
                        height: 25,
                        color: context.theme.appBarTheme.iconTheme!.color,
                      ),
                      onPressed: () {
                        drawerApp(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      'السيد عمار الحكيم',
                      style: TextStyle(fontSize: 15.sp),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(),
                          ),
                        );
                      },
                      child: Assets.icons.settings.image(
                        width: 25,
                        height: 25,
                        color: context.theme.appBarTheme.iconTheme!.color,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutPage(),
                          ),
                        );
                      },
                      child: Assets.icons.termsInfo.image(
                        width: 25,
                        height: 25,
                        color: context.theme.appBarTheme.iconTheme!.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            return Stack(
              children: [
                PageView.builder(
                  onPageChanged: (value) {
                    context.read<NavigationCubit>().changeNavState(value);
                  },
                  controller: context.read<NavigationCubit>().pageController,
                  itemCount: pages.length,
                  itemBuilder: (context, index) => pages[index],
                ),
                Positioned(
                  bottom: 12,
                  right: 0,
                  left: 0,
                  child: BlocBuilder<NavigationCubit, int>(
                    builder: (context, state) {
                      return PremiumBottomNav(
                        currentIndex: state,
                        onTap: (value) {
                          context.read<NavigationCubit>().changeNavState(value);
                          context
                              .read<NavigationCubit>()
                              .pageController
                              .jumpToPage(value);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
