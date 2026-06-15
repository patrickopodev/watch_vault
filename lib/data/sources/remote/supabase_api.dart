import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/live_stream.dart';
import '../../models/sport_event_model.dart';

class SupabaseApi {
  final SupabaseClient _client;

  SupabaseApi(this._client);

  // Auth
  Future<AppUser?> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return _userFromResponse(response.user);
  }

  Future<AppUser?> signUp(String email, String password) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );
    return _userFromResponse(response.user);
  }

  Future<void> signOut() => _client.auth.signOut();

  AppUser? get currentUser {
    final user = _client.auth.currentUser;
    return _userFromResponse(user);
  }

  AppUser? _userFromResponse(User? user) {
    if (user == null) return null;
    return AppUser(
      id: user.id,
    );
  }

  // Live scores
  Future<List<SportEventModel>> getLiveScores() async {
    final response = await _client
        .from('live_scores')
        .select('*')
        .eq('status', 'live')
        .order('scraped_at', ascending: false);
    return (response as List<dynamic>)
        .map((e) => SportEventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Watchlist
  Future<void> addToWatchlist({
    required String contentId,
    required String contentType,
    required String title,
    String? posterUrl,
  }) async {
    await _client.from('watchlist').insert({
      'user_id': _client.auth.currentUser!.id,
      'content_id': contentId,
      'content_type': contentType,
      'title': title,
      'poster_url': posterUrl,
    });
  }

  Future<void> removeFromWatchlist(String contentId) async {
    await _client
        .from('watchlist')
        .delete()
        .eq('user_id', _client.auth.currentUser!.id)
        .eq('content_id', contentId);
  }

  Future<List<Map<String, dynamic>>> getWatchlist() async {
    final response = await _client
        .from('watchlist')
        .select('*')
        .eq('user_id', _client.auth.currentUser!.id);
    return (response as List<dynamic>).cast<Map<String, dynamic>>();
  }

  // Profile
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .single();
    return response as Map<String, dynamic>?;
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    await _client
        .from('profiles')
        .update(updates)
        .eq('id', _client.auth.currentUser!.id);
  }

  // Live streams
  Future<List<LiveStream>> getLiveStreams() async {
    final response = await _client
        .from('live_streams')
        .select('*, creator:profiles!creator_id(username, avatar_url)')
        .eq('is_live', true)
        .order('viewer_count', ascending: false);
    return (response as List<dynamic>)
        .map((e) => _streamFromJson(e as Map<String, dynamic>))
        .toList();
  }

  LiveStream _streamFromJson(Map<String, dynamic> json) {
    final creator = json['creator'] as Map<String, dynamic>?;
    return LiveStream(
      id: json['id'] as String,
      creatorId: json['creator_id'] as String,
      creatorName: creator?['username'] as String? ?? 'Unknown',
      creatorAvatar: creator?['avatar_url'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      category: json['category'] as String? ?? 'general',
      isLive: json['is_live'] as bool? ?? false,
      viewerCount: json['viewer_count'] as int? ?? 0,
      startedAt: DateTime.parse(json['started_at'] as String),
    );
  }
}
