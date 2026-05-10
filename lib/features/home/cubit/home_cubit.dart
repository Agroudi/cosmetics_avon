import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../categories/data/models/category_model.dart';
import '../data/models/product_model.dart';
import '../data/models/slider_model.dart';
import '../data/repo/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {

  final HomeRepo repo;

  HomeCubit(this.repo) : super(HomeInitial());

  int currentIndex = 0;

  List<SliderModel> sliders = [];

  List<CategoryModel> categories = [];

  List<ProductModel> products = [];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(BottomNavChanged());
  }

  Future<void> getHomeData() async {

    emit(HomeLoading());

    try {

      /// SLIDERS
      final slidersResponse = await repo.getSliders();

      sliders = List<SliderModel>.from(
        slidersResponse.data.map(
              (e) => SliderModel.fromJson(e),
        ),
      );

      debugPrint("SLIDERS LENGTH => ${sliders.length}");

      /// CATEGORIES
      final categoriesResponse = await repo.getCategories();

      categories = List<CategoryModel>.from(
        categoriesResponse.data.map(
              (e) => CategoryModel.fromJson(e),
        ),
      );

      debugPrint("CATEGORIES LENGTH => ${categories.length}");

      /// PRODUCTS
      final productsResponse = await repo.getProducts();

      products = List<ProductModel>.from(
        productsResponse.data.map(
              (e) => ProductModel.fromJson(e),
        ),
      );

      debugPrint("PRODUCTS LENGTH => ${products.length}");

      emit(HomeSuccess());

    } catch (e) {

      debugPrint("HOME ERROR => $e");

      emit(
        HomeError(
          "Something went wrong",
          // TODO: translate
        ),
      );
    }
  }
}