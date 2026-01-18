import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:safeguard_ai/core/init/injection_container.dart' as di;
import 'package:safeguard_ai/core/router/app_router.dart';
import 'package:safeguard_ai/core/theme/app_theme.dart';
import 'package:safeguard_ai/core/utils/api_test_helper.dart';
import 'package:safeguard_ai/core/utils/demo_data_seeder.dart';
import 'package:safeguard_ai/core/utils/theme_notifier.dart';
import 'package:safeguard_ai/features/analysis/data/models/report_hive_model.dart';
import 'package:safeguard_ai/features/analysis/data/repositories/report_local_repository.dart';

// Global tema notifier (Erişim kolaylığı için)
late final ThemeNotifier themeNotifier;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Tema Tercihini Yükle
  final savedThemeMode = await ThemeNotifier.loadThemeMode();
  themeNotifier = ThemeNotifier(savedThemeMode);

  // 2. Local Veritabanı (Hive) Başlat
  await Hive.initFlutter();
  Hive.registerAdapter(ReportHiveModelAdapter());
  await Hive.openBox<ReportHiveModel>('reports');

  // 3. Bağımlılıkları Enjekte Et (DI)
  await di.init();

  // 4. (Sadece Debug) Demo Veri ve Testler
  if (kDebugMode) {
    // Demo verileri tohumla (Eğer hiç rapor yoksa)
    final repository = ReportLocalRepository();
    if (repository.getAllReports().isEmpty) {
      final seeder = DemoDataSeeder(repository);
      await seeder.seedDemoReports(count: 5);
    }

    // API bağlantı bilgisini konsola bas
    ApiTestHelper.printConnectionInfo();
  }

  runApp(const SafeGuardApp());
}

class SafeGuardApp extends StatelessWidget {
  const SafeGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema değişikliklerini dinleyerek anlık güncelleme sağlar
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          title: 'SafeGuard AI',
          debugShowCheckedModeBanner: false,

          // --- TEMA AYARLARI ---
          // Indigo/Mavi tabanlı Material 3 temaları
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
        );
      },
    );
  }
}
