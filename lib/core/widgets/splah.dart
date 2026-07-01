import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/features/settings/logic/cubit/settings_cubit.dart';
import 'package:flutter_application_1/features/wrapper/presentation/wrapper_page.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      context.read<SettingsCubit>().refreshNotificationStatus();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WrapperPage()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          Assets.images.splash.path,
          fit: BoxFit.cover,
          width: context.screenWidth,
          height: context.screenHeight,
        ),
      ),
    );
  }
}
