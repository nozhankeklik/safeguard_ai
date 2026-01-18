import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../init/injection_container.dart' as di;
import '../../features/analysis/data/models/report_hive_model.dart';
import '../../features/analysis/domain/entities/analysis_entity.dart';
import '../../features/analysis/presentation/bloc/analysis_bloc.dart';
import '../../features/analysis/presentation/pages/analysis_page.dart';
import '../../features/analysis/presentation/pages/report_detail_page.dart';
import '../../features/analysis/presentation/pages/report_preview_page.dart';
import '../../features/history/presentation/bloc/history_bloc.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/main_shell_page.dart';
import 'package:safeguard_ai/features/intro/splash_page.dart'; // EĞER DOSYA YOLUN FARKLIYSA BURAYI DÜZELT
import '../../features/settings/presentation/pages/settings_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    // 1. DEĞİŞİKLİK: Başlangıç rotası artık Splash ('/')
    initialLocation: '/',

    routes: [
      // 2. DEĞİŞİKLİK: Splash Rotası (ShellRoute'un DIŞINA eklendi)
      // Böylece giriş ekranında alt navigasyon barı görünmeyecek.
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),

      // Mevcut Ana Uygulama İskeleti (Bottom Navigation Bar)
      ShellRoute(
        builder: (context, state, child) {
          return MainShellPage(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: '/analyze',
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(create: (context) => di.sl<AnalysisBloc>(), child: const AnalysisPage()),
            ),
          ),
          GoRoute(
            path: '/history',
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(create: (context) => di.sl<HistoryBloc>(), child: const HistoryPage()),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(child: SettingsPage()),
          ),
          // Not: Preview ve Detail sayfaları Shell içinde bırakıldı.
          // Eğer bu sayfalarda alt barın görünmesini istemiyorsan,
          // bunları da ShellRoute'un dışına (Splash'in yanına) taşıyabilirsin.
          // Şimdilik mevcut yapını bozmadım.
          GoRoute(
            path: '/report-preview',
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              if (extra == null) {
                return const NoTransitionPage(child: HomePage());
              }
              final analysis = extra['analysis'] as AnalysisEntity;
              final imagePath = extra['imagePath'] as String;
              return NoTransitionPage(
                child: ReportPreviewPage(analysis: analysis, imagePath: imagePath),
              );
            },
          ),
          GoRoute(
            path: '/report-detail',
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              if (extra == null) {
                return const NoTransitionPage(child: HomePage());
              }
              final report = extra['report'] as ReportHiveModel;
              return NoTransitionPage(child: ReportDetailPage(report: report));
            },
          ),
        ],
      ),
    ],
  );
}
