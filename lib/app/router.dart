import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/friends/friends_screen.dart';
import '../presentation/screens/lobby/lobby_list_screen.dart';
import '../presentation/screens/lobby/lobby_room_screen.dart';
import '../presentation/screens/game/game_screen.dart';
import '../presentation/screens/card_draw/card_draw_screen.dart';
import '../presentation/screens/card_draw/card_draw_result_screen.dart';

/// Router configuration for the app
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      // If not logged in and trying to access protected route, redirect to login
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      // If logged in and on login/register page, redirect to home
      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/friends',
        name: 'friends',
        builder: (context, state) => const FriendsScreen(),
      ),
      GoRoute(
        path: '/lobby',
        name: 'lobby',
        builder: (context, state) => const LobbyListScreen(),
      ),
      GoRoute(
        path: '/lobby/:id',
        name: 'lobby-room',
        builder: (context, state) {
          final lobbyId = state.pathParameters['id']!;
          return LobbyRoomScreen(lobbyId: lobbyId);
        },
      ),
      GoRoute(
        path: '/card-draw/:lobbyId',
        name: 'card-draw',
        builder: (context, state) {
          final lobbyId = state.pathParameters['lobbyId']!;
          return CardDrawScreen(lobbyId: lobbyId);
        },
      ),
      GoRoute(
        path: '/card-draw-result/:lobbyId',
        name: 'card-draw-result',
        builder: (context, state) {
          final lobbyId = state.pathParameters['lobbyId']!;
          return CardDrawResultScreen(lobbyId: lobbyId);
        },
      ),
      GoRoute(
        path: '/game/:id',
        name: 'game',
        builder: (context, state) {
          final gameId = state.pathParameters['id']!;
          return GameScreen(gameId: gameId);
        },
      ),
      // Future routes will go here:
      // - /profile
      // - /stats
    ],
  );
});
