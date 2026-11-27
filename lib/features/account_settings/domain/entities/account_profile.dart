class AccountProfile {
  final String userId;
  final String displayName;
  final String email;
  final String? photoUrl;

  const AccountProfile({
    required this.userId,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });
}
