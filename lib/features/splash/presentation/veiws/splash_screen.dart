import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_cubit.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _glowAnimation;
  late final Animation<double> _brandingFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    // Logo Glow: Gradually increases
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 0.40,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Branding: Gradually appears
    _brandingFade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _startSplash();
  }

  Future<void> _startSplash() async {
    await _controller.forward();

    if (!mounted) return;

    final authCubit = context.read<AuthCubit>();

    await authCubit.restoreSession();

    if (!mounted) return;

    final currentState = authCubit.state;

    final destination = currentState is AuthLoginSuccess
        ? AppRoutes.homeScreenRouteName
        : AppRoutes.loginScreenRouteName;

    Navigator.pushReplacementNamed(context, destination);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSystemDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    final backgroundColor = isSystemDark
        ? AppColors.bgDarkColor
        : AppColors.bgLightColor;

    final brandingColor = isSystemDark
        ? AppColors.textDarkColor
        : AppColors.textLightColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Logo with animated purple glow
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withValues(
                          alpha: _glowAnimation.value,
                        ),
                        blurRadius: 65.r,
                        spreadRadius: 5.r,
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/logo.png',
                width: 170.w,
                fit: BoxFit.contain,
              ),
            ),

            // Branding at the bottom center
            Positioned(
              left: 0,
              right: 0,
              bottom: 60.h,
              child: FadeTransition(
                opacity: _brandingFade,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Movie',
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                          color: brandingColor,
                        ),
                      ),
                      Text(
                        'Verse',
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                          color: isSystemDark
                              ? AppColors.primaryTextDarkColor
                              : AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
