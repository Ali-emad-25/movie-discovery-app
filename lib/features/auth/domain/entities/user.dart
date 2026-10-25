class User {
  final String id;
  final String email;
  final String? displayName;
  final bool isGuest;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.isGuest = false,
  });
}
