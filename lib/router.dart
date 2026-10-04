import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'data/db/database.dart';
import 'state/providers.dart';
import 'ui/celebration/celebration_screen.dart';
import 'ui/home/home_screen.dart';
import 'ui/parent/gate/gate_screen.dart';
import 'ui/parent/parent_home_screen.dart';
import 'ui/parent/rewards/reward_editor_screen.dart';
import 'ui/parent/rewards/rewards_screen.dart';
import 'ui/parent/routines/routine_editor_screen.dart';
import 'ui/parent/settings/settings_screen.dart';
import 'ui/parent/summary/daily_summary_screen.dart';
import 'ui/parent/tasks/task_editor_screen.dart';
import 'ui/parent/tasks/task_library_screen.dart';
import 'ui/task/task_screen.dart';

RoutineType _type(GoRouterState s) =>
    RoutineType.values.byName(s.pathParameters['type']!);

/// Task and celebration sit directly on top of Home, so back always lands on
/// Home (never from the celebration back into a finished routine).
/// Everything under /parent requires the gate; locking sends you home.
final routerProvider = Provider<GoRouter>((ref) {
  final unlocked = ValueNotifier(ref.read(parentSessionProvider));
  ref.listen(parentSessionProvider, (_, v) => unlocked.value = v);

  final router = GoRouter(
    refreshListenable: unlocked,
    redirect: (context, state) =>
        state.matchedLocation.startsWith('/parent') && !unlocked.value
        ? '/'
        : null,
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
          GoRoute(
            path: 'gate',
            builder: (context, state) => const GateScreen(),
          ),
          GoRoute(
            path: 'parent',
            builder: (context, state) => const ParentHomeScreen(),
            routes: [
              GoRoute(
                path: 'routine/:type',
                builder: (context, state) =>
                    RoutineEditorScreen(type: _type(state)),
              ),
              GoRoute(
                path: 'tasks',
                builder: (context, state) => const TaskLibraryScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (context, state) {
                      final routine = state.uri.queryParameters['routine'];
                      return TaskEditorScreen(
                        addToRoutine: routine == null
                            ? null
                            : RoutineType.values.byName(routine),
                      );
                    },
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => TaskEditorScreen(
                      taskId: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: 'rewards',
                builder: (context, state) => const RewardsScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const RewardEditorScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => RewardEditorScreen(
                      rewardId: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: 'summary',
                builder: (context, state) => const DailySummaryScreen(),
              ),
              GoRoute(
                path: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    unlocked.dispose();
  });
  return router;
});
