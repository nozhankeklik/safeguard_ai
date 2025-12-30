import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _AnalysisPageState extends State<AnalysisPage> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? file = await _imagePicker.pickImage(source: source);

    if (file != null && mounted) {
      context.read<AnalysisBloc>().add(AnalysisEvent.analyzeImage(file.path));
    }
  }

  void _showResultDialog(AnalysisEntity entity) {
    // Risk seviyesine göre renk belirleme
    Color getRiskColor(String riskLevel) {
      switch (riskLevel.toUpperCase()) {
        case 'YÜKSEK':
        case 'HIGH':
          return Colors.red;
        case 'ORTA':
        case 'MEDIUM':
          return Colors.orange;
        case 'DÜŞÜK':
        case 'LOW':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    // BLoC referansını dialog dışında yakalayın
    final analysisBloc = context.read<AnalysisBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.analytics_outlined, color: Theme.of(dialogContext).primaryColor),
            const SizedBox(width: 8),
            Text('Analiz Sonucu', style: Theme.of(dialogContext).textTheme.titleLarge),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Risk Seviyesi Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: getRiskColor(entity.riskLevel).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: getRiskColor(entity.riskLevel), width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: getRiskColor(entity.riskLevel)),
                    const SizedBox(width: 8),
                    Text(
                      'Risk Seviyesi: ${entity.riskLevel}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: getRiskColor(entity.riskLevel),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Analiz Metni
              Text(
                'Analiz Detayı',
                style: Theme.of(dialogContext).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(entity.analysisText, style: Theme.of(dialogContext).textTheme.bodyMedium),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              analysisBloc.add(const AnalysisEvent.reset());
            },
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Tamam'),
          ),
        ],
      ),
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
              _showResultDialog(entity);
            },
            failure: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
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
