import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // 2.5 Saniye bekle ve Ana Sayfaya git
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      // SafeArea: Alt metnin telefonun çubuğu altında kalmasını engeller
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Üstteki boşluğu dengelemek için Spacer
              const Spacer(),

              // --- ORTA KISIM: LOGO VE İSİM ---
              FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset('assets/images/app_logo.png', width: 320, height: 320, fit: BoxFit.contain),
              ),

              Transform.translate(
                offset: const Offset(0, -60),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'SafeGuard AI',
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.primary,
                            letterSpacing: -1.0,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'İş Güvenliği Asistanınız',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // İçeriği yukarıda, imzayı aşağıda tutmak için ikinci Spacer
              const Spacer(),

              // --- ALT KISIM: POWERED BY GEMINI ---
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Powered by', style: GoogleFonts.inter(fontSize: 12, color: colorScheme.outline)),
                      const SizedBox(width: 4),
                      Text(
                        'Google Gemini',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.outline),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.auto_awesome, size: 12, color: colorScheme.outline),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
