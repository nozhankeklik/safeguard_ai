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
    // Eğer detay sayfasındaysak (report-detail veya report-preview), önce kapat
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/report-detail') || location.startsWith('/report-preview')) {
      // Stack'ten çıkar (pop)
      if (context.canPop()) {
        context.pop();
      }
    }

    // Yeni sayfaya git
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

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _handleNavigation(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Geçmiş',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).bottomAppBarTheme.color ?? Theme.of(context).cardColor,
      ),
    );
  }
}
