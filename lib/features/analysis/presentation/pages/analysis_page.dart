import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safeguard_ai/core/constants/app_constants.dart';
import 'package:safeguard_ai/features/analysis/domain/entities/analysis_entity.dart';
import 'package:safeguard_ai/features/analysis/presentation/bloc/analysis_bloc.dart';
import 'package:safeguard_ai/features/analysis/presentation/bloc/analysis_event.dart';
import 'package:safeguard_ai/features/analysis/presentation/bloc/analysis_state.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final ImagePicker _imagePicker = ImagePicker();
  String? _lastImagePath; // Seçilen resmin yolunu sakla

  Future<void> _pickImage(ImageSource source) async {
    final XFile? file = await _imagePicker.pickImage(source: source);

    if (file != null && mounted) {
      _lastImagePath = file.path; // Resim yolunu sakla
      context.read<AnalysisBloc>().add(AnalysisEvent.analyzeImage(file.path));
    }
  }

  void _navigateToReportPreview(AnalysisEntity entity) {
    if (_lastImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resim yolu bulunamadı'),
          backgroundColor: RiskColors.highRiskPrimary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // BLoC'u reset et
    context.read<AnalysisBloc>().add(const AnalysisEvent.reset());

    // Report preview sayfasına git
    context.push(
      '/report-preview',
      extra: {
        'analysis': entity,
        'imagePath': _lastImagePath!,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SafeGuard AI'), centerTitle: true),
      body: BlocConsumer<AnalysisBloc, AnalysisState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {},
            success: (entity) {
              _navigateToReportPreview(entity);
            },
            failure: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(child: Text(message)),
                    ],
                  ),
                  backgroundColor: RiskColors.highRiskPrimary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            orElse: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('📸 Fotoğraf Çek'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      minimumSize: const Size(200, 50),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('🖼️ Galeriden Seç'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      minimumSize: const Size(200, 50),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
