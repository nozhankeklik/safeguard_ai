import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:safeguard_ai/core/errors/exceptions.dart';
import 'package:safeguard_ai/core/errors/failures.dart';
import 'package:safeguard_ai/features/analysis/data/datasources/analysis_remote_datasource.dart';
import 'package:safeguard_ai/features/analysis/data/models/analysis_response_model.dart';
import 'package:safeguard_ai/features/analysis/domain/entities/analysis_entity.dart';
import 'package:safeguard_ai/features/analysis/domain/repositories/analysis_repository.dart';

class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisRemoteDataSource remoteDataSource;

  AnalysisRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AnalysisEntity>> analyzeImage(String imagePath) async {
    try {
      final model = await remoteDataSource.analyzeImage(imagePath);
      final entity = model.toEntity();
      return Right(entity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const Left(ConnectionFailure());
      }
      return Left(ServerFailure('Bağlantı hatası: ${e.message ?? 'Bilinmeyen hata'}'));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }
}

