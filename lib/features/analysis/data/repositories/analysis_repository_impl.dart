import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/analysis_remote_datasource.dart';
import '../models/analysis_response_model.dart';
import '../../domain/entities/analysis_entity.dart';
import '../../domain/repositories/analysis_repository.dart';

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
