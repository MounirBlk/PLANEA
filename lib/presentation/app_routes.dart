// ignore_for_file: unused_import
import 'package:go_router/go_router.dart';
import 'package:planea/presentation/pages/game/game.dart';
import 'package:planea/presentation/pages/multiplayer/lobby/multiplayer_lobby_page.dart';
import 'package:planea/presentation/pages/multiplayer/multiplayer_game_page.dart';
import 'package:planea/presentation/pages/singleplayer/singleplayer_game_page.dart';
import 'package:planea/presentation/pages/splash/splash_pages.dart';

class AppRoutes {
  static GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/', builder: (context, state) => const GamePage()),
      GoRoute(
        path: '/single_player',
        builder: (context, state) => const SinglePlayerGamePage(),
      ),
      GoRoute(
        path: '/lobby:matchId',
        builder: (context, state) => const MultiPlayerLobbyPage(),
      ),
      GoRoute(
        path: '/multi_player:matchId',
        builder: (context, state) => const MultiPlayerGamePage(),
      ),
    ],
  );
}
