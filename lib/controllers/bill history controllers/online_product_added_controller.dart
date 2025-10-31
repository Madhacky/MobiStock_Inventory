// controllers/online_products_controller.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/bill%20history/online_added_product_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/utils/app_colors.dart';

class OnlineProductsController extends GetxController {
  final ApiServices _apiService = ApiServices();
  final AppConfig _config = AppConfig.instance;

  // Products data
  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString error = ''.obs;
  final RxInt currentPage = 0.obs;
  final RxBool hasMore = true.obs;
  final RxInt totalElements = 0.obs;

  // Filter options
  final RxString selectedCategory = 'SMARTPHONE'.obs;
  final RxString selectedBrand = 'All'.obs;
  final RxString selectedModel = 'All'.obs;
  final RxString selectedRam = 'All'.obs;
  final RxString selectedRom = 'All'.obs;
  final RxString selectedColor = 'All'.obs;
  final RxString sortBy = 'createdDate'.obs;
  final RxString sortOrder = 'desc'.obs;

  // Dropdown options
  final RxList<String> categoryOptions = <String>['SMARTPHONE'].obs;
  final RxList<String> brandOptions = <String>['All'].obs;
  final RxList<String> modelOptions = <String>['All'].obs;
  final RxList<String> ramOptions = <String>['All'].obs;
  final RxList<String> romOptions = <String>['All'].obs;
  final RxList<String> colorOptions = <String>['All'].obs;

  final List<String> sortOptions = [
    'createdDate',
    'sellingPrice',
    'model',
    'company',
  ];

