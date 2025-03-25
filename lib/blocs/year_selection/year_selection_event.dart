import 'package:equatable/equatable.dart';
import 'package:question_app/models/year.dart';

abstract class YearSelectionEvent extends Equatable {
  const YearSelectionEvent();

  @override
  List<Object?> get props => [];
}

class LoadYears extends YearSelectionEvent {
  final String fieldName;

  const LoadYears(this.fieldName);

  @override
  List<Object> get props => [fieldName];
}

class SelectYear extends YearSelectionEvent {
  final Year year;
  final int index;

  const SelectYear(this.year, this.index);

  @override
  List<Object> get props => [year, index];
}

class NavigateToNextPage extends YearSelectionEvent {
  final Year year;
  final String fieldName;

  const NavigateToNextPage(this.year, this.fieldName);

  @override
  List<Object> get props => [year, fieldName];
}

class FilterYears extends YearSelectionEvent {
  final String query;

  const FilterYears(this.query);

  @override
  List<Object> get props => [query];
}