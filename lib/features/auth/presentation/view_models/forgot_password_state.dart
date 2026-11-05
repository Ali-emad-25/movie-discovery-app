sealed class ForgotPasswordState {
  const ForgotPasswordState();
}

final class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

final class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading();
}

final class ForgotPasswordSuccess extends ForgotPasswordState {
  final String email;
  const ForgotPasswordSuccess(this.email);
}

final class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;
  const ForgotPasswordFailure(this.message);
}
