import 'package:fpdart/fpdart.dart';
import 'package:safeguard_ai/core/errors/failures.dart';
import 'package:safeguard_ai/features/analysis/domain/entities/analysis_entity.dart';

abstract class AnalysisRepository {
  Future<Either<Failure, AnalysisEntity>> analyzeImage(String imagePath);
}

