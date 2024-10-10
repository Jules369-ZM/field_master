part of 'config.dart';

Config _$ConfigFromJson(Map<String, dynamic> json) => Config(
      baseUrl: json['baseUrl'] as String,
      socketUrl: json['socketUrl'] as String,
      dbName: json['dbName'] as String,
      host: json['host'] as String,
      initScript: json['initScript'] as List<String>,
      migrations: json['migrations'] as List<String>,
    );

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'baseUrl': instance.baseUrl,
      'socketUrl': instance.socketUrl,
      'dbName': instance.dbName,
      'host': instance.host,
      'initScript': instance.initScript,
      'migrations': instance.migrations,
    };
