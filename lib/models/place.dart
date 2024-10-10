import 'package:equatable/equatable.dart';

/// {@template place}
/// Place description
/// {@endtemplate}
class Place extends Equatable {
  /// {@macro place}
  const Place({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.id,
    required this.city,
    required this.description,
  });

  /// Creates a Place from Json map
  factory Place.fromJson(Map<String, dynamic> json) => Place(
        name: json['name'] as String,
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
        address: json['address'] as String,
        id: json['id'] as int,
        city: json['city'] as String,
        description: json['description'] as String,
      );

  /// A description for name
  final String name;

  /// A description for latitude
  final double latitude;

  /// A description for longitude
  final double longitude;

  /// A description for address
  final String address;

  /// A description for id
  final int id;

  /// A description for city
  final String city;

  /// A description for description
  final String description;

  /// Creates a copy of the current Place with property changes
  Place copyWith({
    String? name,
    double? latitude,
    double? longitude,
    String? address,
    int? id,
    String? city,
    String? description,
  }) {
    return Place(
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      id: id ?? this.id,
      city: city ?? this.city,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
        name,
        latitude,
        longitude,
        address,
        id,
        city,
        description,
      ];

  /// Creates a Json map from a Place
  Map<String, dynamic> toJson(Place instance) => <String, dynamic>{
        'name': instance.name,
        'latitude': instance.latitude,
        'longitude': instance.longitude,
        'address': instance.address,
        'id': instance.id,
        'city': instance.city,
        'description': instance.description,
      };
}

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    this.address,
  });
  final double latitude;
  final double longitude;
  final String? address;
}
