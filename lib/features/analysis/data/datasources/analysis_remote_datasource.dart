import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/analysis_response_model.dart';

abstract class AnalysisRemoteDataSource {
  Future<AnalysisResponseModel> analyzeImage(String imagePath);
}

class AnalysisRemoteDataSourceImpl implements AnalysisRemoteDataSource {
  final Dio dio;

  AnalysisRemoteDataSourceImpl(this.dio);

  @override
  Future<AnalysisResponseModel> analyzeImage(String imagePath) async {
    try {
      final formData = FormData.fromMap({'data': await MultipartFile.fromFile(imagePath, filename: 'upload.jpg')});

      final response = await dio.post(ApiConstants.analyzeEndpoint, data: formData);

      return AnalysisResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage = 'Analiz hatası: ';

      if (e.response?.statusCode == 404) {
        errorMessage += 'Endpoint bulunamadı (404). n8n webhook path\'ini kontrol edin.';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage += 'Bağlantı zaman aşımı. n8n servisinin çalıştığından emin olun.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage += 'Bağlantı hatası. Base URL\'i kontrol edin (localhost yerine IP adresi gerekebilir).';
      } else {
        errorMessage += e.message ?? 'Bilinmeyen hata';
      }

      throw ServerException(errorMessage);
    } catch (e) {
      throw ServerException('Analiz hatası: $e');
    }
  }
}
