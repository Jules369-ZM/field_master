import 'dart:async';

import 'package:auth_repo/auth_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:field_master/utils/cubit/firebase_cubit.dart';
import 'package:field_master/utils/utils.dart';
import 'package:net_source/net_source.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._repo) : super(const LoginState());
  final AuthRepo _repo;

  /// Function to log in the user, to firebase
  FutureOr<void> signInWithEmailAndPassword(
    String username,
    String password,
  ) async {
    emit(
      state.copyWith(status: CurrentStatus.loading, message: 'loading'),
    );

    final res = await _repo.signInWithEmailAndPassword(
      username.toLowerCase(),
      password,
      authInstance,
    );
    if (res.success) {
      final data = res.data as JsonMap;
      final response = data['response'] as auth.UserCredential;
      final userEmpty = data['userEmpty'] as bool;
      var user = User.empty;
      if (userEmpty) {
        user = await _readUsersDocAndInsert(username, user);
      } else {
        // user = data['user'] as User;
        user = await _readUsersDocAndInsert(username, user);
      }
      if (user.id != 0) {
        await _repo.insertUser(user);
      }
      _repo.authenticated();
      if (!isClosed) {
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
      }
    } else {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: CurrentStatus.error,
            message: res.message,
          ),
        );
      }
    }
  }

  Future<User> _readUsersDocAndInsert(String username, User user) async {
    var user0 = user;
    final user1 = await navKey.currentContext!
        .read<FirebaseCubit>()
        .readDocument(collectionPath: usersDoc, id: username);
    if (user1 != null) {
      user0 = User.fromJson(user1);
    }
    return user0;
  }
}
