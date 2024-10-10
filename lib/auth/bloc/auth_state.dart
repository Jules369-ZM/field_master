part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user = User.empty,
    this.fireBaseUser,
    this.options = const <String, bool>{
      'loggedIn': false,
      'hasPin': false,
      'hasBiometrics': false,
    },
    this.useBiometrics = false,
  });

  final AuthStatus status;
  final User user;
  final fire_auth.User? fireBaseUser;
  final JsonMap? options;
  final bool? useBiometrics;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    fire_auth.User? fireBaseUser,
    JsonMap? options,
    bool? useBiometrics,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
      options: options ?? this.options,
      fireBaseUser: fireBaseUser ?? this.fireBaseUser,
      useBiometrics: useBiometrics ?? this.useBiometrics,
    );
  }

  @override
  List<Object> get props =>
      [status, user, useBiometrics ?? false, fireBaseUser ?? ''];
}
