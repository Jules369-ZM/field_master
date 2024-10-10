import 'dart:developer';

// import 'package:auth_repo/src/models/user.dart';
import 'package:auth_repo/auth_repo.dart';
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
  bool fisrt = true;
  @override
  void initState() {
    super.initState();
    fisrt = true;
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
    } else {
      if (fisrt) {
        context.read<HomeCubit>()
          ..getServiceRequest(context)
          ..countDocumentsByStatus();
        fisrt = false;
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          'Service Request',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold, // Bold text for emphasis
          ),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(context, SeviceRequestPage.route(null));
        },
        splashColor: Theme.of(context).splashColor,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // Rounded corners for a softer look
        ),
        elevation: 6, // Add elevation for a floating effect
        tooltip: 'Request a service', // Provide a tooltip for accessibility
        // Add a shadow for depth
        focusElevation: 12,
        hoverElevation: 12,
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
                _header(user),
                Divider(
                  thickness: 2,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                Expanded(
                  child: SingleChildScrollView(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                          ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: serviceRequests.length,
                          itemBuilder: (context, i) {
                            final req = serviceRequests[i];
                            return _buildServiceCard(context, i, req);
                          },
                        ),
                        if (serviceRequests.isNotEmpty)
                          const SizedBox(height: 56),
                      ],
                    ),
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
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ), // Add some padding for spacing
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        radius: 30,
        child: const Icon(
          Icons.person, // Placeholder icon for user profile
          size: 32,
          color: Colors.white,
        ),
      ),
      title: Text(
        getGreeting(),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        user.displayName.isEmpty
            ? user.email
            : 'Unknown', // Keep the same logic
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 20,
          color: Colors.grey,
        ),
      ),
      // trailing: IconButton(
      //   icon: const Icon(
      //     Icons.settings, // Add a settings icon for additional action
      //     color: Colors.blueAccent,
      //   ),
      //   onPressed: () {
      //     // Define action when the settings icon is pressed
      //   },
      // ),
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
          context
              .read<HomeCubit>()
              .deleteServiceRequest(serviceRequest['uuid'] as String, context);

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
