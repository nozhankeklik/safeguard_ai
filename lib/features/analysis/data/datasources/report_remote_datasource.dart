import 'package:dio/dio.dart';
import 'package:safeguard_ai/core/constants/api_constants.dart';
import 'package:safeguard_ai/features/analysis/data/models/send_report_request.dart';
import 'package:safeguard_ai/features/analysis/data/models/send_report_response.dart';

/// n8n'e rapor gönderme datasource
abstract class ReportRemoteDataSource {
  Future<SendReportResponse> sendReport(SendReportRequest request);
}

/// n8n API implementasyonu
class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final Dio dio;

  ReportRemoteDataSourceImpl(this.dio);

  @override
  Future<SendReportResponse> sendReport(SendReportRequest request) async {
    try {
      final response = await dio.post(
        ApiConstants.sendReportEndpoint, // n8n webhook endpoint
        data: request.toJson(),
      );

      return SendReportResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Hata durumunda exception fırlat
      throw _handleDioError(e);
    }
  }

  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Bağlantı zaman aşımına uğradı. İnternet bağlantınızı kontrol edin.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return 'Sunucu yanıt vermiyor. Lütfen daha sonra tekrar deneyin.';
    } else if (e.response?.statusCode == 500) {
      return 'Sunucu hatası. Lütfen daha sonra tekrar deneyin.';
    } else if (e.response?.statusCode == 400) {
      return 'Geçersiz istek. Lütfen bilgileri kontrol edin.';
    } else {
      return 'Beklenmeyen bir hata oluştu: ${e.message}';
    }
  }
}

/// Mock implementasyon (n8n olmadan test için)
class ReportMockDataSource implements ReportRemoteDataSource {
  @override
  Future<SendReportResponse> sendReport(SendReportRequest request) async {
    // Gerçekçi gecikme
    await Future.delayed(const Duration(seconds: 2));

    // Mock başarılı response
    return SendReportResponse(
      success: true,
      emailSent: true,
      docsCreated: request.saveToGoogleDocs,
      pdfGenerated: request.generatePdf,
      docsUrl: request.saveToGoogleDocs ? 'https://docs.google.com/document/d/mock-doc-id' : null,
      pdfUrl: request.generatePdf ? 'https://storage.googleapis.com/mock-bucket/report.pdf' : null,
      message: 'Rapor başarıyla gönderildi (Mock Mode)',
    );
  }
}
