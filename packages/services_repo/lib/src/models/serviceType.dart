// ignore_for_file: lines_longer_than_80_chars, public_member_api_docs

import 'package:uuid/uuid.dart';

class ServiceType {
  // Short description of the service (optional)

  ServiceType({
    required this.name,
    required this.iconPath,
    required this.description,
    String? id,
  }) : id = id ??
            const Uuid().v4(); // Automatically generate a UUID if not provided

  // Factory method to create a ServiceType instance from a map (e.g., from Firestore or API)
  factory ServiceType.fromMap(Map<String, dynamic> map) {
    return ServiceType(
      id: map['id'] as String,
      name: map['name'] as String,
      iconPath: map['iconPath'] as String,
      description: map['description'] as String,
    );
  }
  final String? id; // Unique identifier for the service type (e.g., UUID)
  final String? name; // Name of the service type (e.g., Electrical, Plumbing)
  final String?
      iconPath; // Path to an icon or image representing the service type (optional)
  final String? description;

  // Method to convert ServiceType instance to a map (e.g., for saving to a database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconPath': iconPath,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'ServiceType{id: $id, name: $name, iconPath: $iconPath, description: $description}';
  }
}
