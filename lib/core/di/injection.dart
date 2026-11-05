
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'package:movie_discovery_app/core/utils/settings_cubit.dart';
import 'package:movie_discovery_app/core/utils/settings_repository_impl.dart';
import 'package:movie_discovery_app/core/utils/settings_use_cases.dart';

import 'package:movie_discovery_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:movie_discovery_app/features/auth/data/data_sources/auth_remote_data_source_impl.dart';
import 'package:movie_discovery_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:movie_discovery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/send_password_reset_email_use_case.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_cubit.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/forgot_password_cubit.dart';

import 'package:movie_discovery_app/features/profile/domain/use_cases/profile_use_cases.dart';
import 'package:movie_discovery_app/features/profile/presentation/view_models/profile_cubit.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(
        () => FirebaseAuth.instance,
  );

  // Auth Data Source
  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(getIt<FirebaseAuth>()),
  );

  // Auth Repository
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );

  // Settings Repository
  getIt.registerLazySingleton<SettingsRepository>(
        () => const SettingsRepositoryImpl(),
  );

  // Auth Use Cases
  getIt.registerLazySingleton<RegisterUseCase>(
        () => RegisterUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
        () => LoginUseCase(getIt<AuthRepository>()),
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

  // Settings Use Cases
  getIt.registerLazySingleton<LoadSettingsUseCase>(
        () => LoadSettingsUseCase(getIt<SettingsRepository>()),
  );

  getIt.registerLazySingleton<SaveSettingsUseCase>(
        () => SaveSettingsUseCase(getIt<SettingsRepository>()),
  );

  // Cubits
  getIt.registerLazySingleton<SettingsCubit>(
        () => SettingsCubit(
      loadSettingsUseCase: getIt<LoadSettingsUseCase>(),
      saveSettingsUseCase: getIt<SaveSettingsUseCase>(),
    ),
  );

  getIt.registerFactory<ProfileCubit>(
        () => ProfileCubit(
      getProfileUseCase: getIt<GetProfileUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
    ),
  );

  getIt.registerFactory<AuthCubit>(
        () => AuthCubit(
      registerUseCase: getIt<RegisterUseCase>(),
      loginUseCase: getIt<LoginUseCase>(),
    ),
  );

  getIt.registerFactory<ForgotPasswordCubit>(
        () => ForgotPasswordCubit(
      sendPasswordResetEmailUseCase:
      getIt<SendPasswordResetEmailUseCase>(),
    ),
  );
}
