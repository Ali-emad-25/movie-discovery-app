import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:movie_discovery_app/core/utils/settings_cubit.dart';
import 'package:movie_discovery_app/core/utils/settings_repository_impl.dart';
import 'package:movie_discovery_app/core/utils/settings_use_cases.dart';

import 'package:movie_discovery_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:movie_discovery_app/features/auth/data/data_sources/auth_remote_data_source_impl.dart';
import 'package:movie_discovery_app/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:movie_discovery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/continue_as_guest_use_case.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/get_current_user_use_case.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/send_password_reset_email_use_case.dart';

import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_cubit.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/forgot_password_cubit.dart';

import 'package:movie_discovery_app/features/home/profile_tab/domain/use_cases/profile_use_cases.dart';
import 'package:movie_discovery_app/features/home/profile_tab/presentation/view_models/profile_cubit.dart';

import 'package:movie_discovery_app/core/network/api_manager.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/data_sources/home_remote_data_source.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/repositories/home_repository_impl.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/repositories/home_repository.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/use_cases/home_use_cases.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/view_models/home_cubit.dart';
import 'package:movie_discovery_app/features/movie_details/data/data_sources/movie_details_remote_data_source.dart';
import 'package:movie_discovery_app/features/movie_details/data/repositories/movie_details_repository_impl.dart';
import 'package:movie_discovery_app/features/movie_details/domain/repositories/movie_details_repository.dart';
import 'package:movie_discovery_app/features/movie_details/domain/use_cases/get_movie_details_use_case.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/view_models/movie_details_cubit.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Auth Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<FirebaseAuth>()),
  );

  // Auth Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );

  // Auth Use Cases
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<ContinueAsGuestUseCase>(
    () => ContinueAsGuestUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<GoogleSignInUseCase>(
    () => GoogleSignInUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SendPasswordResetEmailUseCase>(
    () => SendPasswordResetEmailUseCase(getIt<AuthRepository>()),
  );

  // Profile Use Cases
  getIt.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );

  // Auth Cubits
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      registerUseCase: getIt(),
      loginUseCase: getIt(),
      continueAsGuestUseCase: getIt(),
      googleSignInUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
    ),
  );

  getIt.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(
      sendPasswordResetEmailUseCase: getIt<SendPasswordResetEmailUseCase>(),
    ),
  );

  // Network
  getIt.registerLazySingleton<ApiManager>(() => ApiManager());

  // Home Feature
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(getIt<ApiManager>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetTrendingMoviesUseCase>(
    () => GetTrendingMoviesUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetPopularMoviesUseCase>(
    () => GetPopularMoviesUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetTopRatedMoviesUseCase>(
    () => GetTopRatedMoviesUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetNowPlayingMoviesUseCase>(
    () => GetNowPlayingMoviesUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetUpcomingMoviesUseCase>(
    () => GetUpcomingMoviesUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetPopularPeopleUseCase>(
    () => GetPopularPeopleUseCase(getIt<HomeRepository>()),
  );
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(
      getTrendingMoviesUseCase: getIt<GetTrendingMoviesUseCase>(),
      getPopularMoviesUseCase: getIt<GetPopularMoviesUseCase>(),
      getTopRatedMoviesUseCase: getIt<GetTopRatedMoviesUseCase>(),
      getNowPlayingMoviesUseCase: getIt<GetNowPlayingMoviesUseCase>(),
      getUpcomingMoviesUseCase: getIt<GetUpcomingMoviesUseCase>(),
      getPopularPeopleUseCase: getIt<GetPopularPeopleUseCase>(),
    ),
  );

  // Movie Details Feature
  getIt.registerLazySingleton<MovieDetailsRemoteDataSource>(
    () => MovieDetailsRemoteDataSourceImpl(getIt<ApiManager>()),
  );
  getIt.registerLazySingleton<MovieDetailsRepository>(
    () => MovieDetailsRepositoryImpl(getIt<MovieDetailsRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetMovieDetailsUseCase>(
    () => GetMovieDetailsUseCase(getIt<MovieDetailsRepository>()),
  );
  getIt.registerFactory<MovieDetailsCubit>(
    () => MovieDetailsCubit(
      getMovieDetailsUseCase: getIt<GetMovieDetailsUseCase>(),
    ),
  );

  // Profile Cubit
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getProfileUseCase: getIt<GetProfileUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
    ),
  );

  // Settings Repository
  getIt.registerLazySingleton<SettingsRepository>(
    () => const SettingsRepositoryImpl(),
  );

  // Settings Use Cases
  getIt.registerLazySingleton<LoadSettingsUseCase>(
    () => LoadSettingsUseCase(getIt<SettingsRepository>()),
  );

  getIt.registerLazySingleton<SaveSettingsUseCase>(
    () => SaveSettingsUseCase(getIt<SettingsRepository>()),
  );

  // Settings Cubit
  getIt.registerFactory<SettingsCubit>(
    () => SettingsCubit(
      loadSettingsUseCase: getIt<LoadSettingsUseCase>(),
      saveSettingsUseCase: getIt<SaveSettingsUseCase>(),
    ),
  );
}
