import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safeguard_ai/features/analysis/data/repositories/report_local_repository.dart';
import 'history_event.dart';
import 'history_state.dart';

/// History BLoC - Geçmiş raporları yöneten BLoC
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final ReportLocalRepository _repository;

  HistoryBloc(this._repository) : super(const HistoryState.initial()) {
    on<HistoryEvent>(_onEvent);
  }

  Future<void> _onEvent(HistoryEvent event, Emitter<HistoryState> emit) async {
    await event.map(
      loadReports: (e) => _onLoadReports(e, emit),
      filterByRiskLevel: (e) => _onFilterByRiskLevel(e, emit),
      deleteReport: (e) => _onDeleteReport(e, emit),
      deleteAllReports: (e) => _onDeleteAllReports(e, emit),
    );
  }

  Future<void> _onLoadReports(HistoryEvent event, Emitter<HistoryState> emit) async {
    emit(const HistoryState.loading());

    try {
      final reports = _repository.getAllReports();

      if (reports.isEmpty) {
        emit(const HistoryState.empty());
      } else {
        emit(HistoryState.loaded(reports: reports));
      }
    } catch (e) {
      emit(HistoryState.failure('Raporlar yüklenirken hata oluştu: ${e.toString()}'));
    }
  }

  Future<void> _onFilterByRiskLevel(HistoryEvent event, Emitter<HistoryState> emit) async {
    emit(const HistoryState.loading());

    final riskLevel = event.maybeMap(filterByRiskLevel: (e) => e.riskLevel, orElse: () => null);

    try {
      final reports = riskLevel == null || riskLevel == 'Tümü'
          ? _repository.getAllReports()
          : _repository.getReportsByRiskLevel(riskLevel);

      if (reports.isEmpty) {
        emit(const HistoryState.empty());
      } else {
        emit(HistoryState.loaded(reports: reports, currentFilter: riskLevel));
      }
    } catch (e) {
      emit(HistoryState.failure('Filtreleme sırasında hata oluştu: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteReport(HistoryEvent event, Emitter<HistoryState> emit) async {
    final id = event.maybeMap(deleteReport: (e) => e.id, orElse: () => '');

    try {
      await _repository.deleteReport(id);

      // Raporları yeniden yükle
      add(const HistoryEvent.loadReports());
    } catch (e) {
      emit(HistoryState.failure('Rapor silinirken hata oluştu: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteAllReports(HistoryEvent event, Emitter<HistoryState> emit) async {
    try {
      await _repository.deleteAllReports();
      emit(const HistoryState.empty());
    } catch (e) {
      emit(HistoryState.failure('Tüm raporlar silinirken hata oluştu: ${e.toString()}'));
    }
  }
}
