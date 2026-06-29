import 'package:cosmetics_avon/gen/assets.gen.dart';
import 'package:flutter_svg/svg.dart';
import '../../../gen/locale_keys.g.dart';
import 'model.dart';

final List<BoardingModel> boardingList = [
  BoardingModel(
    image: Assets.images.boarding0.image(),
    title: LocaleKeys.on_boarding_title_1,
    description: LocaleKeys.on_boarding_desc_1,
  ),
  BoardingModel(
    image: Assets.images.boarding1.image(),
    title: LocaleKeys.on_boarding_title_2,
    description: LocaleKeys.on_boarding_desc_2,
  ),
  BoardingModel(
    image: SvgPicture.asset(Assets.images.boarding2),
    title: LocaleKeys.on_boarding_title_3,
    description: LocaleKeys.on_boarding_desc_3,
  ),
];
