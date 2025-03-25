import 'package:equatable/equatable.dart';
import 'package:question_app/models/year.dart';

abstract class YearSelectionState extends Equatable {
  const YearSelectionState();
  
  @override
  List<Object?> get props => [];
}

class YearSelectionInitial extends YearSelectionState {}

class YearSelectionLoading extends YearSelectionState {}

class YearSelectionLoaded extends YearSelectionState {
  final List<Year> years;
  final List<Year> filteredYears;
  final String fieldName;
  final int? selectedIndex;
  final bool shouldNavigate;

  const YearSelectionLoaded({
    required this.years,
    required this.filteredYears,
    required this.fieldName,
    this.selectedIndex,
    this.shouldNavigate = false,
  });

  YearSelectionLoaded copyWith({
    List<Year>? years,
    List<Year>? filteredYears,
    String? fieldName,
    int? selectedIndex,
    bool? shouldNavigate,
  }) {
    return YearSelectionLoaded(
      years: years ?? this.years,
      filteredYears: filteredYears ?? this.filteredYears,
      fieldName: fieldName ?? this.fieldName,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      shouldNavigate: shouldNavigate ?? this.shouldNavigate,
    );
  }

  @override
  List<Object?> get props => [years, filteredYears, fieldName, selectedIndex, shouldNavigate];
}

class YearSelectionError extends YearSelectionState {
  final String message;

  const YearSelectionError(this.message);

  @override
  List<Object> get props => [message];
}