import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/discover/discover_screen.dart';
import '../../presentation/sports/sports_home_screen.dart';
import '../../presentation/sports/match_detail/match_detail_screen.dart';
import '../../presentation/live/live_home_screen.dart';
import '../../presentation/live/live_watch_screen.dart';
import '../../presentation/public_domain/pd_player_screen.dart';
import '../../presentation/auth/login_screen.dart';
import '../../presentation/profile/profile_screen.dart';
import '../../presentation/shared/layouts/main_scaffold.dart';
import '../navigation/route_names.dart';

final GlobalKey<NavigatorState> _rootNavigator = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigator,
  initialLocation: RouteNames.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: RouteNames.home,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: RouteNames.discover,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DiscoverScreen(),
          ),
        ),
        GoRoute(
          path: RouteNames.sports,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SportsHomeScreen(),
          ),
        ),
        GoRoute(
          path: RouteNames.live,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LiveHomeScreen(),
          ),
        ),
        GoRoute(
          path: RouteNames.profile,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: RouteNames.matchDetail,
      parentNavigatorKey: _rootNavigator,
      builder: (context, state) => MatchDetailScreen(
        matchId: state.pathParameters['id'] ?? '',
        sport: state.uri.queryParameters['sport'] ?? 'football',
      ),
    ),
    GoRoute(
      path: RouteNames.liveWatch,
      parentNavigatorKey: _rootNavigator,
      builder: (context, state) => LiveWatchScreen(
        streamId: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: RouteNames.watch,
      parentNavigatorKey: _rootNavigator,
      builder: (context, state) => PDPlayerScreen(
        videoId: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: RouteNames.login,
      parentNavigatorKey: _rootNavigator,
      builder: (context, state) => const LoginScreen(),
    ),
  ],
);
