import 'package:hive/hive.dart';

part 'report_hive_model.g.dart';

/// Hive Model - Local storage için rapor modeli
@HiveType(typeId: 0)
class ReportHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String analysis;

  @HiveField(2)
  final String riskLevel;

  @HiveField(3)
  final String imagePath;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final String emailSubject;

  @HiveField(6)
  final String emailBody;

  @HiveField(7)
  final List<String> recipients;

  @HiveField(8)
  final List<String> ccRecipients;

  @HiveField(9)
  final bool emailSent;

  @HiveField(10)
  final bool savedToGoogleDrive;

  @HiveField(11)
  final bool pdfGenerated;

  ReportHiveModel({
    required this.id,
    required this.analysis,
    required this.riskLevel,
    required this.imagePath,
    required this.timestamp,
    required this.emailSubject,
    required this.emailBody,
    required this.recipients,
    this.ccRecipients = const [],
    this.emailSent = false,
    this.savedToGoogleDrive = false,
    this.pdfGenerated = false,
  });

  /// ReportEntity'den Hive modeline dönüştürme
  factory ReportHiveModel.fromEntity({
    required String id,
    required String analysis,
    required String riskLevel,
    required String imagePath,
    required DateTime timestamp,
    required String emailSubject,
    required String emailBody,
    required List<String> recipients,
    List<String> ccRecipients = const [],
    bool emailSent = false,
    bool savedToGoogleDrive = false,
    bool pdfGenerated = false,
  }) {
    return ReportHiveModel(
      id: id,
      analysis: analysis,
      riskLevel: riskLevel,
      imagePath: imagePath,
      timestamp: timestamp,
      emailSubject: emailSubject,
      emailBody: emailBody,
      recipients: recipients,
      ccRecipients: ccRecipients,
      emailSent: emailSent,
      savedToGoogleDrive: savedToGoogleDrive,
      pdfGenerated: pdfGenerated,
    );
  }
}
