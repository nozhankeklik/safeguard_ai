import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../constants/api_constants.dart';
import '../utils/platform_config.dart';
import '../../features/analysis/data/datasources/analysis_remote_datasource.dart';
import '../../features/analysis/data/datasources/analysis_mock_datasource.dart';
import '../../features/analysis/data/datasources/report_remote_datasource.dart';
import '../../features/analysis/data/repositories/analysis_repository_impl.dart';
import '../../features/analysis/data/repositories/report_local_repository.dart';
import '../../features/analysis/domain/repositories/analysis_repository.dart';
import '../../features/analysis/domain/usecases/analyze_image_usecase.dart';
import '../../features/analysis/presentation/bloc/analysis_bloc.dart';
import '../../features/history/presentation/bloc/history_bloc.dart';

final sl = GetIt.instance;

// 🎛️ MOCK MODE SWITCH - n8n hazır olmadan geliştirme için
// true = Mock kullan (sahte veri ile geliştirme)
// false = Gerçek n8n API kullan (production)
const bool _useMockData = false; // 👈 n8n hazır olunca false yap

Future<void> init() async {
  // External (Dış Servisler)
  sl.registerLazySingleton<Dio>(
    () =>
        Dio(
            BaseOptions(
              baseUrl: PlatformConfig.getActiveBaseUrl(),
              connectTimeout: ApiConstants.connectionTimeout,
              receiveTimeout: ApiConstants.receiveTimeout,
              headers: {'Accept': 'application/json'},
            ),
          )
          ..interceptors.add(
            LogInterceptor(
              requestBody: true,
              responseBody: true,
              requestHeader: true,
              responseHeader: false,
              error: true,
            ),
          ),
  );

  // Data Sources - Mock/Production Switch
  if (_useMockData) {
    // 🎭 MOCK MODE - Geliştirme için sahte veri
    sl.registerLazySingleton<AnalysisRemoteDataSource>(() => AnalysisMockDataSource());
    sl.registerLazySingleton<ReportRemoteDataSource>(() => ReportMockDataSource());
    // ignore: avoid_print
    print('🎭 MOCK MODE: Sahte veri kullanılıyor (n8n bağlantısı yok)');
  } else {
    // 🚀 PRODUCTION MODE - Gerçek n8n API
    sl.registerLazySingleton<AnalysisRemoteDataSource>(() => AnalysisRemoteDataSourceImpl(sl<Dio>()));
    sl.registerLazySingleton<ReportRemoteDataSource>(() => ReportRemoteDataSourceImpl(sl<Dio>()));
    // ignore: avoid_print
    print('🚀 PRODUCTION MODE: n8n API kullanılıyor');
  }

  // Repositories
  sl.registerLazySingleton<AnalysisRepository>(() => AnalysisRepositoryImpl(sl<AnalysisRemoteDataSource>()));
  sl.registerLazySingleton<ReportLocalRepository>(() => ReportLocalRepository());

  // Use Cases
  sl.registerLazySingleton(() => AnalyzeImageUseCase(sl<AnalysisRepository>()));

  // BLoCs (Factory - Her çağrıldığında yeni instance)
  sl.registerFactory(() => AnalysisBloc(sl<AnalyzeImageUseCase>()));
  sl.registerFactory(() => HistoryBloc(sl<ReportLocalRepository>()));
}
