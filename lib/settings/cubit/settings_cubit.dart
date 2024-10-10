// ignore_for_file: unused_field

import 'dart:async';

import 'package:auth_repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:field_master/utils/constants.dart';
import 'package:net_source/net_source.dart';
import 'package:services_repo/services_repo.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repo, this._sRepo) : super(const SettingsState());
  final AuthRepo _repo;
  final ServicesRepo _sRepo;

  /// A description for yourCustomFunction
  FutureOr<void> yourCustomFunction() {}
}
