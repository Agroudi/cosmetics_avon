import '../../features/auth/presentation/create_password_screen.dart';
import '../../features/boarding/presentation/boarding_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/splash/presentaion/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/verification_screen.dart';
import '../../features/home/cubit/home_cubit.dart';
import '../../features/home/data/repo/home_repo_impl.dart';
import '../../features/home/data/services/home_api_service.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/data/models/product_model.dart';
import '../../features/home/presentation/product_details_screen.dart';
import '../../features/categories/presentation/category_products_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/orders/presentation/order_history_screen.dart';
import '../../features/vouchers/presentation/voucher_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.boarding:
        return MaterialPageRoute(builder: (_) => const BoardingScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case AppRoutes.createPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CreatePasswordScreen(),
        );

      case AppRoutes.verification:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => VerificationScreen(
            countryCode: args['countryCode'],
            type: args['type'],
            value: args['value'],
            phoneNumber: args['phoneNumber'],
            isFromLogin: args['isFromLogin'] ?? false,
          ),
        );

      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(

            create: (_) => HomeCubit(
              HomeRepoImpl(
                HomeApiService(),
              ),
            )..getHomeData(),

            child: const HomeScreen(),
          ),
        );

      case AppRoutes.checkout:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CheckoutScreen(),
        );

      case AppRoutes.categoryProducts:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CategoryProductsScreen(
            categoryId: args['categoryId'] as int,
            categoryTitle: args['categoryTitle'] as String,
            products: args['products'] as List<ProductModel>,
          ),
        );

      case AppRoutes.productDetails:
        final product = settings.arguments as ProductModel;
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) =>
              ProductDetailsScreen(product: product),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );

      case AppRoutes.settings:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SettingsScreen(),
        );

      case AppRoutes.orderHistory:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OrderHistoryScreen(),
        );

      case AppRoutes.vouchers:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const VoucherScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No Route Found')),
          ),
        );
    }
  }
}