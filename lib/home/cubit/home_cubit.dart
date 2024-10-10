import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:field_master/auth/bloc/auth_bloc.dart';
import 'package:field_master/utils/cubit/firebase_cubit.dart';
import 'package:field_master/utils/utils.dart';
import 'package:net_source/net_source.dart';
import 'package:services_repo/services_repo.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._sRepo) : super(const HomeState());
  final ServicesRepo _sRepo;

  Future<FutureOr<void>> getExpenseCategory() async {
    emit(state.copyWith(status: CurrentStatus.loading));
    if (isClosed) return null;
    emit(
      state.copyWith(
        status: CurrentStatus.success,
      ),
    );
  }

  Future<FutureOr<void>> insertDefaultCategory() async {
    await _sRepo.insertDefaultCategory();
  }

  Future<void> getServiceRequest(BuildContext cntxt) async {
    // createdBy
    emit(state.copyWith(status: CurrentStatus.loading));
    final user = navKey.currentContext!.watch<AuthBloc>().state.user;
    final data = state.data ?? {};
    final res =
        await navKey.currentContext!.read<FirebaseCubit>().getDocumentsByUserId(
              collectionPath: serviceRequestDoc,
              feild: 'createdBy',
              value: user.email,
            );
    data['serviceRequest'] = res;
    if (!isClosed) {
      emit(
        state.copyWith(
          status: CurrentStatus.success,
          data: data,
        ),
      );
    }
  }

  Future<void> countDocumentsByStatus() async {
    emit(state.copyWith(status: CurrentStatus.loading));
    var data = state.count ??
        {
          'Pending': 0,
          'InProgress': 0,
          'Complete': 0,
        };
    final res = await navKey.currentContext!
        .read<FirebaseCubit>()
        .countDocumentsByStatus(
          serviceRequestDoc,
        );
    data = res;
    if (!isClosed) {
      emit(
        state.copyWith(
          status: CurrentStatus.success,
          count: data,
        ),
      );
    }
  }

  Future<void> deleteServiceRequest(String uuid, BuildContext cntxt) async {
    await navKey.currentContext!
        .read<FirebaseCubit>()
        .deleteDocument(collectionPath: serviceRequestDoc, id: uuid);
    if (navKey.currentContext!.mounted) {
      await getServiceRequest(cntxt);
    }
  }
}
