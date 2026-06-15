import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/discover/discover_screen.dart';
import '../../presentation/sports/sports_home_screen.dart';
import '../../presentation/sports/match_detail_screen.dart';
import '../../presentation/live/live_home_screen.dart';
import '../../presentation/live/live_watch_screen.dart';
import '../../presentation/public_domain/pd_player_screen.dart';
import '../../presentation/auth/login_screen.dart';
import '../../presentation/profile/profile_screen.dart';
import '../../presentation/shared/layouts/main_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigator = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigator,
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/discover',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DiscoverScreen(),
          ),
        ),
        GoRoute(
          path: '/sports',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SportsHomeScreen(),
          ),
        ),
        GoRoute(
          path: '/live',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LiveHomeScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/sports/match/:id',
      parentNavigatorKey: _rootNavigator,
      builder: (context, state) => MatchDetailScreen(
        matchId: state.pathParameters['id'] ?? '',
        sport: state.uri.queryParameters['sport'] ?? 'football',
      ),
    ),
    GoRoute(
      path: '/live/watch/:id',
      parentNavigatorKey: _rootNavigator,
      builder: (context, state) => LiveWatchScreen(
        streamId: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: '/watch/:id',
      parentNavigatorKey: _rootNavigator,
      builder: (context, state) => PDPlayerScreen(
        videoId: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: '/auth/login',
      parentNavigatorKey: _rootNavigator,
      builder: (context, state) => const LoginScreen(),
    ),
  ],
);
