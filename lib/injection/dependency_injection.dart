import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/sources/remote/sports_api.dart';
import '../data/sources/remote/tmdb_api.dart';
import '../data/sources/remote/supabase_api.dart';
import '../data/sources/local/hive_storage.dart';
import '../data/repositories/sports_repository.dart';
import '../data/repositories/movie_repository.dart';
import '../data/repositories/user_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await HiveStorage.init();

  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ));

  sl.registerLazySingleton<Dio>(() => dio);

  final supabase = Supabase.instance;
  sl.registerLazySingleton<SupabaseClient>(() => supabase.client);

  // APIs
  sl.registerLazySingleton<SportsApi>(() => SportsApi(dio));
  sl.registerLazySingleton<TmdbApi>(() => TmdbApi(dio, 'a7c728097c04beaa760302dc37f33c81'));
  sl.registerLazySingleton<SupabaseApi>(() => SupabaseApi(supabase.client));

  // Repositories
  sl.registerLazySingleton<SportsRepository>(() => SportsRepository(sl()));
  sl.registerLazySingleton<MovieRepository>(() => MovieRepository(sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepository(sl()));
}
