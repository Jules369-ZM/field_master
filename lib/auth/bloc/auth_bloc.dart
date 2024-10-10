// ignore_for_file: always_use_package_imports, unused_field

import 'dart:async';
import 'dart:developer';

import 'package:auth_repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:net_source/net_source.dart';
import 'package:services_repo/services_repo.dart';

import '../../utils/cubit/firebase_cubit.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.firebaseCubit,
    required AuthRepo authenticationRepository,
    required ServicesRepo servicesRepository,
  })  : _repo = authenticationRepository,
        _sRepo = servicesRepository,
        super(const AuthState()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<FireBase>(_onFireBase);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    on<Expired>(_onExpired);
    _authenticationStatusSubscription = _repo.status.listen(
      (status) => add(
        AuthenticationStatusChanged(status),
      ),
    );
  }

  final AuthRepo _repo;
  final ServicesRepo _sRepo;
  late StreamSubscription<AuthStatus> _authenticationStatusSubscription;
  final FirebaseCubit firebaseCubit;

  ///whethet there is internet or not
  bool hasInternet = false;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _repo.dispose();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthState> emit,
  ) async {
    final user = await _tryGetUser();

    switch (event.status) {
      case AuthStatus.refresh:
      case AuthStatus.unknown:
        break;
      case AuthStatus.authenticated:
      case AuthStatus.unauthenticated:
        break;
      case AuthStatus.firstTime:
        break;
      case AuthStatus.expired:
        break;
      case AuthStatus.deleted:
        break;
    }
    return emit(
      state.copyWith(
        status: event.status,
        user: user,
      ),
    );
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthState> emit,
  ) =>
      _repo.logoutUser(authInstance);

  void _onExpired(Expired event, Emitter<AuthState> emit) => _repo.expired();

  Future<User?> _tryGetUser() async {
    try {
      final user = await _repo.getUser();
      log(user.toString());
      return user;
    } catch (_) {
      return null;
    }
  }

  FutureOr<void> _onFireBase(FireBase event, Emitter<AuthState> emit) {
    if(event.fireBaseUser!=null) {
      _repo.insertFirbaseUser(event.fireBaseUser);
    }
    emit(
      state.copyWith(
        fireBaseUser: event.fireBaseUser,
      ),
    );
  }
}
