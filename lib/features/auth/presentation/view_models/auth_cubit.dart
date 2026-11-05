
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movie_discovery_app/core/errors/failures.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';

import 'package:movie_discovery_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/register_use_case.dart';
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
    if (isClosed || state is AuthLoading) return;

    emit(const AuthLoading());

    try {
      final user = await registerUseCase(
        name: name,
        email: email,
        password: password,
      );

      if (isClosed) return;

      emit(AuthSuccess(user));
    } catch (e) {
      if (isClosed) return;

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
    if (isClosed || state is AuthLoading) return;

    emit(const AuthLoading());

    final result = await loginUseCase(
      email: email,
      password: password,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccess(data: final user):
        emit(AuthLoginSuccess(user));

      case ApiError(failure: final failure):
        emit(AuthFailure(_errorMessage(failure)));
    }
  }

  Future<void> continueAsGuest() async {
    if (isClosed || state is AuthLoading) return;

    emit(const AuthLoading());

    final result = await loginUseCase.continueAsGuest();

    if (isClosed) return;

    switch (result) {
      case ApiSuccess(data: final user):
        emit(AuthLoginSuccess(user));

      case ApiError(failure: final failure):
        emit(AuthFailure(_errorMessage(failure)));
    }
  }

  String _errorMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'common.network_error';
    }

    if (failure.message.startsWith('auth.')) {
      return failure.message;
    }

    return 'auth.login_error';
  }
}
