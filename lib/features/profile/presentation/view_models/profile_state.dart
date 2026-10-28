import '../../../auth/domain/entities/user.dart';

sealed class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileSuccess extends ProfileState {
  final User user;
  final bool isLoggingOut;
  const ProfileSuccess(this.user, {this.isLoggingOut = false});
}

final class ProfileFailure extends ProfileState {
  final String message;
  final User? user;
  const ProfileFailure(this.message, {this.user});
}

final class ProfileLoggedOut extends ProfileState {
  const ProfileLoggedOut();
}
