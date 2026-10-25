import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_discovery_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:movie_discovery_app/features/auth/data/data_sources/auth_remote_data_source_impl.dart';
import 'package:movie_discovery_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:movie_discovery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_cubit.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Data Source
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<FirebaseAuth>()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );

  // Use Case
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<AuthRepository>()),
  );

  // Cubit
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(registerUseCase: getIt<RegisterUseCase>()),
  );
}
