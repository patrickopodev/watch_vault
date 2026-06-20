class ApiEndpoints {
  ApiEndpoints._();

  static const String cacheWorkerBase = 'https://watchvault-proxy.patrickopo-dev.workers.dev';

  static const String theSportsDbBase = 'https://www.thesportsdb.com/api/v1/json/3';

  static const String tmdbBase = 'https://api.themoviedb.org/3';

  static const String internetArchiveBase = 'https://archive.org';

  static const String justwatchBase = 'https://apis.justwatch.com/content';

  static String liveScores({String? sport, String? league}) {
    final params = <String, String>{'origin': 'supabase', 'table': 'live_scores'};
    if (sport != null) params['sport'] = sport;
    if (league != null) params['league'] = league;
    return Uri.https(
      Uri.parse(cacheWorkerBase).host,
      '/',
      params,
    ).toString();
  }

  static String searchMovies(String query) {
    return '$cacheWorkerBase?origin=tmdb&endpoint=search/movie&query=$query';
  }

  static String sportsTeams(String sport) {
    return '$cacheWorkerBase?origin=thesportsdb&endpoint=searchteams&t=$sport';
  }

  static String standings({String? league}) {
    final params = <String, String>{'origin': 'supabase', 'table': 'standings'};
    if (league != null) params['league'] = league;
    return Uri.https(
      Uri.parse(cacheWorkerBase).host,
      '/',
      params,
    ).toString();
  }
}
