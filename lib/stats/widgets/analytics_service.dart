import 'package:cloud_firestore/cloud_firestore.dart';
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
      requestDate: DateTime.tryParse(data['date'] as String) ?? DateTime.now(),
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
