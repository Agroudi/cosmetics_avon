import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLoading {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const LoadingWidget();
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
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