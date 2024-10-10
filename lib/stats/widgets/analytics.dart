// ignore_for_file: prefer_int_literals

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:field_master/auth/bloc/auth_bloc.dart';
import 'package:field_master/utils/cubit/firebase_cubit.dart';

class AnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch service performance data from Firestore
  Future<List<AnalyticsData>> fetchAnalyticsData(String technicianId) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection(serviceRequestDoc)
          .where('createdBy', isEqualTo: technicianId)
          .get();

      final analyticsData = querySnapshot.docs.map((doc) {
        return AnalyticsData.fromMap(doc.data()! as Map<String, dynamic>);
      }).toList();

      return analyticsData;
    } catch (e) {
      throw Exception('Error fetching analytics data: $e');
    }
  }

  /// Calculate metrics based on the fetched data
  ServiceMetrics calculateMetrics(List<AnalyticsData> analyticsData) {
    final totalRequests = analyticsData.length;
    final completedRequests =
        analyticsData.where((data) => data.status == 'Complete').length;
    final averageResponseTime = _calculateAverageResponseTime(analyticsData);

    return ServiceMetrics(
      totalRequests: totalRequests,
      completedRequests: completedRequests,
      averageResponseTime: averageResponseTime,
    );
  }

  /// Calculate the average response time from the analytics data
  /// Calculate the average response time from the analytics data
  double _calculateAverageResponseTime(List<AnalyticsData> analyticsData) {
    if (analyticsData.isEmpty) return 0.0;

    final totalResponseTime = analyticsData.fold(0.0, (previousValue, data) {
      return previousValue +
          data.responseTime; // Assuming responseTime is in minutes
    });
    return totalResponseTime / analyticsData.length;
  }
}

class AnalyticsData {
  // in minutes

  AnalyticsData({
    required this.id,
    required this.status,
    required this.requestDate,
    required this.responseTime,
  });

  factory AnalyticsData.fromMap(Map<String, dynamic> data) {
    return AnalyticsData(
      id: data['id'] as int? ?? 0,
      status: data['status'] as String? ?? '',
      requestDate:
          DateTime.tryParse((data['date'] as String)) ?? DateTime.now(),
      responseTime: 2.5,
    );
  }
  final int id;
  final String status;
  final DateTime requestDate;
  final double responseTime;
}

class ServiceMetrics {
  ServiceMetrics({
    required this.totalRequests,
    required this.completedRequests,
    required this.averageResponseTime,
  });
  final int totalRequests;
  final int completedRequests;
  final double averageResponseTime;
}

// Sample widget to display analytics data
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
                Text('Total Requests: ${metrics.totalRequests}'),
                Text('Completed Requests: ${metrics.completedRequests}'),
                Text(
                  '''Average Response Time: ${metrics.averageResponseTime.toStringAsFixed(2)} min''',
                ),
                const SizedBox(height: 20),
                Expanded(child: _buildBarChart(analyticsData)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBarChart(List<AnalyticsData> analyticsData) {
    final barGroups = analyticsData.map((data) {
      return BarChartGroupData(
        x: data.requestDate.month,
        barRods: [
          BarChartRodData(
            toY: data.responseTime,
            color: Colors.blue,
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
        ),
      ),
    );
  }
}
