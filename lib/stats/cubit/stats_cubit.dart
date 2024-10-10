import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:field_master/utils/constants.dart';
import 'package:net_source/net_source.dart';
import 'package:services_repo/services_repo.dart';
part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  StatsCubit(this._repo) : super(const StatsState());

  final ServicesRepo _repo;

  Future<void> getTransactions() async {
    emit(state.copyWith(status: CurrentStatus.loading));
    final expenses = await _repo.getExpenses();

    emit(
      state.copyWith(
        status: CurrentStatus.success,
        expenses: expenses,
        message: expenses.isEmpty ? 'Currently no expenses available' : '',
      ),
    );
  }
}
