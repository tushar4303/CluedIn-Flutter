import 'package:cluedin_app/screens/homescreen.dart';
import 'package:cluedin_app/screens/notification_detail.dart';
import 'package:cluedin_app/screens/notification_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, GoRouterState state) {
        return const NotificationPage();
      },
    ),
  ],
);
