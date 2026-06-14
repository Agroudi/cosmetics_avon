import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../gen/locale_keys.g.dart';
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

  String searchQuery = '';

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(BottomNavChanged());
  }

  void searchProducts(String query) {
    searchQuery = query;
    emit(HomeSearchUpdated());
  }

  List<ProductModel> get filteredProducts {
    if (searchQuery.trim().isEmpty) {
      return products;
    }
    final lowercaseQuery = searchQuery.toLowerCase();
    return products.where((product) {
      return product.nameEn.toLowerCase().contains(lowercaseQuery) ||
          product.nameAr.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Future<void> getHomeData() async {
    emit(HomeLoading());

    try {
      /// SLIDERS
      final slidersResponse = await repo.getSliders();

      sliders = List<SliderModel>.from(
        slidersResponse.data.map((e) => SliderModel.fromJson(e)),
      );

      debugPrint("SLIDERS LENGTH => ${sliders.length}");

      /// CATEGORIES
      final categoriesResponse = await repo.getCategories();

      categories = List<CategoryModel>.from(
        categoriesResponse.data.map((e) => CategoryModel.fromJson(e)),
      );

      debugPrint("CATEGORIES LENGTH => ${categories.length}");

      /// PRODUCTS
      final productsResponse = await repo.getProducts();

      products = List<ProductModel>.from(
        productsResponse.data.map((e) => ProductModel.fromJson(e)),
      );

      debugPrint("PRODUCTS LENGTH => ${products.length}");

      if (isClosed) return;
      emit(HomeSuccess());
    } on DioException catch (e) {
      debugPrint("HOME ERROR => $e");
      String errorMessage = LocaleKeys.smth_went_wrong.tr();
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = LocaleKeys.request_timed_out.tr();
      } else if (e.response?.data is Map) {
        errorMessage =
            e.response?.data['message'] ??
            e.response?.data['error'] ??
            LocaleKeys.failed_load_data.tr();
      }
      if (isClosed) return;
      emit(HomeError(errorMessage));
    } catch (e) {
      debugPrint("HOME ERROR => $e");
      if (isClosed) return;
      emit(HomeError(LocaleKeys.smth_went_wrong.tr()));
    }
  }
}
