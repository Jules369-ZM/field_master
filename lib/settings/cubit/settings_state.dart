part of 'settings_cubit.dart';

/// {@template settings}
/// SettingsState description
/// {@endtemplate}
class SettingsState extends Equatable {
  /// {@macro settings}
  const SettingsState({
    this.message = 'Settings',
    this.data,
    this.status = CurrentStatus.initial,
  });

  /// A description for message
  final String message;
  final JsonMap? data;
  final CurrentStatus status;

  @override
  List<Object> get props => [message, status, data ?? ''];

  /// Creates a copy of the current HomeState with property changes
  SettingsState copyWith({
    String? message,
    JsonMap? data,
    CurrentStatus? status,
  }) {
    return SettingsState(
      message: message ?? this.message,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}
