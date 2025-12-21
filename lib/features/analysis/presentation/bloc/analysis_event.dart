import 'package:freezed_annotation/freezed_annotation.dart';

part 'analysis_event.freezed.dart';

@freezed
class AnalysisEvent with _$AnalysisEvent {
  const factory AnalysisEvent.analyzeImage(String imagePath) = _AnalyzeImage;
  const factory AnalysisEvent.reset() = _Reset;
}

