import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_discovery_app/core/errors/failures.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/account_settings/domain/entities/account_profile.dart';
import 'package:movie_discovery_app/features/account_settings/domain/use_cases/account_settings_use_cases.dart';
import 'package:movie_discovery_app/features/auth/domain/entities/user.dart';
import 'package:movie_discovery_app/features/profile/domain/use_cases/profile_use_cases.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final GetLocalAccountProfileUseCase getLocalAccountProfileUseCase;
  final LogoutUseCase logoutUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.getLocalAccountProfileUseCase,
    required this.logoutUseCase,
  }) : super(const ProfileInitial());

  Future<void> loadProfile() async {
    if (state is ProfileLoading) return;
    emit(const ProfileLoading());
    final result = await getProfileUseCase();
    if (isClosed) return;
    switch (result) {
      case ApiSuccess(data: final user):
        final localResult = await getLocalAccountProfileUseCase(
          userId: user.id,
        );
        if (isClosed) return;
        final localProfile = switch (localResult) {
          ApiSuccess(data: final profile) => profile,
          ApiError() => null,
        };
        emit(
          ProfileSuccess(
            localProfile == null ? user : _userWithProfile(user, localProfile),
          ),
        );
      case ApiError(failure: final failure):
        emit(
          ProfileFailure(
            failure is NetworkFailure ? 'common.network_error' : 'common.error',
          ),
        );
    }
  }

  Future<bool> logout() async {
    final current = state;

    final user = switch (current) {
      ProfileSuccess(user: final user) => user,
      ProfileFailure(user: final user) => user,
      _ => null,
    };

    if (user == null || current is ProfileSuccess && current.isLoggingOut) {
      return false;
    }

    emit(ProfileSuccess(user, isLoggingOut: true));

    final result = await logoutUseCase();

    if (isClosed) return false;

    switch (result) {
      case ApiSuccess():
        emit(const ProfileLoggedOut());
        return true;

      case ApiError(failure: final failure):
        emit(
          ProfileFailure(
            failure is NetworkFailure ? 'common.network_error' : 'common.error',
            user: user,
          ),
        );
        return false;
    }
  }

  User _userWithProfile(User user, AccountProfile profile) => User(
    id: user.id,
    email: profile.email.isNotEmpty ? profile.email : user.email,
    displayName: profile.displayName,
    photoUrl: profile.photoUrl ?? user.photoUrl,
    isGuest: user.isGuest,
  );
}
