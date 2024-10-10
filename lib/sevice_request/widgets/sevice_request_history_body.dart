import 'package:field_master/main/cubit/main_cubit.dart';
import 'package:field_master/sevice_request/cubit/cubit.dart';
import 'package:field_master/sevice_request/view/sevice_request_page.dart';
import 'package:field_master/utils/cubit/firebase_cubit.dart';
import 'package:field_master/utils/utils.dart';
import 'package:field_master/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:net_source/net_source.dart';

/// {@template sevice_request_body}
/// Body of the SeviceRequestPage.
///
/// Add what it does
/// {@endtemplate}
class SeviceRequestHistoryBody extends StatefulWidget {
  /// {@macro sevice_request_body}
  const SeviceRequestHistoryBody({super.key});

  @override
  State<SeviceRequestHistoryBody> createState() =>
      _SeviceRequestHistoryBodyState();
}

class _SeviceRequestHistoryBodyState extends State<SeviceRequestHistoryBody> {
  @override
  Widget build(BuildContext context) {
    final status =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Pending';
    context.watch<MainCubit>();
    final data = context.watch<SeviceRequestCubit>().state.history;

    var serviceRequests = <JsonMap>[];

    return BlocConsumer<FirebaseCubit, FirebaseState>(
      listener: (context, state) {
        if (state.status == CurrentStatus.error) {
          EasyLoadingService.error(text: state.message);
        }
      },
      builder: (context, state) {
        return BlocBuilder<SeviceRequestCubit, SeviceRequestState>(
          builder: (context, state) {
            if (state.status == CurrentStatus.loading) {
              return const LoadingScreen();
            }
            if (state.status == CurrentStatus.error) {
              return MessageScreen(message: state.message);
            }
            if (data != null && data.isNotEmpty) {
              serviceRequests =
                  data['serviceRequest'] as List<Map<String, dynamic>>;
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: serviceRequests.length,
                itemBuilder: (context, i) {
                  final req = serviceRequests[i];
                  return _buildServiceCard(context, i, req, status);
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    int index,
    JsonMap serviceRequest,
    String status,
  ) {
    return Dismissible(
      key: Key(
        serviceRequest['uuid'].toString(),
      ), // Ensure each item has a unique key
      direction: DismissDirection.endToStart, // Swipe from right to left
      background: Container(
        color: Colors.red, // Red background indicating delete
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        // Perform the deletion
        context
            .read<SeviceRequestCubit>()
            .deleteServiceRequest(serviceRequest['uuid'] as String, status);

        // Optionally show a snackbar after deletion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${serviceRequest['clientName']} has been deleted'),
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          dense: true,
          leading: const Icon(Icons.build, color: Colors.blueAccent),
          title: Text(serviceRequest['clientName'] as String),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Description:'),
                  const Spacer(),
                  Text(serviceRequest['description'] as String),
                ],
              ),
              Row(
                children: [
                  const Text('Address:'),
                  const Spacer(),
                  Text(serviceRequest['address'] as String? ?? ''),
                ],
              ),
              Row(
                children: [
                  const Text('Status:'),
                  const Spacer(),
                  Text(serviceRequest['status'] as String? ?? ''),
                ],
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(context, SeviceRequestPage.route(serviceRequest));
          },
        ),
      ),
    );
  }
}
