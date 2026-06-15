import 'package:go_router/go_router.dart';
import 'route_names.dart';

class NavigationService {
  final GoRouter router;

  NavigationService(this.router);

  void goHome() => router.go(RouteNames.home);
  void goDiscover() => router.go(RouteNames.discover);
  void goSports() => router.go(RouteNames.sports);
  void goLive() => router.go(RouteNames.live);
  void goProfile() => router.go(RouteNames.profile);
  void goMatchDetail(String matchId, {String? sport}) =>
      router.go(RouteNames.matchDetailWith(matchId, sport: sport));
  void goLiveWatch(String streamId) =>
      router.go(RouteNames.liveWatchWith(streamId));
  void goWatch(String videoId) =>
      router.go(RouteNames.watchWith(videoId));
  void goLogin() => router.go(RouteNames.login);
}
