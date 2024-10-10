part of 'login_cubit.dart';

/// {@template login}
/// LoginState description
/// {@endtemplate}
class LoginState extends Equatable {
  /// {@macro login}
  const LoginState({
    this.message = 'Login Page',
    this.status = CurrentStatus.initial,
    this.data,
  });

  /// A description for customProperty
  final String message;
  final CurrentStatus status;
  final JsonMap? data;

  @override
  List<Object> get props => [status, message, data ?? ''];

  /// Creates a copy of the current LoginState with property changes
  LoginState copyWith({
    String? message,
    CurrentStatus? status,
    JsonMap? data,
  }) {
    return LoginState(
      message: message ?? this.message,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}
