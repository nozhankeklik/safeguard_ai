import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key, required this.child});

  final Widget child;

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _getCurrentIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/analyze')) return 1;
    if (location.startsWith('/history')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _handleNavigation(int index, BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/report-detail') || location.startsWith('/report-preview')) {
      if (context.canPop()) context.pop();
    }

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/analyze');
        break;
      case 2:
        context.go('/history');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _getCurrentIndex(location);
    final theme = Theme.of(context);

    return Scaffold(
      body: widget.child,
      // Navigasyon Bar
      bottomNavigationBar: Container(
        // PROFESYONEL DOKUNUŞ: Üst tarafa ince çizgi (Border)
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor, // Çentik arkası uyumu
          border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.2), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _handleNavigation(index, context),
          // Tema dosyasındaki ayarları kullanır, ekstra renk vermeye gerek yok
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded), // Seçilince dolgulu ikon
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner_outlined),
              activeIcon: Icon(Icons.document_scanner_rounded),
              label: 'Analiz',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history_rounded),
              label: 'Geçmiş',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings_rounded),
              label: 'Ayarlar',
            ),
          ],
        ),
      ),
    );
  }
}
