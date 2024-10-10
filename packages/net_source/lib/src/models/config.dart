part 'config.g.dart';

/// {@template config}
/// Config description
/// {@endtemplate}
class Config {
  /// {@macro config}
  const Config({
    required this.baseUrl,
    required this.socketUrl,
    required this.dbName,
    required this.host,
    required this.initScript,
    this.migrations = const [],
  });

  /// Creates an empty Config
  factory Config.empty() => const Config(
        baseUrl: '',
        socketUrl: '',
        dbName: '',
        host: '',
        initScript: [],
      );

  /// Creates a Config from Json map
  factory Config.fromJson(Map<String, dynamic> data) => _$ConfigFromJson(data);

  /// A description for baseUrl
  final String baseUrl;

  /// A description for socketUrl
  final String socketUrl;

  /// A description for dbName
  final String dbName;

  /// A description for host
  final String host;

  /// A description for initScript
  final List<String> initScript;

  /// A description for migrations
  final List<String> migrations;

  /// Creates a copy of the current Config with property changes
  Config copyWith({
    String? baseUrl,
    String? socketUrl,
    String? dbName,
    String? host,
    List<String>? initScript,
    List<String>? migrations,
  }) {
    return Config(
      baseUrl: baseUrl ?? this.baseUrl,
      socketUrl: socketUrl ?? this.socketUrl,
      dbName: dbName ?? this.dbName,
      host: host ?? this.host,
      initScript: initScript ?? this.initScript,
      migrations: migrations ?? this.migrations,
    );
  }

  /// Creates a Json map from a Config
  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
