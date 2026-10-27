import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/auth/domain/use_cases/send_password_reset_email_use_case.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;

  ForgotPasswordCubit({
    required this.sendPasswordResetEmailUseCase,
  }) : super(const ForgotPasswordInitial());

  Future<void> sendPasswordResetEmail({required String email}) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      emit(const ForgotPasswordFailure('Please enter your email address.'));
      return;
    }

    emit(const ForgotPasswordLoading());

    final result = await sendPasswordResetEmailUseCase(email: trimmedEmail);

    switch (result) {
      case ApiSuccess():
        emit(ForgotPasswordSuccess(trimmedEmail));
      case ApiError(failure: final failure):
        emit(ForgotPasswordFailure(failure.message));
    }
  }

  void reset() {
    emit(const ForgotPasswordInitial());
  }
}
