/// Represents the app user.
class AppUser {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;

  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
  });
}
