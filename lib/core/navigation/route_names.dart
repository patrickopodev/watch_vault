class RouteNames {
  RouteNames._();

  static const String home = '/';
  static const String discover = '/discover';
  static const String sports = '/sports';
  static const String live = '/live';
  static const String profile = '/profile';
  static const String matchDetail = '/sports/match/:id';
  static const String liveWatch = '/live/watch/:id';
  static const String watch = '/watch/:id';
  static const String login = '/auth/login';

  static String matchDetailWith(String matchId, {String? sport}) =>
      '/sports/match/$matchId${sport != null ? '?sport=$sport' : ''}';
  static String liveWatchWith(String streamId) => '/live/watch/$streamId';
  static String watchWith(String videoId) => '/watch/$videoId';
}
