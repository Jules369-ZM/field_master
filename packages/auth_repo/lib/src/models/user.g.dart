// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
      photoURL: json['photoURL'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      otherData: json['otherData'] as String? ?? '',
      details: json['details'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      role: json['role'] as String? ?? '',
      password: json['password'] as String? ?? '',
      emailVerified: json['emailVerified'] == 1,
      isAnonymous: json['isAnonymous'] == 1,
    );

///used to insert user to db
JsonMap _$UserToMap(Map<String, dynamic> json) => <String, dynamic>{
      'id': json['id'] as int,
      'name': json['name'] as String? ?? '',
      'phoneNumber': json['phoneNumber'] as String? ?? '',
      'email': json['email'] as String? ?? '',
      'photoURL': json['photoURL'] as String? ?? '',
      'displayName': json['displayName'] as String? ?? '',
      'uid': json['uid'] as String? ?? '',
      'otherData': json['otherData'] as String? ?? '',
      'details': json['details'] as String? ?? '',
      'password': json['password'] as String? ?? '',
      'role': json['role'] as String? ?? '',
      'emailVerified': json['emailVerified'] == true ? 1 : 0,
      'isAnonymous': json['isAnonymous'] == true ? 1 : 0,
    };

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email.toLowerCase(),
      'photoURL': instance.photoURL,
      'displayName': instance.displayName,
      'uid': instance.uid,
      'details': instance.details,
      'otherData': instance.otherData,
      'password': instance.password,
      'role': instance.role,
      'emailVerified': instance.emailVerified ? 1 : 0,
      'isAnonymous': instance.isAnonymous ? 1 : 0,
    };
