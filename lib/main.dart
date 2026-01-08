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
// Fiziksel cihaz için custom URL gerektiğinde uncomment edin:
// import 'package:safeguard_ai/core/utils/platform_config.dart';

// Global tema notifier
late final ThemeNotifier themeNotifier;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔧 FİZİKSEL CİHAZ İÇİN BURAYA LOCAL IP GİRİN
  // import 'package:safeguard_ai/core/utils/platform_config.dart'; ekleyin ve uncomment edin:
  // PlatformConfig.useCustomBaseUrl('http://192.168.1.100:5678');

  // 🌙 Tema yönetimi - kaydedilmiş temayı yükle
  final savedThemeMode = await ThemeNotifier.loadThemeMode();
  themeNotifier = ThemeNotifier(savedThemeMode);

  // 📦 Hive initialization
  await Hive.initFlutter();

  // Hive adapters
  Hive.registerAdapter(ReportHiveModelAdapter());

  // Hive boxes
  await Hive.openBox<ReportHiveModel>('reports');

  // Dependency Injection setup
  await di.init();

  // 🎭 Demo data seeding (ilk açılışta)
  if (kDebugMode) {
    final repository = ReportLocalRepository();
    final seeder = DemoDataSeeder(repository);
    await seeder.seedDemoReports(count: 15); // 15 demo rapor oluştur
  }

  // Debug modda API bağlantı bilgilerini göster
  if (kDebugMode) {
    ApiTestHelper.printConnectionInfo();

    // Opsiyonel: Başlangıçta bağlantıyı test et
    // await ApiTestHelper.testConnection();
  }

  runApp(const SafeGuardApp());
}

class SafeGuardApp extends StatelessWidget {
  const SafeGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder ile tema değişikliklerini dinle
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          title: 'SafeGuard AI',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode, // Dinamik tema
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
