import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/analyze_image_usecase.dart';
import 'analysis_event.dart';
import 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final AnalyzeImageUseCase analyzeImageUseCase;

  AnalysisBloc(this.analyzeImageUseCase) : super(const AnalysisState.initial()) {
    on<AnalysisEvent>(_onAnalysisEvent);
  }

  Future<void> _onAnalysisEvent(AnalysisEvent event, Emitter<AnalysisState> emit) async {
    await event.when(analyzeImage: (imagePath) => _onAnalyzeImage(imagePath, emit), reset: () async => _onReset(emit));
  }

  Future<void> _onAnalyzeImage(String imagePath, Emitter<AnalysisState> emit) async {
    emit(const AnalysisState.loading());

    final result = await analyzeImageUseCase.call(imagePath);

    result.fold(
      (failure) {
        final message = failure is ServerFailure
            ? failure.message
            : failure is ConnectionFailure
            ? 'Bağlantı hatası. Lütfen internet bağlantınızı kontrol edin.'
            : 'Beklenmeyen bir hata oluştu.';
        emit(AnalysisState.failure(message));
      },
      (entity) {
        emit(AnalysisState.success(entity));
      },
    );
  }

  void _onReset(Emitter<AnalysisState> emit) {
    emit(const AnalysisState.initial());
  }
}
