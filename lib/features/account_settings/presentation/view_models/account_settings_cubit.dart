import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/account_settings/domain/entities/account_profile.dart';
import 'package:movie_discovery_app/features/account_settings/domain/use_cases/account_settings_use_cases.dart';
import 'package:movie_discovery_app/features/account_settings/presentation/view_models/account_settings_state.dart';
import 'package:movie_discovery_app/features/auth/domain/entities/user.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  final GetLocalAccountProfileUseCase getLocalAccountProfileUseCase;
  final SaveLocalAccountProfileUseCase saveLocalAccountProfileUseCase;
  final DeleteLocalAccountProfileUseCase deleteLocalAccountProfileUseCase;
  final ChangeAccountPasswordUseCase changePasswordUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  AccountSettingsCubit({
    required User user,
    required this.getLocalAccountProfileUseCase,
    required this.saveLocalAccountProfileUseCase,
    required this.deleteLocalAccountProfileUseCase,
    required this.changePasswordUseCase,
    required this.deleteAccountUseCase,
  }) : super(AccountSettingsState(user: user));

  Future<void> loadProfile() async {
    final result = await getLocalAccountProfileUseCase(userId: state.user.id);
    if (isClosed) return;

    switch (result) {
      case ApiSuccess(data: final profile):
        if (profile != null) {
          emit(state.copyWith(user: _userWithProfile(state.user, profile)));
        } else {
          final initialProfile = AccountProfile(
            userId: state.user.id,
            displayName: state.user.displayName ?? '',
            email: state.user.email,
            photoUrl: state.user.photoUrl,
          );
          final saveResult = await saveLocalAccountProfileUseCase(
            profile: initialProfile,
          );
          if (isClosed) return;
          switch (saveResult) {
            case ApiSuccess(data: final savedProfile):
              emit(
                state.copyWith(
                  user: _userWithProfile(state.user, savedProfile),
                ),
              );
            case ApiError(failure: final failure):
              emit(state.copyWith(errorMessage: failure.message));
          }
        }
      case ApiError():
        return;
    }
  }

  Future<bool> updateDisplayName(String displayName) async {
    if (state.isBusy) return false;
    emit(
      state.copyWith(
        isSavingProfile: true,
        clearError: true,
        clearSuccess: true,
      ),
    );

    final result = await saveLocalAccountProfileUseCase(
      profile: AccountProfile(
        userId: state.user.id,
        displayName: displayName.trim(),
        email: state.user.email,
        photoUrl: state.user.photoUrl,
      ),
    );
    if (isClosed) return false;

    switch (result) {
      case ApiSuccess(data: final user):
        emit(
          state.copyWith(
            user: _userWithProfile(state.user, user),
            isSavingProfile: false,
            successMessage: 'account_settings.profile_updated',
          ),
        );
        return true;
      case ApiError(failure: final failure):
        emit(
          state.copyWith(isSavingProfile: false, errorMessage: failure.message),
        );
        return false;
    }
  }

  Future<bool> updateProfilePhoto(String photoPath) async {
    if (state.isBusy) return false;
    emit(
      state.copyWith(
        isSavingProfile: true,
        clearError: true,
        clearSuccess: true,
      ),
    );

    final result = await saveLocalAccountProfileUseCase(
      profile: AccountProfile(
        userId: state.user.id,
        displayName: state.user.displayName ?? '',
        email: state.user.email,
        photoUrl: photoPath,
      ),
    );
    if (isClosed) return false;

    switch (result) {
      case ApiSuccess(data: final profile):
        emit(
          state.copyWith(
            user: _userWithProfile(state.user, profile),
            isSavingProfile: false,
            successMessage: 'account_settings.profile_updated',
          ),
        );
        return true;
      case ApiError(failure: final failure):
        emit(
          state.copyWith(isSavingProfile: false, errorMessage: failure.message),
        );
        return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (state.isBusy) return false;
    emit(
      state.copyWith(
        isChangingPassword: true,
        clearError: true,
        clearSuccess: true,
      ),
    );

    final result = await changePasswordUseCase(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    if (isClosed) return false;

    switch (result) {
      case ApiSuccess():
        emit(
          state.copyWith(
            isChangingPassword: false,
            successMessage: 'account_settings.password_changed',
          ),
        );
        return true;
      case ApiError(failure: final failure):
        emit(
          state.copyWith(
            isChangingPassword: false,
            errorMessage: failure.message,
          ),
        );
        return false;
    }
  }

  Future<bool> deleteAccount({required String currentPassword}) async {
    if (state.isBusy) return false;
    emit(
      state.copyWith(
        isDeletingAccount: true,
        clearError: true,
        clearSuccess: true,
      ),
    );

    final result = await deleteAccountUseCase(currentPassword: currentPassword);
    if (isClosed) return false;

    switch (result) {
      case ApiSuccess():
        await deleteLocalAccountProfileUseCase(userId: state.user.id);
        if (isClosed) return false;
        emit(state.copyWith(isDeletingAccount: false, isDeleted: true));
        return true;
      case ApiError(failure: final failure):
        emit(
          state.copyWith(
            isDeletingAccount: false,
            errorMessage: failure.message,
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
