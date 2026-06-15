class AppUser {
  final String id;
  final String? username;
  final String? displayName;
  final String? avatarUrl;
  final String? bio;
  final String? favoriteTeam;
  final List<String> favoriteLeagues;
  final DateTime? createdAt;

  const AppUser({
    required this.id,
    this.username,
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.favoriteTeam,
    this.favoriteLeagues = const [],
    this.createdAt,
  });

  bool get isLoggedIn => id.isNotEmpty;
}
