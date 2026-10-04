import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'data/db/database.dart';
import 'ui/celebration/celebration_screen.dart';
import 'ui/home/home_screen.dart';
import 'ui/task/task_screen.dart';

RoutineType _type(GoRouterState s) =>
    RoutineType.values.byName(s.pathParameters['type']!);

/// Task and celebration sit directly on top of Home, so back always lands on
/// Home (never from the celebration back into a finished routine).
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'routine/:type',
            builder: (context, state) => TaskScreen(type: _type(state)),
          ),
          GoRoute(
            path: 'celebrate/:type',
            builder: (context, state) => CelebrationScreen(type: _type(state)),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
