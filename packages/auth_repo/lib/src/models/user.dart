import 'package:equatable/equatable.dart';
import 'package:net_source/net_source.dart';

part 'user.g.dart';

/// {@template user}
/// A single user item.
///
/// Contains a [name], [phoneNumber], [email], [photoURL], [displayName]
/// and [id]
///
/// [User]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro User}
  const User({
    required this.id,
    this.name = '',
    this.phoneNumber = '',
    this.email = '',
    this.photoURL = '',
    this.displayName = '',
    this.details = '',
    this.otherData = '',
    this.role = '',
    this.password = '',
    this.emailVerified = false,
    this.uid = '',
    this.isAnonymous = false,
  });

  /// The unique identifier of the User.
  final int id;

  /// The name of the User.
  ///
  /// Note that the name may be empty.
  final String name;

  /// The phone number of the User.
  ///
  /// Defaults to an empty string.
  final String phoneNumber;

  /// The email address of the User.
  ///
  /// Defaults to an empty string.
  final String email;

  /// The profile photo of the User.
  ///
  /// Defaults to an empty string.
  final String photoURL;

  /// The wallet number of the User.
  ///
  /// Defaults to empty string.
  // @JsonKey(name: 'wallet_number')
  final String displayName;

  /// Whether the User has a security question.
  ///
  /// Defaults to false.
  // @JsonKey(name: 'has_security_question')
  final bool emailVerified;

  /// Whether the User has uploaded an id.
  ///
  /// Defaults to false.
  // @JsonKey(name: 'has_uploaded_id')
  final bool isAnonymous;

  /// Defaults to false.
  // @JsonKey(name: 'type')
  final String uid;

  /// Defaults to false.
  // @JsonKey(name: 'type')
  final String details;

  /// Defaults to false.
  // @JsonKey(name: 'type')
  final String otherData;

  ///
  final String password;

  /// Defaults to "".
  final String role;

  /// Returns a copy of this User with the given values updated.
  ///
  /// {@macro User}
  User copyWith({
    int? id,
    String? name,
    String? displayName,
    String? phoneNumber,
    String? email,
    String? photoURL,
    String? uid,
    String? details,
    String? otherData,
    String? role,
    String? password,
    bool? emailVerified,
    bool? isAnonymous,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      displayName: displayName ?? this.displayName,
      emailVerified: emailVerified ?? this.emailVerified,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      uid: uid ?? this.uid,
      details: details ?? this.details,
      otherData: otherData ?? this.otherData,
      role: role ?? this.role,
      password: password ?? this.password,
    );
  }

  /// Returns an empty instance of the [User] class.
  static const empty = User(id: 0);

  /// Deserializes the given [JsonMap] into a [User].
  static User fromJson(JsonMap json) => _$UserFromJson(json);

  /// Deserializes the given [JsonMap] into a [User].
  static JsonMap toMap(JsonMap json) => _$UserToMap(json);

  /// Converts this [User] into a [JsonMap].
  JsonMap toJson() => _$UserToJson(this);

  ///
  String get loggedInAs => role;

  @override
  List<Object> get props => [
        id,
        name,
        phoneNumber,
        email,
        photoURL,
        displayName,
        emailVerified,
        emailVerified,
        isAnonymous,
        uid,
        details,
        role,
        password,
      ];
}
