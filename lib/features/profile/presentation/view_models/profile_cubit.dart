import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';

import '../../../../core/network/api_result.dart';
import '../../domain/use_cases/profile_use_cases.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final LogoutUseCase logoutUseCase;

  ProfileCubit({required this.getProfileUseCase, required this.logoutUseCase})
    : super(const ProfileInitial());

  Future<void> loadProfile() async {
    if (state is ProfileLoading) return;
    emit(const ProfileLoading());
    final result = await getProfileUseCase();
    if (isClosed) return;
    switch (result) {
      case ApiSuccess(data: final user):
        emit(ProfileSuccess(user));
      case ApiError(failure: final failure):
        emit(
          ProfileFailure(
            failure is NetworkFailure ? 'common.network_error' : 'common.error',
          ),
        );
    }
  }

  Future<void> logout() async {
    final current = state;
    final user = switch (current) {
      ProfileSuccess(user: final user) => user,
      ProfileFailure(user: final user) => user,
      _ => null,
    };
    if (user == null || current is ProfileSuccess && current.isLoggingOut) {
      return;
    }
    emit(ProfileSuccess(user, isLoggingOut: true));
    final result = await logoutUseCase();
    if (isClosed) return;
    switch (result) {
      case ApiSuccess():
        emit(const ProfileLoggedOut());
      case ApiError(failure: final failure):
        emit(
          ProfileFailure(
            failure is NetworkFailure ? 'common.network_error' : 'common.error',
            user: user,
          ),
        );
    }
  }
}
