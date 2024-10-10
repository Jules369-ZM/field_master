import 'dart:async';

import 'package:auth_repo/auth_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:field_master/utils/cubit/firebase_cubit.dart';
import 'package:field_master/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_source/net_source.dart';
import 'package:services_repo/services_repo.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required AuthRepo repo, required ServicesRepo sRepo})
      : _repo = repo,
        _sRepo = sRepo,
        super(const RegisterState());
  final AuthRepo _repo;
  // ignore: unused_field
  final ServicesRepo _sRepo;

  /// register customer
  /// Function to log in the user, to firebase
  FutureOr<void> createUserWithEmailAndPassword(
    String username,
    String password,
    String role,
  ) async {
    emit(
      state.copyWith(status: CurrentStatus.loading, message: 'loading'),
    );

    final res = await _repo.createUserWithEmailAndPassword(
      username.toLowerCase(),
      password,
      role,
      authInstance,
    );
    if (res.success) {
      final data = res.data as JsonMap;
      final response = data['response'] as auth.UserCredential;
      final user = data['user'] as User;
      navKey.currentContext!
          .read<FirebaseCubit>()
          .addDocument(user.toJson(), usersDoc, username.toLowerCase());
      _repo.authenticated();
      emit(
        state.copyWith(
          status: CurrentStatus.success,
          message: res.message,
          data: <String, dynamic>{
            'response': response,
            'user': user,
            'email': response.user!.email,
          },
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: CurrentStatus.error,
          message: res.message,
        ),
      );
    }
  }
}
