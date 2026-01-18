import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/analysis_entity.dart';

abstract class AnalysisRepository {
  Future<Either<Failure, AnalysisEntity>> analyzeImage(String imagePath);
}
