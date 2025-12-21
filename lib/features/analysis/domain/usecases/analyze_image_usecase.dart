import 'package:fpdart/fpdart.dart';
import 'package:safeguard_ai/core/errors/failures.dart';
import 'package:safeguard_ai/core/utils/usecase.dart';
import 'package:safeguard_ai/features/analysis/domain/entities/analysis_entity.dart';
import 'package:safeguard_ai/features/analysis/domain/repositories/analysis_repository.dart';

class AnalyzeImageUseCase implements UseCase<AnalysisEntity, String> {
  final AnalysisRepository repository;

  AnalyzeImageUseCase(this.repository);

  @override
  Future<Either<Failure, AnalysisEntity>> call(String params) async {
    return await repository.analyzeImage(params);
  }
}
