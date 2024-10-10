import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:field_master/settings/cubit/cubit.dart';
import 'package:field_master/utils/cubit/firebase_cubit.dart';
import 'package:field_master/utils/utils.dart';
import 'package:net_source/net_source.dart';
part 'sevice_request_state.dart';

class SeviceRequestCubit extends Cubit<SeviceRequestState> {
  SeviceRequestCubit() : super(const SeviceRequestState());

  /// A description for yourCustomFunction
  FutureOr<void> yourCustomFunction() {}

  FutureOr<void> submitRequest(Map<String, String> data) {
    emit(state.copyWith(status: CurrentStatus.loading));
    // navKey.currentContext!
    //     .read<FirebaseCubit>()
    //     .addDocument(data, serviceRequestDoc);
    emit(state.copyWith(status: CurrentStatus.success));
  }

  Future<void> getServiceRequestByStatus(String status) async {
    // createdBy
    emit(state.copyWith(status: CurrentStatus.loading));
    // final data = state.data ?? {};
    final res = await navKey.currentContext!
        .read<FirebaseCubit>()
        .readDocumentsByStatus(
          collectionPath: serviceRequestDoc,
          status: status,
        );

    emit(
      state.copyWith(
        status: CurrentStatus.success,
        history: {
          'serviceRequest': res,
        },
      ),
    );
  }

  Future<void> deleteServiceRequest(String uuid, String status) async {
    await navKey.currentContext!
        .read<FirebaseCubit>()
        .deleteDocument(collectionPath: serviceRequestDoc, id: uuid);
    await getServiceRequestByStatus(status);
  }
}
