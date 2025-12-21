import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:safeguard_ai/core/constants/api_constants.dart';
import 'package:safeguard_ai/features/analysis/data/datasources/analysis_remote_datasource.dart';
import 'package:safeguard_ai/features/analysis/data/repositories/analysis_repository_impl.dart';
import 'package:safeguard_ai/features/analysis/domain/repositories/analysis_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External (Dış Servisler)
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.connectionTimeout,
      ),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AnalysisRemoteDataSource>(() => AnalysisRemoteDataSourceImpl(sl<Dio>()));

  // Repositories
  sl.registerLazySingleton<AnalysisRepository>(() => AnalysisRepositoryImpl(sl<AnalysisRemoteDataSource>()));
}
