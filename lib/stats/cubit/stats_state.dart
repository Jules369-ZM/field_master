part of 'stats_cubit.dart';

/// {@template stats}
/// StatsState description
/// {@endtemplate}
class StatsState extends Equatable {
  /// {@macro stats}
  const StatsState({
    this.message = 'Statistics',
    this.data,
    this.status = CurrentStatus.initial,
    this.expenses = const [],
  });

  /// A description for message
  final String message;
  final JsonMap? data;
  final CurrentStatus status;
  final List<Expense> expenses;
  @override
  List<Object?> get props => [message, status, data, expenses];

  /// Creates a copy of the current HomeState with property changes
  StatsState copyWith({
    String? message,
    JsonMap? data,
    CurrentStatus? status,
    List<Expense>? expenses,
  }) {
    return StatsState(
      message: message ?? this.message,
      status: status ?? this.status,
      data: data ?? this.data,
      expenses: expenses ?? this.expenses,
    );
  }
}
