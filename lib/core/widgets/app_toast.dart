import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// Shows toasts in the app-level [ToastificationWrapper] overlay (configured in
/// `CosmeticsApp`) instead of the nearest navigator overlay.
///
/// Passing a `context` to `toastification.show` makes it resolve the overlay via
/// `findAncestorStateOfType<OverlayState>()`, which returns the navigator's
/// overlay. The toast host entry is created once and ends up *beneath* any
/// route pushed afterwards (e.g. the product details screen), so the toast is
/// hidden. Omitting `context` routes the toast to the top-level wrapper overlay
/// that always sits above every route and dialog.
///
/// `context` is still used here purely to read the ambient text direction so
/// the default `AlignmentDirectional.topEnd` keeps positioning correct in RTL.
class AppToast {
  static void show(
    BuildContext context, {
    required ToastificationType type,
    required Widget title,
    Duration autoCloseDuration = const Duration(seconds: 3),
  }) {
    toastification.show(
      type: type,
      title: title,
      autoCloseDuration: autoCloseDuration,
      alignment:
          AlignmentDirectional.topEnd.resolve(Directionality.of(context)),
    );
  }
}
