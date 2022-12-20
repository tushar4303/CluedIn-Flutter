import 'package:cluedin_app/screens/homescreen.dart';
import 'package:cluedin_app/screens/notification_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, GoRouterState state) {
        return const NotificationPage();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
  ],
);
