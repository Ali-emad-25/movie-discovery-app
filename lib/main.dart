
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movie_discovery_app/core/di/injection.dart';
import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/core/theme/app_theme.dart';
import 'package:movie_discovery_app/core/utils/settings_cubit.dart';

import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_cubit.dart';
import 'package:movie_discovery_app/features/auth/presentation/views/forgot_password_screen.dart';
import 'package:movie_discovery_app/features/auth/presentation/views/login_screen.dart';
import 'package:movie_discovery_app/features/auth/presentation/views/register_screen.dart';
import 'package:movie_discovery_app/features/home/presentation/views/home_screen.dart';
import 'package:movie_discovery_app/features/profile/presentation/views/profile_screen.dart';

import 'package:movie_discovery_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await configureDependencies();

  await EasyLocalization.ensureInitialized();

  final settingsCubit = getIt<SettingsCubit>();
  await settingsCubit.loadSettings();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: Locale(settingsCubit.state.settings.languageCode),
      saveLocale: false,
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
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => getIt<AuthCubit>(),
            ),
            BlocProvider.value(
              value: getIt<SettingsCubit>(),
            ),
          ],
          child: BlocConsumer<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) =>
            previous.settings != current.settings,
            listener: (context, state) {
              final locale = Locale(state.settings.languageCode);

              if (context.locale != locale) {
                context.setLocale(locale);
              }
            },
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: state.settings.isDark
                    ? ThemeMode.dark
                    : ThemeMode.light,
                initialRoute: AppRoutes.loginScreenRouteName,
                routes: {
                  AppRoutes.loginScreenRouteName: (context) =>
                  const LoginScreen(),
                  AppRoutes.registerScreenRouteName: (context) =>
                  const RegisterScreen(),
                  AppRoutes.forgotPasswordScreenRouteName: (context) =>
                  const ForgotPasswordScreen(),
                  AppRoutes.homeScreenRouteName: (context) =>
                  const HomeScreen(),
                  AppRoutes.profileScreenRouteName: (context) =>
                  const ProfileScreen(),
                },
              );
            },
          ),
        );
      },
    );
  }
}