  @override
  void onInit() {
    super.onInit();
    loadProducts(refresh: true);
  }

  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 0;
      hasMore.value = true;
      products.clear();
    }

    if (isLoading.value) return;
    isLoading.value = true;
    error.value = '';

    try {
      final queryParams = <String, String>{
        'page': currentPage.value.toString(),
        'size': '10',
        'sortBy': sortBy.value,
        'sortOrder': sortOrder.value,
      };

      if (selectedCategory.value != 'All') {
        queryParams['category'] = selectedCategory.value;
      }

      if (selectedBrand.value != 'All') {
        queryParams['brand'] = selectedBrand.value;
      }

      if (selectedModel.value != 'All') {
        queryParams['model'] = selectedModel.value;
      }

      if (selectedRam.value != 'All') {
        queryParams['ram'] = selectedRam.value;
      }

      if (selectedRom.value != 'All') {
        queryParams['rom'] = selectedRom.value;
      }

      if (selectedColor.value != 'All') {
        queryParams['color'] = selectedColor.value;
      }

      final response = await _apiService.requestGetForApi(
        url: '${_config.baseUrl}/api/products',
        dictParameter: queryParams,
        authToken: true,
      );

      if (response == null || response.statusCode != 200) {
        error.value = 'Failed to load products';
        _showErrorSnackbar('Failed to load products');
      } else {
        final parsed = ProductResponse.fromJson(response.data);

        if (refresh) {
          products.clear();
        }

        products.addAll(parsed.payload.content);
        totalElements.value = parsed.payload.totalElements;
        hasMore.value = !parsed.payload.last;

        if (refresh) {
          await loadFilters();
        }
      }
    } catch (e) {
      error.value = 'Error: $e';
      _showErrorSnackbar('Error loading products: $e');
      log('Error loading products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreProducts() async {
    if (isLoadingMore.value || !hasMore.value || isLoading.value) return;

    isLoadingMore.value = true;
    currentPage.value++;

    try {
      final queryParams = <String, String>{
        'page': currentPage.value.toString(),
        'size': '10',
        'sortBy': sortBy.value,
        'sortOrder': sortOrder.value,
      };

      if (selectedCategory.value != 'All') {
        queryParams['category'] = selectedCategory.value;
      }
      if (selectedBrand.value != 'All') {
        queryParams['brand'] = selectedBrand.value;
      }
      if (selectedModel.value != 'All') {
        queryParams['model'] = selectedModel.value;
      }
      if (selectedRam.value != 'All') {
        queryParams['ram'] = selectedRam.value;
      }
      if (selectedRom.value != 'All') {
        queryParams['rom'] = selectedRom.value;
      }
      if (selectedColor.value != 'All') {
        queryParams['color'] = selectedColor.value;
      }

      final response = await _apiService.requestGetForApi(
        url: '${_config.baseUrl}/api/products',
        dictParameter: queryParams,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final parsed = ProductResponse.fromJson(response.data);
        products.addAll(parsed.payload.content);
        hasMore.value = !parsed.payload.last;
      } else {
        currentPage.value--;
        _showErrorSnackbar('Failed to load more products');
      }
    } catch (e) {
      currentPage.value--;
      _showErrorSnackbar('Error loading more products: $e');
      log('Error loading more products: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadFilters() async {
    try {
      final queryParams = <String, String>{};

      if (selectedCategory.value != 'All') {
        queryParams['itemCategory'] = selectedCategory.value;
      }
      if (selectedBrand.value != 'All') {
        queryParams['company'] = selectedBrand.value;
      }
      if (selectedModel.value != 'All') {
        queryParams['model'] = selectedModel.value;
      }
      if (selectedRam.value != 'All') {
        queryParams['ram'] = selectedRam.value;
      }
      if (selectedRom.value != 'All') {
        queryParams['rom'] = selectedRom.value;
      }

      final response = await _apiService.requestGetForApi(
        url: '${_config.baseUrl}/api/products/filters',
        dictParameter: queryParams,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final filterResponse = ProductFilterResponse.fromJson(response.data);

        categoryOptions.value = [
          'All',
          ...filterResponse.payload.itemCategories,
        ];
        brandOptions.value = ['All', ...filterResponse.payload.companies];
        modelOptions.value = ['All', ...filterResponse.payload.models];
        ramOptions.value = ['All', ...filterResponse.payload.rams];
        romOptions.value = ['All', ...filterResponse.payload.roms];
        colorOptions.value = ['All', ...filterResponse.payload.colors];
      }
    } catch (e) {
      log('Error loading filters: $e');
    }
  }

  void onCategoryChanged(String? category) {
    selectedCategory.value = category ?? 'All';
    selectedBrand.value = 'All';
    selectedModel.value = 'All';
    selectedRam.value = 'All';
    selectedRom.value = 'All';
    selectedColor.value = 'All';
    loadProducts(refresh: true);
  }

  void onBrandChanged(String? brand) {
    selectedBrand.value = brand ?? 'All';
    selectedModel.value = 'All';
    selectedRam.value = 'All';
    selectedRom.value = 'All';
    selectedColor.value = 'All';
    loadProducts(refresh: true);
  }

  void onModelChanged(String? model) {
    selectedModel.value = model ?? 'All';
    selectedRam.value = 'All';
    selectedRom.value = 'All';
    selectedColor.value = 'All';
    loadProducts(refresh: true);
  }

  void onRamChanged(String? ram) {
    selectedRam.value = ram ?? 'All';
    selectedRom.value = 'All';
    selectedColor.value = 'All';
    loadProducts(refresh: true);
  }

  void onRomChanged(String? rom) {
    selectedRom.value = rom ?? 'All';
    selectedColor.value = 'All';
    loadProducts(refresh: true);
  }

  void onColorChanged(String? color) {
    selectedColor.value = color ?? 'All';
    loadProducts(refresh: true);
  }

  void onSortChanged(String field) {
    if (sortBy.value == field) {
      sortOrder.value = sortOrder.value == 'asc' ? 'desc' : 'asc';
    } else {
      sortBy.value = field;
      sortOrder.value = 'desc';
    }
    loadProducts(refresh: true);
  }

  void resetFilters() {
    selectedCategory.value = 'SMARTPHONE';
    selectedBrand.value = 'All';
    selectedModel.value = 'All';
    selectedRam.value = 'All';
    selectedRom.value = 'All';
    selectedColor.value = 'All';
    sortBy.value = 'createdDate';
    sortOrder.value = 'desc';
    loadProducts(refresh: true);
    Get.back();
  }

  Future<void> refreshProducts() async {
    await loadProducts(refresh: true);
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.errorLight,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'smartphone':
        return Color(0xFF3B82F6);
      case 'feature_phone':
        return Color(0xFF6366F1);
      case 'tablet':
        return Color(0xFF8B5CF6);
      case 'charger':
      case 'car_charger':
      case 'wireless_charger':
        return Color(0xFF10B981);
      case 'earphones':
      case 'headphones':
      case 'bluetooth_speaker':
        return Color(0xFF8B5CF6);
      case 'cover':
        return Color(0xFFF59E0B);
      case 'screen_guard':
        return Color(0xFF06B6D4);
      case 'power_bank':
        return Color(0xFFEF4444);
      case 'memory_card':
        return Color(0xFF6366F1);
      case 'smart_watch':
      case 'fitness_band':
        return Color(0xFFEC4899);
      default:
        return Color(0xFF6B7280);
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'smartphone':
      case 'feature_phone':
        return Icons.smartphone;
      case 'tablet':
        return Icons.tablet;
      case 'charger':
      case 'car_charger':
      case 'wireless_charger':
        return Icons.battery_charging_full;
      case 'earphones':
      case 'headphones':
        return Icons.headphones;
      case 'bluetooth_speaker':
        return Icons.speaker;
      case 'cover':
        return Icons.phone_android;
      case 'screen_guard':
        return Icons.shield;
      case 'power_bank':
        return Icons.battery_std;
      case 'memory_card':
        return Icons.sd_card;
      case 'smart_watch':
        return Icons.watch;
      case 'fitness_band':
        return Icons.fitness_center;
      default:
        return Icons.devices_other;
    }
  }
}
