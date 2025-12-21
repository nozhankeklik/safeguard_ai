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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Analiz Raporu', style: Theme.of(context).textTheme.titleLarge),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Risk Seviyesi', entity.riskLevel),
              const SizedBox(height: 12),
              _buildInfoRow('Kategori', entity.category),
              const SizedBox(height: 12),
              _buildInfoRow('Güven', '${entity.confidence}%'),
              const Divider(height: 24),
              Text('Öneri', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(entity.recommendedAction),
              const Divider(height: 24),
              Text(
                'E-posta Taslağı',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildInfoRow('Alıcı', entity.reportEmail),
              const SizedBox(height: 8),
              _buildInfoRow('Konu', entity.reportSubject),
              const SizedBox(height: 8),
              Text('İçerik:', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(entity.reportBody, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AnalysisBloc>().add(const AnalysisEvent.reset());
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text('$label:', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ),
        Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
      ],
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
