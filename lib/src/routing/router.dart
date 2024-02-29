import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport/src/features/data/presentation/data_screent.dart';
import 'package:sport/src/features/home/presentation/home_screen.dart';
import 'package:sport/src/features/match_detail/presentation/football_match_detail_screen.dart';
import 'package:sport/src/features/mine/presentation/mine_screen.dart';
import 'package:sport/src/features/player_detail/presentation/football_player_detail_screen.dart';
import 'package:sport/src/features/schedule/presentation/schedule_screen.dart';
import 'package:sport/src/features/team_detail/presentation/football_team_detail_screen.dart';

final goRouter = GoRouter(initialLocation: "/home", routes: [
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return ScaffoldWithNavigation(navigationShell: navigationShell);
    },
    branches: [
      StatefulShellBranch(routes: [
        GoRoute(
            path: "/home",
            pageBuilder: (context, state) =>
                NoTransitionPage(child: HomeScreen()))
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: "/schedule",
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ScheduleScreen()),
        )
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: "/data",
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: DataScreen()),
        )
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: "/mine",
          pageBuilder: (context, state) =>
              NoTransitionPage(child: MineScreen()),
        )
      ])
    ],
  ),
  GoRoute(
    path: "/football/match",
    pageBuilder: (context, state) => const NoTransitionPage(
      child: Scaffold(
        body: FootballMatchDetailScreen(),
      ),
    ),
  ),
  GoRoute(
    path: "/football/team/:teamId",
    pageBuilder: (context, state) => const NoTransitionPage(
      child: Scaffold(
        body: FootballTeamDetailScreen(),
      ),
    ),
  ),
  GoRoute(
    path: "/football/player/:playerId",
    pageBuilder: (context, state) => const NoTransitionPage(
      child: Scaffold(
        body: FootballPlayerDetailScreen(),
      ),
    ),
  ),
]);

class ScaffoldWithNavigation extends StatelessWidget {
  const ScaffoldWithNavigation({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: "首页"),
          NavigationDestination(
              icon: Icon(Icons.date_range_outlined), label: "赛程"),
          NavigationDestination(
              icon: Icon(Icons.insert_chart_outlined_outlined), label: "数据"),
          NavigationDestination(icon: Icon(Icons.person_outline), label: "我的"),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}
