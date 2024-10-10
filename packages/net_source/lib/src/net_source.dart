import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:net_source/src/models/models.dart';
import 'package:phoenix_socket/phoenix_socket.dart';

/// {@template net_source}
/// Package to handle network calls
/// {@endtemplate}
class NetSource {
  /// {@macro net_source}
  NetSource._create();

  /// Public factory
  static Future<NetSource> init({
    required String baseUrl,
    required String socketUrl,
    required String host,
    String? token,
    String? deviceId,
  }) async {
    final netApi = NetSource._create();
    await netApi._init(
      baseUrl: baseUrl,
      socketUrl: socketUrl,
      host: host,
      token: token,
      deviceId: deviceId,
    );

    return netApi;
  }

  late PhoenixSocket _socket;
  late PhoenixChannel _channel;
  late Dio _client;

  Future<void> _init({
    required String baseUrl,
    required String socketUrl,
    required String host,
    String? token,
    String? deviceId,
  }) async {
    final options = BaseOptions(
      baseUrl: baseUrl,
      followRedirects: true,
      receiveDataWhenStatusError: true,
      headers: <String, String>{
        'Accept': 'application/json',
        'token': token ?? '',
        'deviceId': deviceId ?? '',
      },
      validateStatus: (status) {
        return (status ?? 501) < 501;
      },
    );
    _client = Dio(options);
    // ignore: deprecated_member_use
    (_client.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => host == host;
      return client;
    };
    // _socket = PhoenixSocket(socketUrl);
    // await _socket.connect();
  }

  /// Default error message
  String error = 'Something went wrong.';

  final _controller = StreamController<int>();

  /// Authentication status of user at any given point
  Stream<int> get uploadProgress async* {
    yield 0;
    yield* _controller.stream;
  }

  /// Send GET request to [route] with optional [data]
  Future<NetResponse> get(String route, {JsonMap? data}) async {
    try {
      final response = await _client.get<JsonMap>(route, data: data);
      log('Response @ $route: ${response.data}');
      return NetResponse.fromJson(response.data!);
    } catch (e) {
      log('Error @ $route: $e');
      return NetResponse(status: 2, data: error, message: e.toString());
    }
  }

  /// Send POST request to [route] with optional [body]
  Future<NetResponse> post(String route, JsonMap? body) async {
    try {
      final response = await _client.post<dynamic>(route, data: body);
      log('Response @ $route: ${response.data}');
      return NetResponse.fromJson(response.data as JsonMap);
    } catch (e) {
      log('Error @ $route: $e');
      return NetResponse(status: 2, data: error, message: e.toString());
    }
  }

  /// Send POST request to [route] with optional [body]
  Future<NetResponse> postFormData(String route, FormData? body) async {
    try {
      final response = await _client.post<dynamic>(route, data: body);
      log('Response @ $route: ${response.data}');
      return NetResponse.fromJson(response.data as JsonMap);
    } catch (e) {
      log('Error @ $route: $e');
      return NetResponse(status: 2, message: error);
    }
  }

  /// Send POST request to [route] with optional [body]
  Future<NetResponse> putFormData(String route, FormData? body) async {
    try {
      final response = await _client.put<dynamic>(route, data: body);
      log('Response @ $route: ${response.data}');
      return NetResponse.fromJson(response.data as JsonMap);
    } catch (e) {
      log('Error @ $route: $e');
      return NetResponse(status: 2, message: error);
    }
  }

  /// Send POST request to [route] with optional [body]
  Future<NetResponse> delete(String route, JsonMap? body) async {
    try {
      final response = await _client.delete<JsonMap>(route, data: body);
      log('Response @ $route: ${response.data}');
      return NetResponse.fromJson(response.data!);
    } catch (e) {
      log('Error @ $route: $e');
      return NetResponse(status: 2, message: error);
    }
  }

  /// Send PUT request to [route] with [body]
  Future<NetResponse> put(String route, JsonMap body) async {
    try {
      final response = await _client.put<JsonMap>(route, data: body);
      log('Response @ $route: ${response.data}');
      return NetResponse.fromJson(response.data!);
    } catch (e) {
      log('Error @ $route: $e');
      return NetResponse(status: 2, data: error, message: e.toString());
    }
  }

  /// Send PUT request to [route] with [files]
  Future<NetResponse> upload(String route, JsonMap files) async {
    try {
      final body = <String, dynamic>{};
      for (final file in files.entries) {
        body[file.key] = await MultipartFile.fromFile(file.value.toString());
      }
      final formData = FormData.fromMap(body);
      final response = await _client.put<JsonMap>(
        route,
        data: formData,
        onSendProgress: (sent, total) {
          final progress = sent / total * 100;
          _controller.add(progress.toInt());
          log('progress: ${progress.toStringAsFixed(0)}% ($sent/$total)');
        },
      );
      log('Response @ $route: ${response.data}');
      _controller.add(0);
      return NetResponse.fromJson(response.data!);
    } catch (e) {
      log('Error @ $route: $e');
      _controller.add(0);
      return NetResponse(status: 2, data: error, message: e.toString());
    }
  }

  final _socketController = StreamController<Map<dynamic, dynamic>?>();

  /// Responses from the web socket
  Stream<Map<dynamic, dynamic>?> get channelStream async* {
    yield* _socketController.stream;
  }

  /// Pushes [data] to an [event]
  Future<dynamic> push(String event, JsonMap data) async {
    try {
      final response = await _channel
          .push(event, data, const Duration(milliseconds: 1000))
          .future;
      log('Push @ $event: ${response.response}');
      return response.response;
    } catch (e) {
      log('Error @ $event: $e');
      return e;
    }
  }

  /// Connects to a socket channel [topic]
  Future<void> connect(String topic, {JsonMap? parameters}) async {
    _channel = _socket.addChannel(topic: topic);
    await _channel.join().future;
    _channel.messages.listen((event) {
      final data = <String, dynamic>{
        'event': event.event.value,
        'data': event.payload,
      };
      _socketController.add(data);
    });
  }
}
