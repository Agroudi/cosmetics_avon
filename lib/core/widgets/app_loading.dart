import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLoading {
  static bool _isShowing = false;

  static void show(BuildContext context) {
    if (_isShowing) return;
    _isShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) {
        return const LoadingWidget();
      },
    ).then((_) {
      _isShowing = false;
    });
  }

  static void hide(BuildContext context) {
    if (!_isShowing) return;
    _isShowing = false;
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: SizedBox(
          width: 150,
          height: 150,
          child: Lottie.asset('assets/lottie/lipstick.json'),
        ),
      ),
    );
  }
}