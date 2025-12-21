import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:safeguard_ai/core/constants/api_constants.dart';

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
}
