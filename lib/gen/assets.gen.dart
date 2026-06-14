// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/add_cart.svg
  String get addCart => 'assets/icons/add_cart.svg';

  /// File path: assets/icons/auth_logo.svg
  String get authLogo => 'assets/icons/auth_logo.svg';

  /// File path: assets/icons/back_button.svg
  String get backButton => 'assets/icons/back_button.svg';

  /// File path: assets/icons/cart.svg
  String get cart => 'assets/icons/cart.svg';

  /// File path: assets/icons/categories.svg
  String get categories => 'assets/icons/categories.svg';

  /// File path: assets/icons/checkout.svg
  String get checkout => 'assets/icons/checkout.svg';

  /// File path: assets/icons/delete.svg
  String get delete => 'assets/icons/delete.svg';

  /// File path: assets/icons/down.svg
  String get down => 'assets/icons/down.svg';

  /// File path: assets/icons/edit_info.svg
  String get editInfo => 'assets/icons/edit_info.svg';

  /// File path: assets/icons/eye_false.svg
  String get eyeFalse => 'assets/icons/eye_false.svg';

  /// File path: assets/icons/eye_true.svg
  String get eyeTrue => 'assets/icons/eye_true.svg';

  /// File path: assets/icons/goto.svg
  String get goto => 'assets/icons/goto.svg';

  /// File path: assets/icons/home.svg
  String get home => 'assets/icons/home.svg';

  /// File path: assets/icons/logout.svg
  String get logout => 'assets/icons/logout.svg';

  /// File path: assets/icons/order.svg
  String get order => 'assets/icons/order.svg';

  /// File path: assets/icons/order_history.svg
  String get orderHistory => 'assets/icons/order_history.svg';

  /// File path: assets/icons/profile.svg
  String get profile => 'assets/icons/profile.svg';

  /// File path: assets/icons/search.svg
  String get search => 'assets/icons/search.svg';

  /// File path: assets/icons/settings.svg
  String get settings => 'assets/icons/settings.svg';

  /// File path: assets/icons/splash.png
  AssetGenImage get splash => const AssetGenImage('assets/icons/splash.png');

  /// File path: assets/icons/splash_logo.svg
  String get splashLogo => 'assets/icons/splash_logo.svg';

  /// File path: assets/icons/success_dialouge.svg
  String get successDialouge => 'assets/icons/success_dialouge.svg';

  /// File path: assets/icons/swoosh.svg
  String get swoosh => 'assets/icons/swoosh.svg';

  /// File path: assets/icons/voucher.svg
  String get voucher => 'assets/icons/voucher.svg';

  /// File path: assets/icons/wallet.svg
  String get wallet => 'assets/icons/wallet.svg';

  /// List of all assets
  List<dynamic> get values => [
    addCart,
    authLogo,
    backButton,
    cart,
    categories,
    checkout,
    delete,
    down,
    editInfo,
    eyeFalse,
    eyeTrue,
    goto,
    home,
    logout,
    order,
    orderHistory,
    profile,
    search,
    settings,
    splash,
    splashLogo,
    successDialouge,
    swoosh,
    voucher,
    wallet,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/boarding_0.png
  AssetGenImage get boarding0 =>
      const AssetGenImage('assets/images/boarding_0.png');

  /// File path: assets/images/boarding_1.png
  AssetGenImage get boarding1 =>
      const AssetGenImage('assets/images/boarding_1.png');

  /// File path: assets/images/boarding_2.svg
  String get boarding2 => 'assets/images/boarding_2.svg';

  /// File path: assets/images/login.png
  AssetGenImage get login => const AssetGenImage('assets/images/login.png');

  /// File path: assets/images/mansoura.png
  AssetGenImage get mansoura =>
      const AssetGenImage('assets/images/mansoura.png');

  /// List of all assets
  List<dynamic> get values => [
    boarding0,
    boarding1,
    boarding2,
    login,
    mansoura,
  ];
}

class $AssetsLottieGen {
  const $AssetsLottieGen();

  /// File path: assets/lottie/delivery_online_shopping.json
  String get deliveryOnlineShopping =>
      'assets/lottie/delivery_online_shopping.json';

  /// File path: assets/lottie/lipstick.json
  String get lipstick => 'assets/lottie/lipstick.json';

  /// File path: assets/lottie/shopping_online.json
  String get shoppingOnline => 'assets/lottie/shopping_online.json';

  /// List of all assets
  List<String> get values => [deliveryOnlineShopping, lipstick, shoppingOnline];
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/ar.json
  String get ar => 'assets/translations/ar.json';

  /// File path: assets/translations/en.json
  String get en => 'assets/translations/en.json';

  /// List of all assets
  List<String> get values => [ar, en];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLottieGen lottie = $AssetsLottieGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
