import '../models/analysis_response_model.dart';
import '../../domain/entities/analysis_entity.dart';

/// Mapper for converting between Domain entities and Data models
///
/// Follows Clean Architecture principle by isolating data transformation
/// logic between layers. This ensures domain entities remain pure and
/// independent from data layer implementations.
///
/// Note: AnalysisResponseModel already has a `toEntity()` extension method.
/// This mapper class demonstrates the mapper pattern and can be extended
/// for more complex transformations in the future.
class AnalysisMapper {
  AnalysisMapper._();

  /// Converts Data Model (from API) to Domain Entity
  ///
  /// This method transforms the API response model into a domain entity,
  /// keeping business logic separate from data layer concerns.
  static AnalysisEntity toEntity(AnalysisResponseModel model) {
    return AnalysisEntity(success: model.success, analysisText: model.analysis, riskLevel: model.riskLevel);
  }

  /// Converts Domain Entity to Data Model (for API requests)
  ///
  /// This method transforms domain entities into data models when
  /// sending data to external APIs or storing in local database.
  static AnalysisResponseModel toModel(AnalysisEntity entity) {
    return AnalysisResponseModel(success: entity.success, analysis: entity.analysisText, riskLevel: entity.riskLevel);
  }
}
