import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:auth_repo/src/models/models.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:local_data/local_data.dart';
import 'package:net_source/net_source.dart';

/// Authentication statuses
enum AuthStatus {
  /// on startup, the authentication status of the user is unknown by default
  unknown,

  /// The status after a user is successfully authenticated
  authenticated,

  /// Refresh the current user data
  refresh,

  /// The status of a user after logging out or before logging in
  unauthenticated,

  /// The status of a first time user
  firstTime,

  /// The status of a user when his session has expired
  expired,

  /// The status of a user when the account is deleted
  deleted,
}

/// {@template auth_repo}
/// Repo for application authentication
/// {@endtemplate}
class AuthRepo {
  /// {@macro auth_repo}
  AuthRepo._(this._config);

  final Config _config;

  // Shared preferences keys
  final String _keyLoggedIn = 'logged_in';
  final String _keyFirstTime = 'first_time';
  final String _keyToken = 'token';
  final String _keyUserUId = 'user_uid';
  final String _keyTheme = 'theme';

  // table names
  final String _tableUsers = 'users';

  late LocalData _db;
  late NetSource _net;
  late SharedPrefs _prefs;

  /// Public factory
  static Future<AuthRepo> init(Config config) async {
    final repo = AuthRepo._(config);
    await repo._init();
    return repo;
  }

  Future<void> _init() async {
    _db = await LocalData.init(
      dbName: _config.dbName,
      initialScript: _config.initScript,
      migrations: _config.migrations,
    );
    _prefs = await SharedPrefs.init();
    await _initNetworkApi();
  }

  Future<void> _initNetworkApi({String? tokenStr}) async {
    final token = await _prefs.getString(_keyToken) ?? tokenStr;
    _net = await NetSource.init(
      baseUrl: _config.baseUrl,
      socketUrl: _config.socketUrl,
      host: _config.host,
      token: token,
    );
    _progressSub = _net.uploadProgress.listen(_progressController.add);
  }

  /// Get the app theme
  Future<int> getTheme() async {
    return await _prefs.getInt(_keyTheme, defaultValue: 1) ?? 1;
  }

  /// Set the app theme
  Future<void> setTheme(int themeMode) async {
    await _prefs.set(_keyTheme, themeMode);
  }

  /// Pipe function to check if token has been refreshed
  Future<dynamic> callService(Future<OpStatus?> Function() nextFunction) async {
    final response = await nextFunction.call();
    if (response?.code == 700) {
      refreshSession();
    }
    return response;
  }

  /// Authentication status of user at any given point
  Stream<AuthStatus> get status async* {
    final isLoggedIn = await _checkLoggedIn();
    if (isLoggedIn) {
      yield AuthStatus.authenticated;
    } else {
      final isFirstTime = await _prefs.getBool(
        _keyFirstTime,
        defaultValue: true,
      );
      if (isFirstTime!) {
        yield AuthStatus.firstTime;
        await _prefs.set(_keyFirstTime, false);
      } else {
        yield AuthStatus.unauthenticated;
      }
    }
    yield* _controller.stream;
  }

  late StreamSubscription<int> _progressSub;
  final _controller = StreamController<AuthStatus>.broadcast();
  final _progressController = StreamController<int>.broadcast();

  /// The progress of an upload
  Stream<int> get uploadProgress async* {
    yield 0;
    yield* _progressController.stream;
  }

  Future<bool> _checkLoggedIn() async {
    final isLoggedIn = await _prefs.getBool(
          _keyLoggedIn,
          defaultValue: false,
        ) ??
        false;

    return isLoggedIn;
  }

  /// refreshes the details of the logged in account for the UI
  void refreshAccountData() => _controller.add(AuthStatus.refresh);

  /// refreshes the session so a user is required to login before proceeding
  void refreshSession() => _controller.add(AuthStatus.expired);

  /// Returns the logged in [User] object or null.
  Future<User?> getUser() async {
    final uid = await _prefs.getString(_keyUserUId);
    if (uid == null) return null;
    final userData = await _db.getWhere(
      _tableUsers,
      column: 'uid',
      value: uid,
      limit: 1,
    );
    if (userData.isEmpty) return null;
    return User.fromJson(userData.first);
  }

  /// Function to log in the user, returns a token for verification
  Future<OpStatus> signInWithEmailAndPassword(
    String email,
    String password,
    auth.FirebaseAuth firebaseAuth,
  ) async {
    // final uaData = await userAgentData();
    try {
      final response = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log(response.toString());
      if (response.user != null) {
        final user_ = response.user!;
        log(user_.toString());
        final user =
            await _db.getWhere(_tableUsers, column: 'email', value: email);
        await _prefs.set(_keyUserUId, user_.uid);
        await _prefs.set(_keyToken, user_.getIdToken());
        if (user.isNotEmpty) {
          // await _db.insertOne(_tableUsers, user);
        } else {
          final user0 = User(
            id: user_.uid.hashCode,
            name: user_.displayName ?? '',
            phoneNumber: user_.phoneNumber ?? '',
            photoURL: user_.photoURL ?? '',
            email: user_.email ?? '',
            displayName: user_.displayName ?? '',
            emailVerified: user_.emailVerified,
            uid: user_.uid,
            isAnonymous: user_.isAnonymous,
            details: _getEncodedUserCredential(response),
            password: hashPassword(password),
            role: 'Admin',
          );
          await _db.insertOne(_tableUsers, user0.toJson());
        }
        await _prefs.set(_keyLoggedIn, true);
        _controller.add(AuthStatus.authenticated);
        return OpStatus(
          message: 'Success',
          success: true,
          data: {
            'user': user.isEmpty ? null : user,
            'email': email,
            'userEmpty': user.isEmpty,
            'response': response,
          },
        );
      }
      return OpStatus(
        message: 'User is null',
        success: false,
        data: response,
      );
    } catch (e) {
      return OpStatus.error(e.toString());
    }
  }

