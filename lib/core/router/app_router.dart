import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:safeguard_ai/core/init/injection_container.dart' as di;
import 'package:safeguard_ai/features/analysis/presentation/bloc/analysis_bloc.dart';
import 'package:safeguard_ai/features/analysis/presentation/pages/analysis_page.dart';
import 'package:safeguard_ai/features/history/presentation/bloc/history_bloc.dart';
import 'package:safeguard_ai/features/history/presentation/pages/history_page.dart';
import 'package:safeguard_ai/features/home/presentation/pages/home_page.dart';
import 'package:safeguard_ai/features/home/presentation/pages/main_shell_page.dart';
import 'package:safeguard_ai/features/settings/presentation/pages/settings_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainShellPage(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: '/analyze',
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(
                create: (context) => di.sl<AnalysisBloc>(),
                child: const AnalysisPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/history',
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(
                create: (context) => di.sl<HistoryBloc>(),
                child: const HistoryPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsPage(),
            ),
          ),
        ],
      ),
    ],
  );
}
