import 'package:flutter/material.dart';
import 'package:field_master/sevice_request/cubit/cubit.dart';
import 'package:field_master/sevice_request/widgets/sevice_request_history_body.dart';

/// {@template sevice_request_page}
/// A description for SeviceRequestPage
/// {@endtemplate}
class SeviceRequestHistoryPage extends StatelessWidget {
  /// {@macro sevice_request_page}
  const SeviceRequestHistoryPage({super.key});

  /// The static route for SeviceRequestPage
  static Route<dynamic> route(String? status) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const SeviceRequestHistoryPage(),
      settings: RouteSettings(arguments: status),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Pending';
    return BlocProvider(
      create: (context) =>
          SeviceRequestCubit()..getServiceRequestByStatus(status),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Service Request History'),
        ),
        body: const SeviceRequestView(),
      ),
    );
  }
}

/// {@template sevice_request_view}
/// Displays the Body of SeviceRequestView
/// {@endtemplate}
class SeviceRequestView extends StatelessWidget {
  /// {@macro sevice_request_view}
  const SeviceRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SeviceRequestHistoryBody();
  }
}
