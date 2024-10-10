part of 'home_cubit.dart';

/// {@template home}
/// HomeState description
/// {@endtemplate}
class HomeState extends Equatable {
  /// {@macro home}
  const HomeState({
    this.message = 'Home',
    this.data,
    this.count = const {
      'Pending': 0,
      'InProgress': 0,
      'Complete': 0,
    },
    this.status = CurrentStatus.initial,
  });

  /// A description for message
  final String message;
  final JsonMap? data;
  final JsonMap? count;
  final CurrentStatus status;

  @override
  List<Object?> get props => [
        message,
        status,
        data ?? '',
        count ?? '',
      ];

  /// Creates a copy of the current HomeState with property changes
  HomeState copyWith({
    String? message,
    JsonMap? data,
    JsonMap? count,
    CurrentStatus? status,
  }) {
    return HomeState(
      message: message ?? this.message,
      status: status ?? this.status,
      data: data ?? this.data,
      count: count ?? this.count,
    );
  }
}
