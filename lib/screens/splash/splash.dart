import 'dart:async';

import 'package:denomination/constants/assets/const_images.dart';
import 'package:denomination/routes/routes_names.dart';
import 'package:denomination/theme/colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Timer timer;

  @override
  void initState() {
    _navigation();
    super.initState();
  }

  _navigation() async {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.popAndPushNamed(context, RouteNames.dashboardScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.appBackground,
      body: Center(child: Image.asset(ConstantImage.appLogo, scale: 3)),
    );
  }
}
