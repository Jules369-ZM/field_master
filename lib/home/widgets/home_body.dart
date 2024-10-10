import 'package:flutter/material.dart';
import 'package:field_master/auth/bloc/auth_bloc.dart';
import 'package:field_master/home/cubit/cubit.dart';
import 'package:field_master/sevice_request/sevice_request.dart';
import 'package:field_master/sevice_request/view/sevice_request_history.dart';
import 'package:field_master/utils/utils.dart';
import 'package:field_master/widgets/app_container.dart';
import 'package:field_master/widgets/widgets.dart';
import 'package:net_source/net_source.dart';

/// {@template home_body}
/// Body of the HomePage.
///
/// Add what it does
/// {@endtemplate}
class HomeBody extends StatefulWidget {
  /// {@macro home_body}
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  void initState() {
    super.initState();
    // context.read<HomeCubit>().getExpenses();
  }

// Function to filter service requests based on createdAt and status
  Map<String, dynamic>? filterServiceRequests(
    List<Map<String, dynamic>> requests,
  ) {
    // Get the current date and time
    final now = DateTime.now();

    // Filter requests created today or later with status 'Pending'
    final filteredRequests = requests.where((request) {
      // Parse createdAt to DateTime
      final createdAtStr = request['createdAt'] as String?;
      final createdAt =
          createdAtStr != null ? DateTime.tryParse(createdAtStr) : null;

      // Check conditions: createdAt is today or later and status is 'Pending'
      return createdAt != null &&
          createdAt.isAfter(
            now.subtract(
              const Duration(days: 1),
            ),
          ) && // this includes today and future requests
          request['status'] == 'Pending';
    }).toList();

    // Return the first matching request or null if none found
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
// Usage
      upcomingService = filterServiceRequests(serviceRequests);
      // log(upcomingService.toString();
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
        backgroundColor: Theme.of(context_).colorScheme.primary,
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
                ListTile(
                  dense: true,
                  title: Text(
                    getGreeting(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(
                    user.displayName.isEmpty ? user.email : 'Uknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                ),

                const Divider(thickness: 2),

                AppContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Service summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSummaryCard(
                            'Pending',
                            count['Pending'].toString(),
                            Colors.orange,
                          ),
                          _buildSummaryCard(
                            'In Progress',
                            count['InProgress'].toString(),
                            Colors.blueAccent,
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
                          'Next service location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
                          title: Text(upcomingService['clientName'] as String),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  // const Text('Address:'),
                                  // const Spacer(),
                                  Text(
                                    upcomingService['address'] as String? ?? '',
                                  ),
                                ],
                              ),
                            ],
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

                // Service Request List
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        serviceRequests.length, // Dynamic service request count
                    itemBuilder: (context, i) {
                      final req = serviceRequests[i];
                      return _buildServiceCard(context, i, req);
                    },
                  ),
                ),
              ],
            ),
          );
          // final expenses = state.expenses;
          // if (expenses.isEmpty) {
          //   return const MessageScreen(message: 'You have no Expenses');
          // }
          // print(expenses);
          // return Padding(
          //   padding: const EdgeInsets.only(top: 24, left: 12, right: 12),
          //   child: ListView.separated(
          //     // key: UniqueKey(),
          //     shrinkWrap: true,
          //     itemCount: expenses.length,
          //     separatorBuilder: (BuildContext context, int index) {
          //       return const Divider(height: 8);
          //     },
          //     itemBuilder: (BuildContext context, int index) {
          //       final exp = expenses[index];
          //       final img = exp.image;
          //       return Dismissible(
          //         key: Key(exp.id.toString()),
          //         onDismissed: (item) {
          //           context.read<HomeCubit>().deleteExpense(exp.id.toString());
          //         },
          //         child: ListTile(
          //           // dense: true,
          //           contentPadding: EdgeInsets.zero,
          //           leading: CircleAvatar(
          //             backgroundImage:
          //                 img.isEmpty ? null : MemoryImage(base64.decode(img)),
          //             foregroundImage: img.isNotEmpty
          //                 ? null
          //                 : const AssetImage('assets/wallet.png'),
          //           ),
          //           title: Text(exp.category),
          //           subtitle: Text(exp.date),
          //           trailing: Text(formatMoney(double.parse(exp.amount))),
          //         ),
          //       );
          //     },
          //   ),
          // );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, Color color) {
    var status = 'Pending';
    if (title == 'In Progress') {
      status = 'In Progress';
    } else if (title == 'Completed') {
      status = 'Complete';
    } else {
      status = 'Pending';
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(context, SeviceRequestHistoryPage.route(status));
      },
      child: Card(
        color: color,
        elevation: 2,
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
            .read<HomeCubit>()
            .deleteServiceRequest(serviceRequest['uuid'] as String, context);

        // Optionally show a snackbar after deletion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${serviceRequest['clientName']} deleted')),
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
