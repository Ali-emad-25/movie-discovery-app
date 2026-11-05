import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movie_discovery_app/core/errors/failures.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/continue_as_guest_use_case.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/get_current_user_use_case.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/google_sign_in_use_case.dart';

import 'package:movie_discovery_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/login_use_case.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final ContinueAsGuestUseCase continueAsGuestUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthCubit({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.continueAsGuestUseCase,
    required this.googleSignInUseCase,
    required this.getCurrentUserUseCase,
  }) : super(const AuthInitial());

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (isClosed || state is AuthLoading) return;

    emit(const AuthLoading());

    try {
      final result = await registerUseCase(
        name: name.trim(),
        email: email.trim(),
        password: password,
      );

      if (isClosed) return;

      switch (result) {
        case ApiSuccess(data: final user):
          emit(AuthSuccess(user));

        case ApiError(failure: final failure):
          emit(AuthFailure(_errorMessage(failure)));
      }
    } catch (_) {
      if (!isClosed) {
        emit(const AuthFailure('errors.unknown_error'));
      }
    }
  }

  Future<void> login({required String email, required String password}) async {
    if (isClosed || state is AuthLoading) return;

    emit(const AuthLoading());

    try {
      final result = await loginUseCase(
        email: email.trim(),
        password: password,
      );

      if (isClosed) return;

      switch (result) {
        case ApiSuccess(data: final user):
          emit(AuthLoginSuccess(user));

        case ApiError(failure: final failure):
          emit(AuthFailure(_errorMessage(failure)));
      }
    } catch (_) {
      if (!isClosed) {
        emit(const AuthFailure('errors.unknown_error'));
      }
    }
  }

  Future<void> continueAsGuest() async {
    if (isClosed || state is AuthLoading) return;

    emit(const AuthLoading());

    try {
      final result = await continueAsGuestUseCase();

      if (isClosed) return;

      switch (result) {
        case ApiSuccess(data: final user):
          emit(AuthLoginSuccess(user));

        case ApiError(failure: final failure):
          emit(AuthFailure(_errorMessage(failure)));
      }
    } catch (_) {
      if (!isClosed) {
        emit(const AuthFailure('errors.unknown_error'));
      }
    }
  }

  Future<void> signInWithGoogle({required bool isRegister}) async {
    if (isClosed || state is AuthLoading) return;

    emit(const AuthLoading());

    try {
      final result = await googleSignInUseCase();

      if (isClosed) return;

      switch (result) {
        case ApiSuccess(data: final user):
          if (isRegister) {
            emit(AuthSuccess(user));
          } else {
            emit(AuthLoginSuccess(user));
          }

        case ApiError(failure: final failure):
          if (failure is GoogleSignInCancelledFailure) {
            emit(const AuthInitial());
            return;
          }

          emit(AuthFailure(_errorMessage(failure)));
      }
    } catch (_) {
      if (!isClosed) {
        emit(const AuthFailure('errors.unknown_error'));
      }
    }
  }

  Future<void> restoreSession() async {
    if (isClosed) return;

    try {
      final result = await getCurrentUserUseCase();

      if (isClosed) return;

      switch (result) {
        case ApiSuccess(data: final user):
          if (user == null) {
            emit(const AuthInitial());
          } else {
            emit(AuthLoginSuccess(user));
          }

        case ApiError(failure: final failure):
          emit(AuthFailure(_errorMessage(failure)));
      }
    } catch (_) {
      if (!isClosed) {
        emit(const AuthFailure('errors.unknown_error'));
      }
    }
  }

  String _errorMessage(Failure failure) {
    if (failure is GoogleSignInCancelledFailure) {
      return '';
    }

    if (failure is NetworkFailure) {
      return 'errors.network_error';
    }

    if (failure is AuthErrorFailure) {
      return failure.message;
    }

    return 'errors.unknown_error';
  }
}
