import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_master/certificate_verify.dart';
import 'package:field_master/utils/cubit/firebase_cubit.dart';
import 'package:field_master/utils/sms_service.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  firebaseApp = await Firebase.initializeApp(
  );
  authInstance = FirebaseAuth.instanceFor(app: firebaseApp);
  // Initialize Firestore
  firebaseFirestore = FirebaseFirestore.instanceFor(app: firebaseApp);
  firebaseStorage = FirebaseStorage.instanceFor(app: firebaseApp);
  appCheck = FirebaseAppCheck.instanceFor(app: firebaseApp);

  nexmoService = NexmoService();
  // Activate app check after initialization, but before
  // usage of any Firebase services.
  await appCheck
      // Your personal reCaptcha public key goes here:
      .activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
    webProvider: ReCaptchaV3Provider(kWebRecaptchaSiteKey),
  );
  if (shouldUseFirebaseEmulator) {
    await authInstance.useAuthEmulator('localhost', 9099);
  }
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here

  runApp(await builder());
}
