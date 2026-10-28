class User {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool isGuest;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.isGuest = false,
  });

  const User.guest()
    : id = 'guest',
      email = '',
      displayName = null,
      photoUrl = null,
      isGuest = true;
}
