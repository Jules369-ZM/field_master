import 'package:auth_repo/src/models/user.dart';
import 'package:field_master/auth/bloc/auth_bloc.dart';
import 'package:field_master/home/cubit/cubit.dart';
import 'package:field_master/sevice_request/sevice_request.dart';
import 'package:field_master/sevice_request/view/sevice_request_history.dart';
import 'package:field_master/utils/utils.dart';
import 'package:field_master/widgets/app_container.dart';
import 'package:field_master/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:net_source/net_source.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  void initState() {
    super.initState();
  }

  Map<String, dynamic>? filterServiceRequests(
    List<Map<String, dynamic>> requests,
  ) {
    final now = DateTime.now();
    final filteredRequests = requests.where((request) {
      final createdAtStr = request['createdAt'] as String?;
      final createdAt =
          createdAtStr != null ? DateTime.tryParse(createdAtStr) : null;
      return createdAt != null &&
          createdAt.isAfter(now.subtract(const Duration(days: 1))) &&
          request['status'] == 'Pending';
    }).toList();

    return filteredRequests.isNotEmpty
        ? filteredRequests.reduce((a, b) {
            final aAt = DateTime.tryParse(a['createdAt'] as String) ?? now;
            final bAt = DateTime.tryParse(b['createdAt'] as String) ?? now;
            return aAt.isAfter(bAt) ? a : b;
          })
        : null;
  }

  @override
  Widget build(BuildContext context_) {
    final user = context_.watch<AuthBloc>().state.user;
    final data = context_.watch<HomeCubit>().state.data;
    final count = context_.watch<HomeCubit>().state.count ??
        {
          'Pending': 0,
          'InProgress': 0,
          'Complete': 0,
        };
    var serviceRequests = <JsonMap>[];
    JsonMap? upcomingService;
    if (data != null && data.isNotEmpty) {
      serviceRequests = data['serviceRequest'] as List<Map<String, dynamic>>;
    }
    if (serviceRequests.isNotEmpty) {
      upcomingService = filterServiceRequests(serviceRequests);
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          'Service Request',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(context, SeviceRequestPage.route(null));
        },
        splashColor: Theme.of(context_).splashColor,
        backgroundColor: Theme.of(context_).colorScheme.secondary,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == CurrentStatus.loading) {
            return const LoadingScreen();
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                AppContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Service Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSummaryCard(
                            'Pending',
                            count['Pending'].toString(),
                            Colors.orangeAccent,
                          ),
                          _buildSummaryCard(
                            'In Progress',
                            count['InProgress'].toString(),
                            Colors.lightBlue,
                          ),
                          _buildSummaryCard(
                            'Completed',
                            count['Complete'].toString(),
                            Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (upcomingService != null)
                  AppContainer(
                    type: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Next Service Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          dense: true,
                          leading: const Icon(
                            Icons.location_on,
                            color: Colors.blueAccent,
                          ),
                          title: Text(
                            upcomingService['clientName'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            upcomingService['address'] as String? ?? '',
                            style: const TextStyle(color: Colors.black),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              SeviceRequestPage.route(upcomingService),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                if (serviceRequests.isEmpty)
                  const MessageScreen(
                    message: 'You have no services',
                    // textStyle: TextStyle(color: Colors.redAccent),
                  ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics:  const NeverScrollableScrollPhysics(),
                    itemCount: serviceRequests.length,
                    itemBuilder: (context, i) {
                      final req = serviceRequests[i];
                      return _buildServiceCard(context, i, req);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  ListTile _header(User user) {
    return ListTile(
                dense: true,
                title: Text(
                  getGreeting(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.indigo,
                  ),
                ),
                subtitle: Text(
                  user.displayName.isEmpty ? user.email : 'Unknown',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Colors.indigoAccent,
                  ),
                ),
              );
  }

  Widget _buildSummaryCard(String title, String count, Color color) {
    var status = 'Pending';
    if (title == 'In Progress') {
      status = 'In Progress';
    } else if (title == 'Completed') {
      status = 'Complete';
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(context, SeviceRequestHistoryPage.route(status));
      },
      child: Card(
        color: color,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                count,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    int index,
    JsonMap serviceRequest,
  ) {
    return Dismissible(
      key: Key(serviceRequest['uuid'].toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        context
            .read<HomeCubit>()
            .deleteServiceRequest(serviceRequest['uuid'] as String, context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${serviceRequest['clientName']} deleted')),
        );
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          dense: true,
          leading: const Icon(Icons.build, color: Colors.blueAccent),
          title: Text(
            serviceRequest['clientName'] as String,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
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
