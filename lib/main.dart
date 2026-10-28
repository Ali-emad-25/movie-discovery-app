import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/core/theme/app_theme.dart';
import 'package:movie_discovery_app/core/theme/theme_cubit.dart';
import 'package:movie_discovery_app/core/theme/theme_state.dart';
import 'package:movie_discovery_app/features/auth/presentation/views/login_screen.dart';
import 'package:movie_discovery_app/features/auth/presentation/views/register_screen.dart';
import 'package:movie_discovery_app/features/home/presentation/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 850),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (_) => ThemeCubit(),
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,

                // Localization
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,

                // App Theme
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState is DarkThemeState
                    ? ThemeMode.dark
                    : ThemeMode.light,

                // Routes
                initialRoute: AppRoutes.loginScreenRouteName,
                routes: {
                  AppRoutes.loginScreenRouteName: (context) => LoginScreen(),
                  AppRoutes.registerScreenRouteName: (context) =>
                      RegisterScreen(),
                  AppRoutes.homeScreenRouteName: (context) => HomeScreen(),
                },
              );
            },
          ),
        );
      },
    );
  }
}
