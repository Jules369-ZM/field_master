part of 'firebase_cubit.dart';

class FirebaseState extends Equatable {
  const FirebaseState({
    this.status = CurrentStatus.initial,
    this.message = '',
    this.data,
    this.app,
    this.auth,
    this.fireUser,
    this.user,
    this.token = '',
  });
  final CurrentStatus status;
  final String message;
  final String token;
  final JsonMap? data;
  final FirebaseApp? app;
  final fire_auth.FirebaseAuth? auth;
  final fire_auth.User? fireUser;
  final User? user;

  FirebaseState copyWith({
    CurrentStatus? status,
    String? message,
    String? token,
    JsonMap? data,
    FirebaseApp? app,
    fire_auth.FirebaseAuth? auth,
    fire_auth.User? fireUser,
    User? user,
  }) {
    return FirebaseState(
      data: data ?? this.data,
      message: message ?? this.message,
      status: status ?? this.status,
      app: app ?? this.app,
      auth: auth ?? this.auth,
      fireUser: fireUser ?? this.fireUser,
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }

  @override
  List<Object> get props => [
        status,
        message,
        data ?? '',
        auth ?? '',
        fireUser ?? '',
        user ?? '',
        token,
      ];
}
