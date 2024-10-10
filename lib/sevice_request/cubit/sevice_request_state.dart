part of 'sevice_request_cubit.dart';

/// {@template sevice_request}
/// SeviceRequestState description
/// {@endtemplate}
class SeviceRequestState extends Equatable {
  /// {@macro sevice_request}
  const SeviceRequestState({
    this.message = 'Default Value',
    this.status = CurrentStatus.initial,
    this.data = const {},
    this.history = const {},
  });

  /// A description for customProperty
  final String message;

  final CurrentStatus status;
  final JsonMap? data;
  final JsonMap? history;

  @override
  List<Object?> get props => [message, status, data, history];

  /// Creates a copy of the current SeviceRequestState with property changes
  SeviceRequestState copyWith({
    String? message,
    CurrentStatus? status,
    JsonMap? data,
    JsonMap? history,
  }) {
    return SeviceRequestState(
      message: message ?? this.message,
      status: status ?? this.status,
      data: data ?? this.data,
      history: history ?? this.history,
    );
  }
}

