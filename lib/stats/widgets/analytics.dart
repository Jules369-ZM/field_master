// ignore_for_file: prefer_int_literals

import 'package:field_master/auth/bloc/auth_bloc.dart';
import 'package:field_master/stats/widgets/analytics_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyticsScreen extends StatelessWidget {
  AnalyticsScreen({super.key});
  final AnalyticsService analyticsService = AnalyticsService();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;
    return Scaffold(
      body: FutureBuilder<List<AnalyticsData>>(
        future: analyticsService.fetchAnalyticsData(user.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final analyticsData = snapshot.data ?? [];
          final metrics = analyticsService.calculateMetrics(analyticsData);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetricsCard(metrics),
                const SizedBox(height: 20),
                Expanded(child: _buildBarChart(analyticsData)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricsCard(ServiceMetrics metrics) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Service Performance Metrics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 12),
            _buildMetricItem(
              label: 'Total Requests',
              value: metrics.totalRequests.toString(),
              icon: Icons.request_page,
            ),
            const SizedBox(height: 8),
            _buildMetricItem(
              label: 'Completed Requests',
              value: metrics.completedRequests.toString(),
              icon: Icons.check_circle_outline,
            ),
            const SizedBox(height: 8),
            _buildMetricItem(
              label: 'Avg. Response Time',
              value: '${metrics.averageResponseTime.toStringAsFixed(2)} min',
              icon: Icons.timer_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(List<AnalyticsData> analyticsData) {
    final barGroups = analyticsData.map((data) {
      return BarChartGroupData(
        x: data.requestDate.month,
        barRods: [
          BarChartRodData(
            toY: data.responseTime,
            color: Colors.blueAccent,
            width: 16,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      );
    }).toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            maxY: 10, // Example max Y value, adjust based on your data
            gridData: const FlGridData(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 2,
                  getTitlesWidget: (value, _) => Text(value.toString()),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    return Text(_getMonthLabel(value.toInt()));
                  },
                ),
              ),
            ),
            barGroups: barGroups,
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }

  String _getMonthLabel(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }
}
