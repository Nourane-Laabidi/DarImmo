import 'package:go_router/go_router.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/admin_login_screen.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/admin/admin_screen.dart';
import '../features/home/home_screen.dart';
import '../features/results/results_screen.dart';
import '../features/detail/detail_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/publish/publish_screen.dart';
import '../features/map/map_screen.dart';
import '../features/messaging/messages_screen.dart';
import '../features/messaging/chat_screen.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
        path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(
        path: '/admin-login',
        builder: (context, state) => const AdminLoginScreen()),
    GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen()),
    GoRoute(path: '/admin', builder: (context, state) => const AdminScreen()),
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/results',
      builder: (context, state) => ResultsScreen(
        mode: state.uri.queryParameters['mode'] ?? 'sale',
        query: state.uri.queryParameters['q'] ?? '',
        initialType: state.uri.queryParameters['type'] ?? '',
        openFilters: state.uri.queryParameters['filters'] == '1',
      ),
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) => DetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen()),
    GoRoute(
        path: '/profil', builder: (context, state) => const ProfileScreen()),
    GoRoute(
        path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(
        path: '/notifications',
        builder: (context, state) => const ProfileScreen()),
    GoRoute(
        path: '/my-listings',
      builder: (context, state) => const ProfileScreen()),
    GoRoute(
        path: '/publish', builder: (context, state) => const PublishScreen()),
    GoRoute(path: '/map', builder: (context, state) => const MapScreen()),
    GoRoute(
        path: '/messages',
        builder: (context, state) => const MessagesScreen()),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) =>
          ChatScreen(conversationId: state.pathParameters['id']!),
    ),
  ],
);