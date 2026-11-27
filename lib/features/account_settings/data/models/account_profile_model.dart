import 'package:movie_discovery_app/features/account_settings/domain/entities/account_profile.dart';

class AccountProfileModel extends AccountProfile {
  const AccountProfileModel({
    required super.userId,
    required super.displayName,
    required super.email,
    super.photoUrl,
  });

  factory AccountProfileModel.fromMap(Map<String, Object?> map) =>
      AccountProfileModel(
        userId: map['user_id']! as String,
        displayName: map['display_name']! as String,
        email: map['email']! as String,
        photoUrl: map['photo_url'] as String?,
      );

  Map<String, Object?> toMap() => {
    'user_id': userId,
    'display_name': displayName,
    'email': email,
    'photo_url': photoUrl,
  };
}
