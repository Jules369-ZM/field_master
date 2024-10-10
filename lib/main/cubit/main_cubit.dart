// ignore_for_file: unused_field

import 'dart:async';

import 'package:auth_repo/auth_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:field_master/auth/bloc/auth_bloc.dart';
import 'package:field_master/utils/constants.dart';
import 'package:field_master/utils/cubit/firebase_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:net_source/net_source.dart';
import 'package:services_repo/services_repo.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit(this._repo, this._sRepo) : super(const MainState()) {
    setupLocation();
  }
  final AuthRepo _repo;
  final ServicesRepo _sRepo;
  Future<void> setupLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      // Permissions are denied forever, handle appropriately.
      return;
    }

    await getLocation();
  }

  Future<void> getLocation() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
    } else {}
    final p = await Geolocator.getCurrentPosition();
    if (!isClosed) emit(state.copyWith(position: p));
  }

  Future<void> getServiceRequest() async {
    // createdBy
    emit(state.copyWith(status: CurrentStatus.loading));
    final user = navKey.currentContext!.watch<AuthBloc>().state.user;
    final data = state.data ?? {};
    final res =
        await navKey.currentContext!.read<FirebaseCubit>().getDocumentsByUserId(
              collectionPath: serviceRequestDoc,
              feild: 'email',
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
    // createdBy
    emit(state.copyWith(status: CurrentStatus.loading));
    final data = state.data ?? {};
    final res = await navKey.currentContext!
        .read<FirebaseCubit>()
        .countDocumentsByStatus(
          serviceRequestDoc,
        );
    data['count'] = res;
    if (!isClosed) {
      emit(
        state.copyWith(
          status: CurrentStatus.success,
          data: data,
        ),
      );
    }
  }
}
