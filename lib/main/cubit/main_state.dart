part of 'main_cubit.dart';

/// {@template main}
/// MainState description
/// {@endtemplate}
class MainState extends Equatable {
  /// {@macro main}
  const MainState({
    this.message = 'Main Page',
    this.status = CurrentStatus.initial,
    this.data,
    this.position,
  });

  /// A description for customProperty
  final String message;
  final CurrentStatus status;
  final JsonMap? data;
  final Position? position;

  @override
  List<Object> get props => [status, message, data ?? '', position ?? ''];

  /// Creates a copy of the current LoginState with property changes
  MainState copyWith({
    String? message,
    CurrentStatus? status,
    JsonMap? data,
    Position? position,
  }) {
    return MainState(
      message: message ?? this.message,
      status: status ?? this.status,
      data: data ?? this.data,
      position: position ?? this.position,
    );
  }
}