  ///
  Future<void> insertUser(User user) async {
    await _db.insertOne(_tableUsers, user.toJson());
    _controller.add(AuthStatus.authenticated);
  }

  /// Function to hash the password (same as before)
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hashedPassword = sha256.convert(bytes);
    return hashedPassword.toString();
  }

  ///Function to verify the entered password against the stored hash
  bool verifyPassword(String enteredPassword, String storedHash) {
    final enteredHash = hashPassword(enteredPassword);
    return enteredHash == storedHash;
  }

  /// Function to sign up the user
  Future<OpStatus> createUserWithEmailAndPassword(
    String email,
    String password,
    String role,
    auth.FirebaseAuth firebaseAuth,
  ) async {
    // final uaData = await userAgentData();
    try {
      final response = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log(response.toString());
      if (response.user != null) {
        final user_ = response.user!;
        log(user_.toString());
        final user = User(
          id: user_.uid.hashCode,
          name: user_.displayName ?? '',
          phoneNumber: user_.phoneNumber ?? '',
          photoURL: user_.photoURL ?? '',
          email: user_.email ?? '',
          displayName: user_.displayName ?? '',
          emailVerified: user_.emailVerified,
          uid: user_.uid,
          isAnonymous: user_.isAnonymous,
          details: _getEncodedUserCredential(response),
          password: hashPassword(password),
          role: role,
        );
        await _prefs.set(_keyUserUId, user_.uid);
        await _prefs.set(_keyToken, user_.getIdToken());
        await _db.insertOne(_tableUsers, user.toJson());
        await _prefs.set(_keyLoggedIn, true);
        _controller.add(AuthStatus.authenticated);
        return OpStatus(
          message: 'Success',
          success: true,
          data: {
            'user': user,
            'response': response,
          },
        );
      }
      return OpStatus(
        message: 'User is null',
        success: false,
        data: response,
      );
    } catch (e) {
      return OpStatus.error(e.toString());
    }
  }

  ///
  Future<void> insertFirbaseUser(auth.User? fireBaseUser) async {
    if (fireBaseUser != null) {
      final user_ = fireBaseUser!;
      log(user_.toString());
      final user = User(
        id: user_.uid.hashCode,
        name: user_.displayName ?? '',
        phoneNumber: user_.phoneNumber ?? '',
        photoURL: user_.photoURL ?? '',
        email: user_.email ?? '',
        displayName: user_.displayName ?? '',
        emailVerified: user_.emailVerified,
        uid: user_.uid,
        isAnonymous: user_.isAnonymous,
        // details: _getEncodedUserCredential(response),
        // password: hashPassword(password),
        // role: '',
      );
      await _prefs.set(_keyUserUId, user_.uid);
      await _prefs.set(_keyToken, user_.getIdToken());
      await _db.insertOne(_tableUsers, user.toJson());
      await _prefs.set(_keyLoggedIn, true);
      _controller.add(AuthStatus.authenticated);
    }
  }

  /// Function to sign up the user
  Future<OpStatus> logoutUser(
    auth.FirebaseAuth firebaseAuth,
  ) async {
    try {
      await firebaseAuth.signOut();
      await _prefs.deleteValue(_keyUserUId);
      await _db.deleteAll(_tableUsers);
      await _prefs.deleteValue(_keyLoggedIn);
      _controller.add(AuthStatus.unauthenticated);
      return OpStatus(
        message: 'Success',
        success: true,
      );
    } catch (e) {
      return OpStatus.error(e.toString());
    }
  }

  ///
  void authenticated() {
    _controller.add(AuthStatus.authenticated);
  }

  String _getEncodedUserCredential(auth.UserCredential userCredential) {
    final userCredentialJson = <String, dynamic>{
      'user': {
        'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
        'displayName': userCredential.user!.displayName,
        'emailVerified': userCredential.user!.emailVerified,
        'photoURL': userCredential.user!.photoURL,
        'isAnonymous': userCredential.user!.isAnonymous,
        'phoneNumber': userCredential.user!.phoneNumber,
        'tenantId': userCredential.user!.tenantId,
        'refreshToken': userCredential.user!.refreshToken,
      },
      // Add more properties from userCredential as needed
    };

    final encodedUserCredential = jsonEncode(userCredentialJson);
    return encodedUserCredential;
  }

  /// Function called when session is expired
  Future<void> expired() async => _controller.add(AuthStatus.expired);

  /// Close the controller
  void dispose() {
    _controller.close();
    _progressController.close();
    _progressSub.cancel();
  }
}
