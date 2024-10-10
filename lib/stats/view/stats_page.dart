import 'package:flutter/material.dart';
import 'package:field_master/stats/cubit/cubit.dart';
import 'package:field_master/stats/widgets/analytics.dart';

/// {@template stats_page}
/// A description for StatsPage
/// {@endtemplate}
class StatsPage extends StatelessWidget {
  /// {@macro stats_page}
  const StatsPage({super.key});

  /// The static route for StatsPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const StatsPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatsCubit(context.read()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Service Analytics')),
        body: const StatsView(),
      ),
    );
  }
}

/// {@template stats_view}
/// Displays the Body of StatsView
/// {@endtemplate}
class StatsView extends StatelessWidget {
  /// {@macro stats_view}
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalyticsScreen();
  }
}
