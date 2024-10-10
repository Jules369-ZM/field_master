// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:net_source/net_source.dart';
import 'package:services_repo/src/models/serviceType.dart';
import 'package:uuid/uuid.dart';

enum ServiceStatus { Pending, InProgress, Completed }

class LocationDetails {
  LocationDetails({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory LocationDetails.fromMap(Map<String, dynamic> map) {
    return LocationDetails(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      address: map['address'] as String,
    );
  }
  final double latitude;
  final double longitude;
  final String address;

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  @override
  String toString() {
    return 'LocationDetails{latitude: $latitude, longitude: $longitude, address: $address}';
  }
}

class ServiceRequest {
  // Type/category of the service

  ServiceRequest({
    required this.clientName,
    required this.serviceDescription,
    required this.date,
    required this.time,
    required this.location,
    required this.serviceType,
    String? id,
    this.imagePaths = const [],
    this.status = ServiceStatus.Pending,
  }) : id = id ?? const Uuid().v4(); // Automatically generate a UUID if not

  factory ServiceRequest.fromMap(
    Map<String, dynamic> map,
    ServiceType serviceType,
  ) {
    return ServiceRequest(
      id: map['id'] as String,
      clientName: map['clientName'] as String,
      serviceDescription: map['serviceDescription'] as String,
      date: DateTime.parse(map['date'] as String),
      time: TimeOfDay(
        hour: int.parse(map['time'].split(':')[0] as String),
        minute: int.parse(map['time'].split(':')[1] as String),
      ),
      location: LocationDetails.fromMap(map['location'] as JsonMap),
      imagePaths: List<String>.from(map['imagePaths'] as List<String>),
      status: ServiceStatus.values.firstWhere(
        (e) => e.toString() == 'ServiceStatus.${map['status']}',
        orElse: () => ServiceStatus.Pending,
      ),
      serviceType: serviceType,
    );
  }
  final String id; // Unique identifier for the service request
  final String clientName; // Name of the client
  final String serviceDescription; // Description of the service
  final DateTime date; // Date of the service
  final TimeOfDay time; // Time of the service
  final LocationDetails location; // Location details
  final List<String> imagePaths; // Paths to images related to the service
  final ServiceStatus status; // Current status of the service
  final ServiceType serviceType;

  // Method to convert ServiceRequest instance to a map (e.g., f
  //or saving to a database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientName': clientName,
      'serviceDescription': serviceDescription,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
      'location': location.toMap(),
      'imagePaths': imagePaths,
      'status': status.toString().split('.').last,
      'serviceTypeId': serviceType.id, // Reference to ServiceType
    };
  }

  @override
  String toString() {
    return '''ServiceRequest{id: $id, clientName: $clientName, serviceDescription: $serviceDescription, date: $date, time: $time, location: $location, imagePaths: $imagePaths, status: $status, serviceType: ${serviceType.name}}''';
  }
}

ServiceType electricalService = ServiceType(
  name: 'Electrical',
  iconPath: 'assets/icons/electrical.png',
  description: 'Electrical repairs and installations',
);

ServiceRequest newRequest = ServiceRequest(
  clientName: 'John Doe',
  serviceDescription: 'Fixing the electrical wiring in the kitchen',
  date: DateTime.now(),
  time: const TimeOfDay(hour: 10, minute: 30),
  location: LocationDetails(
    latitude: 28.346393250820945,
    longitude: -15.405184731629454,
    address: '123 Main St, San Francisco, CA',
  ),
  imagePaths: ['path/to/image1.png', 'path/to/image2.png'],
  serviceType: electricalService,
);
