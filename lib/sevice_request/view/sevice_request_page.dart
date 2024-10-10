import 'package:flutter/material.dart';
import 'package:field_master/sevice_request/cubit/cubit.dart';
import 'package:field_master/sevice_request/widgets/send_sms_form.dart';
import 'package:field_master/sevice_request/widgets/sevice_request_body.dart';
import 'package:net_source/net_source.dart';

/// {@template sevice_request_page}
/// A description for SeviceRequestPage
/// {@endtemplate}
class SeviceRequestPage extends StatelessWidget {
  /// {@macro sevice_request_page}
  const SeviceRequestPage({super.key});

  /// The static route for SeviceRequestPage
  static Route<dynamic> route(JsonMap? seviceRequest) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const SeviceRequestPage(),
      settings: RouteSettings(arguments: seviceRequest),
    );
  }

  @override
  Widget build(BuildContext context) {
    final seviceRequest =
        ModalRoute.of(context)?.settings.arguments as JsonMap?;
    final isEdit = seviceRequest != null && seviceRequest.isNotEmpty;
    return BlocProvider(
      create: (context) => SeviceRequestCubit(),
      child: Scaffold(
        // onOrderPlaced(phoneNumber: '+260972489279');

        floatingActionButton: isEdit
            ? FloatingActionButton.extended(
                label: const Text(
                  'Send SMS',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(Icons.message, color: Colors.white),
                onPressed: () async {
                  showSendSmsBottomSheet(
                    context,
                    seviceRequest['phone'] as String? ?? '',
                  );
                },
                splashColor: Theme.of(context).splashColor,
                backgroundColor: Theme.of(context).colorScheme.primary,
              )
            : null,
        appBar: AppBar(
          title: const Text('New Service Request'),
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
    return const SeviceRequestBody();
  }
}
