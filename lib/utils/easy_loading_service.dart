import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:field_master/utils/strings.dart';

class EasyLoadingService {
  static TransitionBuilder init(BuildContext context) {
    final easy = EasyLoading.init();
    configLoading(context);
    return easy;
  }

  static void configLoading(BuildContext context) {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Theme.of(context).colorScheme.inversePrimary
      ..backgroundColor = Theme.of(context).colorScheme.inverseSurface
      ..indicatorColor = Theme.of(context).colorScheme.inversePrimary
      ..textColor = Theme.of(context).colorScheme.inversePrimary
      ..maskColor = Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)
      ..userInteractions = false
      ..dismissOnTap = true;
  }

  static Future<void> showToast({
    String text = Strings.comming,
    EasyLoadingToastPosition toastPosition = EasyLoadingToastPosition.bottom,
  }) {
    return EasyLoading.showToast(
      text,
      toastPosition: EasyLoadingToastPosition.bottom,
      maskType: EasyLoadingMaskType.clear,
    );
  }

  static Future<void> loading({
    String text = Strings.loading,
    EasyLoadingIndicatorType indicatorType = EasyLoadingIndicatorType.circle,
  }) {
    EasyLoading.instance.indicatorType = indicatorType;
    return EasyLoading.show(
      status: text,
      maskType: EasyLoadingMaskType.clear,
    );
  }

  static Future<void> error({
    String text = Strings.somethingWrong,
  }) {
    return EasyLoading.showError(
      text,
      maskType: EasyLoadingMaskType.clear,
    );
  }

  static Future<void> success({
    String text = Strings.success,
    EasyLoadingToastPosition toastPosition = EasyLoadingToastPosition.bottom,
  }) {
    return EasyLoading.showToast(
      text,
      toastPosition: toastPosition,
      maskType: EasyLoadingMaskType.clear,
    );
  }

  static Future<void> close() {
    return EasyLoading.dismiss();
  }
}
