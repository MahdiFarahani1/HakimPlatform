import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/config/app_version.dart';
import 'package:flutter_application_1/config/di.dart';
import 'package:flutter_application_1/config/theme.dart';
import 'package:flutter_application_1/core/connection/cubit/internet_cubit.dart';
import 'package:flutter_application_1/core/connection/overlay_connection.dart';
import 'package:flutter_application_1/core/widgets/splah.dart';
import 'package:flutter_application_1/features/bookmark/logic/cubit/book_mark_cubit.dart';
import 'package:flutter_application_1/features/home/data/repositories/home_repository.dart';
import 'package:flutter_application_1/features/home/logic/bloc/bloc/home_bloc.dart';
import 'package:flutter_application_1/features/settings/logic/cubit/settings_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencyInjection();
  await AppVersion.instance.init();

  final directory = await getApplicationDocumentsDirectory();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(directory.path),
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => HomeBloc(getIt<HomeRepository>()),
            ),

            BlocProvider(create: (context) => BookmarkCubit()),
            BlocProvider(create: (context) => SettingsCubit()),
            BlocProvider(create: (context) => InternetCubit()),
          ],

          child: BlocSelector<SettingsCubit, SettingsState, bool>(
            selector: (state) {
              return state.isDarkMode;
            },
            builder: (context, isDarkMode) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "السيد عمار الحكيم",

                locale: const Locale('ar'),

                supportedLocales: const [Locale('fa'), Locale('ar')],

                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                builder: (context, child) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: Stack(
                      children: [
                        ?child,

                        BlocBuilder<InternetCubit, InternetState>(
                          builder: (context, state) {
                            if (state == InternetState.disconnected) {
                              return const NoInternetOverlay();
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  );
                },

                home: const SplashScreen(),
              );
            },
          ),
        );
      },
    );
  }
}
