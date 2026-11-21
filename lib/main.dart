import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/di/injection.dart';
import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/core/utils/app_theme.dart';
import 'package:movie_discovery_app/core/utils/settings_cubit.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_cubit.dart';
import 'package:movie_discovery_app/features/auth/presentation/views/forgot_password_screen.dart';
import 'package:movie_discovery_app/features/auth/presentation/views/login_screen.dart';
import 'package:movie_discovery_app/features/auth/presentation/views/register_screen.dart';
import 'package:movie_discovery_app/features/home/home_screen.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/views/movie_details_screen.dart';
import 'package:movie_discovery_app/features/profile/presentation/views/profile_tab.dart';
import 'package:movie_discovery_app/features/splash/presentation/views/splash_screen.dart';
import 'package:movie_discovery_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await configureDependencies();

  await EasyLocalization.ensureInitialized();

  final settingsCubit = getIt<SettingsCubit>();

  await settingsCubit.loadSettings();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: Locale(settingsCubit.state.settings.languageCode),
      saveLocale: false,
      child: MyApp(settingsCubit: settingsCubit),
    ),
  );
}

class MyApp extends StatefulWidget {
  final SettingsCubit settingsCubit;

  const MyApp({super.key, required this.settingsCubit});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _localeInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_localeInitialized) {
      _localeInitialized = true;

      final savedLocale = Locale(
        widget.settingsCubit.state.settings.languageCode,
      );

      if (context.locale != savedLocale) {
        context.setLocale(savedLocale);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 850),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<AuthCubit>()),
            BlocProvider.value(value: widget.settingsCubit),
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

                // Localization
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,

                // Theme
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: state.settings.isDark
                    ? ThemeMode.dark
                    : ThemeMode.light,

                // Routes
                initialRoute: AppRoutes.splashScreenRouteName,
                routes: {
                  AppRoutes.splashScreenRouteName: (context) =>
                      const SplashScreen(),

                  AppRoutes.loginScreenRouteName: (context) =>
                      const LoginScreen(),

                  AppRoutes.registerScreenRouteName: (context) =>
                      const RegisterScreen(),

                  AppRoutes.forgotPasswordScreenRouteName: (context) =>
                      const ForgotPasswordScreen(),

                  AppRoutes.homeScreenRouteName: (context) =>
                      const HomeScreen(),

                  AppRoutes.profileScreenRouteName: (context) =>
                      const ProfileTab(),

                  AppRoutes.movieDetailsRouteName: (context) {
                    final args = ModalRoute.of(context)?.settings.arguments;
                    final movieId = args is int ? args : 0;
                    return MovieDetailsScreen(movieId: movieId);
                  },
                },
              );
            },
          ),
        );
      },
    );
  }
}
