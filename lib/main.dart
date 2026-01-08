import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:safeguard_ai/core/init/injection_container.dart' as di;
import 'package:safeguard_ai/core/router/app_router.dart';
import 'package:safeguard_ai/core/theme/app_theme.dart';
import 'package:safeguard_ai/core/utils/api_test_helper.dart';
// Fiziksel cihaz için custom URL gerektiğinde uncomment edin:
// import 'package:safeguard_ai/core/utils/platform_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 🔧 FİZİKSEL CİHAZ İÇİN BURAYA LOCAL IP GİRİN
  // import 'package:safeguard_ai/core/utils/platform_config.dart'; ekleyin ve uncomment edin:
  // PlatformConfig.useCustomBaseUrl('http://192.168.1.100:5678');
  
  // Dependency Injection setup
  await di.init();
  
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
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'SafeGuard AI',
      theme: AppTheme.lightTheme, // Light mode aktif
      darkTheme: AppTheme.darkTheme, // Dark mode hazır (ayarlardan açılabilir)
      themeMode: ThemeMode.light, // Varsayılan olarak light mode
      debugShowCheckedModeBanner: false,
    );
  }
}
