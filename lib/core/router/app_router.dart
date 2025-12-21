import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:safeguard_ai/core/init/injection_container.dart' as di;
import 'package:safeguard_ai/features/analysis/presentation/bloc/analysis_bloc.dart';
import 'package:safeguard_ai/features/analysis/presentation/pages/analysis_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (context) => di.sl<AnalysisBloc>(),
          child: const AnalysisPage(),
        ),
      ),
    ],
  );
}
