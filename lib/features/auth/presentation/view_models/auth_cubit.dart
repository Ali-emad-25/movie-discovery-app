import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;

  AuthCubit({
    required this.registerUseCase,
    required this.loginUseCase,
  }) : super(const AuthInitial());

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      final user = await registerUseCase(
        name: name,
        email: email,
        password: password,
      );

      emit(AuthSuccess(user));
    } catch (e) {
      emit(
        const AuthFailure(
          'Registration failed. Please try again.',
        ),
      );
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      final user = await loginUseCase(
        email: email,
        password: password,
      );

      emit(AuthSuccess(user));
    } catch (e) {
      emit(
        const AuthFailure(
          'Login failed. Please check your email and password.',
        ),
      );
    }
  }
}