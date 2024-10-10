part of 'register_cubit.dart';

/// {@template register}
/// RegisterState description
/// {@endtemplate}
class RegisterState extends Equatable {
  /// {@macro register}
  const RegisterState({
    this.message = '',
    this.status = CurrentStatus.initial,
    this.data,
  });

  /// A description for message
  final String message;
  final CurrentStatus status;
  final JsonMap? data;

  @override
  List<Object> get props => [message, status];

  /// Creates a copy of the current RegisterState with property changes
  RegisterState copyWith({
    String? message,
    CurrentStatus? status,
    JsonMap? data,
    List<String>? categories,
    List<String>? subCategories,
    Map<String, List<String>>? categoriesList,
  }) {
    return RegisterState(
      message: message ?? this.message,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}
