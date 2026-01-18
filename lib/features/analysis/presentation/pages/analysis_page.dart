import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safeguard_ai/features/analysis/domain/entities/analysis_entity.dart';
import 'package:safeguard_ai/features/analysis/presentation/bloc/analysis_bloc.dart';
import 'package:safeguard_ai/features/analysis/presentation/bloc/analysis_event.dart';
import 'package:safeguard_ai/features/analysis/presentation/bloc/analysis_state.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> with TickerProviderStateMixin {
  final ImagePicker _imagePicker = ImagePicker();
  String? _lastImagePath;

  // Animasyon Kontrolcüleri
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Dinamik Metin Kontrolü
  int _loadingTextIndex = 0;
  Timer? _textTimer;
  final List<String> _loadingTexts = [
    'Görüntü Sunucuya Yükleniyor...',
    'Yapay Zeka Riskleri Tarıyor...',
    'Güvenlik Analizi Yapılıyor...',
    'Rapor Hazırlanıyor...',
  ];

  @override
  void initState() {
    super.initState();
    // Nefes alma (Pulse) animasyonu
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  void _startTextAnimation() {
    _loadingTextIndex = 0;
    _textTimer?.cancel();
    _textTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _loadingTextIndex = (_loadingTextIndex + 1) % _loadingTexts.length;
        });
      }
    });
  }

  void _stopTextAnimation() {
    _textTimer?.cancel();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _stopTextAnimation();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? file = await _imagePicker.pickImage(source: source);

    if (file != null && mounted) {
      _lastImagePath = file.path;
      // Yükleme başladığında metin animasyonunu başlat
      _startTextAnimation();
      context.read<AnalysisBloc>().add(AnalysisEvent.analyzeImage(file.path));
    }
  }

  void _navigateToReportPreview(AnalysisEntity entity) {
    _stopTextAnimation();
    if (_lastImagePath == null) return;
    context.read<AnalysisBloc>().add(const AnalysisEvent.reset());
    context.push('/report-preview', extra: {'analysis': entity, 'imagePath': _lastImagePath!});
  }

  void _showErrorSnackBar(String message) {
    _stopTextAnimation();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: BlocConsumer<AnalysisBloc, AnalysisState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (entity) => _navigateToReportPreview(entity),
            failure: (message) => _showErrorSnackBar(message),
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. HEADER
              SliverAppBar(
                pinned: true,
                title: Text(
                  'Analiz Merkezi',
                  style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
                centerTitle: false,
                backgroundColor: colorScheme.surface,
                surfaceTintColor: colorScheme.surfaceTint,
              ),

              // 2. İÇERİK
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isLoading
                          ? _buildModernLoadingState(colorScheme, theme.textTheme)
                          : _buildIdleState(colorScheme, theme.textTheme),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// ----------------------------------------------------------------
  /// DURUM 1: Bekleme (Idle) UI - YENİLENMİŞ "AKILLI TARAMA" İKONU
  /// ----------------------------------------------------------------
  Widget _buildIdleState(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // YENİ GÖRSEL: AKILLI TARAMA LENSİ
        Stack(
          alignment: Alignment.center,
          children: [
            // Dış Hareli Halka
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withOpacity(0.05),
                border: Border.all(color: colorScheme.primary.withOpacity(0.1), width: 2),
              ),
            ),
            // Orta Katman (Lens Çerçevesi)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colorScheme.primaryContainer, colorScheme.surface],
                ),
                boxShadow: [
                  BoxShadow(color: colorScheme.primary.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: Icon(Icons.camera, size: 50, color: colorScheme.primary),
            ),
            // Üst Katman (Tarama Efekti / Köşe Işıltısı)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.surface, width: 3),
                ),
                child: Icon(Icons.qr_code_scanner_rounded, size: 20, color: colorScheme.onPrimary),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        Text(
          'Yeni Bir Analiz Başlat',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Yapay zeka asistanımız ortamdaki tehlikeleri tespit etmek için hazır.',
          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.5),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 48),

        // Aksiyon Kartı
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.4)),
          ),
          color: colorScheme.surfaceContainerLow,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_rounded),
                    label: const Text('Kamerayı Aç', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_rounded),
                    label: const Text('Galeriden Seç', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.primary.withOpacity(0.5), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      backgroundColor: colorScheme.surface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  /// ----------------------------------------------------------------
  /// DURUM 2: Yükleniyor UI
  /// ----------------------------------------------------------------
  Widget _buildModernLoadingState(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animasyonlu Halka
        Stack(
          alignment: Alignment.center,
          children: [
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withOpacity(0.05),
                  border: Border.all(color: colorScheme.primary.withOpacity(0.2), width: 1),
                ),
              ),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surface,
                boxShadow: [BoxShadow(color: colorScheme.primary.withOpacity(0.15), blurRadius: 20, spreadRadius: 2)],
              ),
            ),
            SizedBox(
              width: 110,
              height: 110,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),
            // Yüklenirken de AI ikonunu gösterelim
            Icon(Icons.auto_awesome, size: 40, color: colorScheme.primary),
          ],
        ),

        const SizedBox(height: 48),

        // DEĞİŞEN METİN
        SizedBox(
          height: 30,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              _loadingTexts[_loadingTextIndex],
              key: ValueKey<int>(_loadingTextIndex),
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'Lütfen bekleyin, işlem biraz zaman alabilir.',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
        ),
      ],
    );
  }
}
