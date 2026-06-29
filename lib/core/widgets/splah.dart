import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/app_version.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/features/wrapper/presentation/wrapper_page.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
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
