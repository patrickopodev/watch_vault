import '../../domain/entities/user.dart';
import '../sources/remote/supabase_api.dart';
import '../sources/local/hive_storage.dart';

class UserRepository {
  final SupabaseApi _api;

  UserRepository(this._api);

  Future<AppUser?> signIn(String email, String password) async {
    return await _api.signIn(email, password);
  }

  Future<AppUser?> signUp(String email, String password) async {
    return await _api.signUp(email, password);
  }

  Future<void> signOut() async {
    await _api.signOut();
    await HiveStorage.clearAll();
  }

  AppUser? get currentUser => _api.currentUser;

  Future<bool> isLoggedIn() async {
    return _api.currentUser != null;
  }
}
