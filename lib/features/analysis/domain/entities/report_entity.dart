import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:safeguard_ai/features/analysis/domain/entities/analysis_entity.dart';

part 'report_entity.freezed.dart';

/// Rapor Entity - Mail gönderme için hazırlanmış rapor
@freezed
class ReportEntity with _$ReportEntity {
  const factory ReportEntity({
    required AnalysisEntity analysis,
    required String imagePath,
    required DateTime timestamp,
    required String emailSubject,
    required String emailBody,
    required List<String> recipients,
    @Default([]) List<String> ccRecipients,
    @Default([]) List<String> bccRecipients,
    @Default(false) bool saveToGoogleDocs,
    @Default(false) bool generatePdf,
    @Default(false) bool createFollowUp,
  }) = _ReportEntity;
}
