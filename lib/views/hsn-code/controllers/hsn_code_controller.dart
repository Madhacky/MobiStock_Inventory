import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:dio/dio.dart' as dio;
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/views/hsn-code/models/hsn_code_model.dart';
import 'package:smartbecho/views/hsn-code/presentation/hsn_code_screen.dart';

class HsnCodeController extends GetxController {
  final ApiServices _apiService = ApiServices();

  RxBool isLoading = false.obs;
  RxBool isTableView = true.obs;
  RxList<HsnCodeModel> hsnCodes = <HsnCodeModel>[].obs;
  RxList<String> itemCategories = <String>[].obs;
  RxString searchQuery = ''.obs;
  RxInt currentPage = 0.obs;
  RxInt totalPages = 1.obs;
  RxInt totalElements = 0.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHsnCodes();
    fetchItemCategories();
  }

  String get itemTypesUrl =>
      'https://backend-production-91e4.up.railway.app/inventory/item-types';
  String get hsnCodeUrl =>
      'https://backend-production-91e4.up.railway.app/api/hsn-codes?';
  String get hsnCodeByIdUrl =>
      'https://backend-production-91e4.up.railway.app/api/hsn-codes';
  String get addHsnCodeAddUrl =>
      'https://backend-production-91e4.up.railway.app/api/hsn-codes';
  String get hsnCodeUpdateUrl =>
      'https://backend-production-91e4.up.railway.app/api/hsn-codes/';
  String get hsnCodeDeleteUrl =>
      'https://backend-production-91e4.up.railway.app/api/hsn-codes/';

  Future<void> fetchItemCategories() async {
    try {
      dio.Response? response = await _apiService.requestGetForApi(
        authToken: true,
        url: itemTypesUrl,
        dictParameter: {},
      );

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;
        itemCategories.value = data.cast<String>();
      }
    } catch (e) {
      print('Error fetching item categories: $e');
      Get.snackbar('Error', 'Failed to load item categories');
    }
  }

  Future<void> fetchHsnCodes({int page = 0, String? search}) async {
    try {
      isLoading.value = true;

      Map<String, dynamic> params = {
        'page': page,
        'size': 20,
        'sortBy': 'id',
        'sortDir': 'asc',
      };

      if (search != null) {
        final trimmedSearch = search.trim();
        if (trimmedSearch.isNotEmpty) {
          params['searchTerm'] = trimmedSearch;
        }
      }

      dio.Response? response = await _apiService.requestGetForApi(
        authToken: true,
        url: hsnCodeUrl,
        dictParameter: params,
      );

      if (response != null && response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['status'] == 'Success') {
          Map<String, dynamic> payload = data['payload'];
          List<dynamic> content = payload['content'];

          hsnCodes.value =
              content.map((e) => HsnCodeModel.fromJson(e)).toList();
          currentPage.value = payload['number'];
          totalPages.value = payload['totalPages'];
          totalElements.value = payload['totalElements'];
        }
      }
    } catch (e) {
      print('Error fetching HSN codes: $e');
      Get.snackbar('Error', 'Failed to load HSN codes');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addHsnCode(Map<String, dynamic> hsnCodeData) async {
    try {
      isLoading.value = true;
      dio.Response? response = await _apiService.requestPostForApi(
        authToken: true,
        url: addHsnCodeAddUrl,
        dictParameter: hsnCodeData,
      );

      if (response != null && response.statusCode == 201) {
        snackBar(
          title: 'Success',
          message: errorMessage.value,
          color: AppTheme.successDark,
          messageColor: Colors.white,
          icon: Icons.check_circle,
        );
        fetchHsnCodes();
        Get.offAll(() => HsnCodeScreen());
      } else {
        errorMessage.value = response!.data['message'];
        print(response);

        snackBar(
          title: 'Error',
          message: errorMessage.value,
          color: AppTheme.warningDark,
          icon: Icons.error,
          duration: Duration(seconds: 4),
        );
      }
    } catch (e) {
      print('Error adding HSN code: $e');

      snackBar(
        title: 'Error',
        message: 'Failed to add HSN code',
        color: AppTheme.errorDark,
        messageColor: Colors.white,
        icon: Icons.error,
        duration: Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateHsnCode(
    String id,
    Map<String, dynamic> hsnCodeData,
  ) async {
    try {
      isLoading.value = true;
      dio.Response? response = await _apiService.requestPutForApi(
        authToken: true,
        url: '$hsnCodeUpdateUrl$id',
        dictParameter: hsnCodeData,
      );

      if (response != null && response.statusCode == 200) {
        snackBar(
          title: 'Success',
          message: errorMessage.value,
          color: AppTheme.successDark,
          messageColor: Colors.white,
          icon: Icons.check_circle,
        );
        fetchHsnCodes();
        Get.back();
      } else {
        errorMessage.value = response!.data['message'];
        snackBar(
          title: 'Error',
          message: errorMessage.value,
          color: AppTheme.warningDark,
          icon: Icons.error,
          duration: Duration(seconds: 4),
        );
      }
    } catch (e) {
      print('Error updating HSN code: $e');
      Get.snackbar('Error', 'Failed to update HSN code');
      snackBar(
        title: 'Error',
        message: errorMessage.value,
        color: AppTheme.errorDark,
        messageColor: Colors.white,
        icon: Icons.error,
        duration: Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteHsnCode(String id) async {
    try {
      isLoading.value = true;
      dio.Response? response = await _apiService.requestDeleteForApi(
        authToken: true,
        url: '$hsnCodeDeleteUrl$id',
        dictParameter: {},
      );

      if (response != null && response.statusCode == 200) {
        snackBar(
          title: 'Success',
          message: errorMessage.value,
          color: AppTheme.successDark,
          messageColor: Colors.white,
          icon: Icons.check_circle,
        );
        fetchHsnCodes();
      } else {
        errorMessage.value = response!.data['message'];
        snackBar(
          title: 'Error',
          message: errorMessage.value,
          color: AppTheme.warningDark,
          icon: Icons.error,
          duration: Duration(seconds: 4),
        );
      }
    } catch (e) {
      print('Error deleting HSN code: $e');

      snackBar(
        title: 'Error',
        message: 'Failed to delete HSN code',
        color: AppTheme.errorDark,
        icon: Icons.error,
        duration: Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleView() {
    isTableView.value = !isTableView.value;
  }

  void searchHsnCodes(String query) {
    final trimmedQuery = query.trim();
    searchQuery.value = trimmedQuery;
    fetchHsnCodes(search: trimmedQuery);
  }

  void snackBar({
    required String title,
    required String message,
    Color? color,
    Color? messageColor = Colors.white,
    IconData? icon,
    Duration? duration,
  }) {
    Get.snackbar(
      title,
      icon: Icon(icon),
      message,
      backgroundColor: color,
      colorText: messageColor,
      duration: duration ?? Duration(seconds: 4),
    );
  }
}
