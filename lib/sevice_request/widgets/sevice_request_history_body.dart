import 'dart:developer';

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
    final status = serviceRequest['status'] as String? ?? '';
    log(status);
    return GestureDetector(
      onTap: () {
        Navigator.push(context, SeviceRequestPage.route(serviceRequest));
      },
      child: Dismissible(
        key: Key(serviceRequest['uuid'].toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.redAccent,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (direction) {
          context.read<SeviceRequestCubit>().deleteServiceRequest(
                serviceRequest['uuid'] as String,
                status,
              );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${serviceRequest['clientName']} deleted')),
          );
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blueAccent.withOpacity(0.1),
                      child: const Icon(
                        Icons.build,
                        color: Colors.blueAccent,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceRequest['clientName'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            serviceRequest['description'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildServiceDetailRow(
                  label: 'Address:',
                  value: serviceRequest['address'] as String? ?? '',
                  icon: Icons.location_on_outlined,
                ),
                _buildServiceDetailRow(
                  label: 'Status:',
                  value: status,
                  icon: Icons.info_outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceDetailRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Text(
            '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
