import 'package:movie_discovery_app/features/auth/domain/entities/user.dart';

class AccountSettingsState {
  final User user;
  final bool isSavingProfile;
  final bool isChangingPassword;
  final bool isDeletingAccount;
  final bool isDeleted;
  final String? errorMessage;
  final String? successMessage;

  const AccountSettingsState({
    required this.user,
    this.isSavingProfile = false,
    this.isChangingPassword = false,
    this.isDeletingAccount = false,
    this.isDeleted = false,
    this.errorMessage,
    this.successMessage,
  });

  bool get isBusy => isSavingProfile || isChangingPassword || isDeletingAccount;

  AccountSettingsState copyWith({
    User? user,
    bool? isSavingProfile,
    bool? isChangingPassword,
    bool? isDeletingAccount,
    bool? isDeleted,
    String? errorMessage,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
  }) => AccountSettingsState(
    user: user ?? this.user,
    isSavingProfile: isSavingProfile ?? this.isSavingProfile,
    isChangingPassword: isChangingPassword ?? this.isChangingPassword,
    isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
    isDeleted: isDeleted ?? this.isDeleted,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    successMessage: clearSuccess ? null : successMessage ?? this.successMessage,
  );
}
