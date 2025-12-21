import 'package:dio/dio.dart';
import 'package:safeguard_ai/core/constants/api_constants.dart';
import 'package:safeguard_ai/core/errors/exceptions.dart';
import 'package:safeguard_ai/features/analysis/data/models/analysis_response_model.dart';

abstract class AnalysisRemoteDataSource {
  Future<AnalysisResponseModel> analyzeImage(String imagePath);
}

class AnalysisRemoteDataSourceImpl implements AnalysisRemoteDataSource {
  final Dio dio;

  AnalysisRemoteDataSourceImpl(this.dio);

  @override
  Future<AnalysisResponseModel> analyzeImage(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'data': await MultipartFile.fromFile(
          imagePath,
          filename: 'upload.jpg',
        ),
      });

      final response = await dio.post(
        ApiConstants.analyzeEndpoint,
        data: formData,
      );

      return AnalysisResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        'Analiz hatası: ${e.message ?? 'Bilinmeyen hata'}',
      );
    } catch (e) {
      throw ServerException('Analiz hatası: $e');
    }
  }
}

