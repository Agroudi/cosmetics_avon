import 'package:cosmetics_avon/features/auth/presentation/create_password_screen.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/verification_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case AppRoutes.createPassword:
        return MaterialPageRoute(builder: (_) => const CreatePasswordScreen());

      case AppRoutes.verification:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => VerificationScreen(
            countryCode: args['countryCode'],
            type: args['type'],
            value: args['value'],
          ),
        );

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No Route Found')),
          ),
        );
    }
  }
}