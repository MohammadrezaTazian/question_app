import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:question_app/blocs/year_selection/year_selection_event.dart';
import 'package:question_app/blocs/year_selection/year_selection_state.dart';
import 'package:question_app/services/year_service.dart';

class YearSelectionBloc extends Bloc<YearSelectionEvent, YearSelectionState> {
  YearSelectionBloc() : super(YearSelectionInitial()) {
    on<LoadYears>(_onLoadYears);
    on<SelectYear>(_onSelectYear);
    on<NavigateToNextPage>(_onNavigateToNextPage);
    on<FilterYears>(_onFilterYears);
  }

  Future<void> _onLoadYears(LoadYears event, Emitter<YearSelectionState> emit) async {
    emit(YearSelectionLoading());
    try {
      final years = await YearService.getYears();
      emit(YearSelectionLoaded(
        years: years,
        filteredYears: years,
        fieldName: event.fieldName,
      ));
    } catch (e) {
      emit(YearSelectionError('خطا در بارگذاری سال‌ها: $e'));
    }
  }

  void _onSelectYear(SelectYear event, Emitter<YearSelectionState> emit) {
    final currentState = state;
    if (currentState is YearSelectionLoaded) {
      emit(currentState.copyWith(
        selectedIndex: event.index,
        shouldNavigate: false,
      ));
      
      // Add a delay before triggering navigation
      Future.delayed(const Duration(milliseconds: 300), () {
        add(NavigateToNextPage(event.year, currentState.fieldName));
      });
    }
  }

  void _onNavigateToNextPage(NavigateToNextPage event, Emitter<YearSelectionState> emit) {
    final currentState = state;
    if (currentState is YearSelectionLoaded) {
      emit(currentState.copyWith(shouldNavigate: true));
    }
  }

  void _onFilterYears(FilterYears event, Emitter<YearSelectionState> emit) {
    final currentState = state;
    if (currentState is YearSelectionLoaded) {
      final query = event.query.toLowerCase();
      if (query.isEmpty) {
        emit(currentState.copyWith(filteredYears: currentState.years));
      } else {
        final filtered = currentState.years
            .where((year) => 
                year.year.toLowerCase().contains(query) || 
                year.description.toLowerCase().contains(query))
            .toList();
        emit(currentState.copyWith(filteredYears: filtered));
      }
    }
  }
}