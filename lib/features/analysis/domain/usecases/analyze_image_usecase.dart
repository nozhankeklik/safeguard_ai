import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/analysis_entity.dart';
import '../repositories/analysis_repository.dart';

class AnalyzeImageUseCase implements UseCase<AnalysisEntity, String> {
  final AnalysisRepository repository;

  AnalyzeImageUseCase(this.repository);

  @override
  Future<Either<Failure, AnalysisEntity>> call(String params) async {
    return await repository.analyzeImage(params);
  }
}
