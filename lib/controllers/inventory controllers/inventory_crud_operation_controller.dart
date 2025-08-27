import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';

class InventoryCrudOperationController extends GetxController{
  @override
  void onClose() {
    quantityController.dispose();
    priceController.dispose();
    companyTextController.dispose();
    modelTextController.dispose();
    colorTextController.dispose();
    super.onClose();
  }

  // API service instance
  final ApiServices _apiService = ApiServices();
  // App config instance
  final AppConfig _config = AppConfig.instance;
  
  // ADD MOBILE FORM CONTROLLERS AND VARIABLES
  final GlobalKey<FormState> addMobileFormKey = GlobalKey<FormState>();

  // Form Controllers
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController();
  final TextEditingController supplierDetailsController = TextEditingController();
  final TextEditingController companyTextController = TextEditingController();
  final TextEditingController modelTextController = TextEditingController();
  final TextEditingController colorTextController = TextEditingController();

  // Form Values
  final RxString selectedAddCompany = ''.obs;
  final RxString selectedAddModel = ''.obs;
  final RxString selectedAddRam = ''.obs;
  final RxString selectedAddStorage = ''.obs;
  final RxString selectedAddColor = ''.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);

  // Form Loading States
  final RxBool isAddingMobile = false.obs;
  final RxBool hasAddMobileError = false.obs;
  final RxString addMobileErrorMessage = ''.obs;
  final RxBool isLoadingFilters = false.obs;
  final RxBool isLoadingModels = false.obs;

  // API data for dropdowns
  final RxList<String> companies = <String>[].obs;
  final RxList<String> models = <String>[].obs;
  final RxList<String> ramOptions = <String>[].obs;
  final RxList<String> storageOptions = <String>[].obs;
  final RxList<String> colorOptions = <String>[].obs;

  // Dropdown mode flags
  final RxBool isCompanyTypeable = false.obs;
  final RxBool isModelTypeable = false.obs;
  final RxBool isColorTypeable = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialFilters();
  }

  /// Load initial filter data (companies, RAM, storage, colors)
  Future<void> loadInitialFilters() async {
    try {
      isLoadingFilters.value = true;
      
      dio.Response? response = await _apiService.requestGetForApi(
        url: '${_config.baseUrl}/api/mobiles/filters',
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        
        // Update dropdown options
        companies.value = List<String>.from(data['companies'] ?? []);
        ramOptions.value = List<String>.from(data['rams'] ?? []);
        storageOptions.value = List<String>.from(data['roms'] ?? []);
        colorOptions.value = List<String>.from(data['colors'] ?? []);
        
        // Set typeable mode if no companies available
        isCompanyTypeable.value = companies.isEmpty;
        isColorTypeable.value = colorOptions.isEmpty;
        
        log("✅ Filters loaded successfully");
      } else {
        throw Exception('Failed to load filters');
      }
    } catch (error) {
      log("❌ Error loading filters: $error");
      // Enable typeable mode if API fails
      isCompanyTypeable.value = true;
      isModelTypeable.value = true;
      isColorTypeable.value = true;
    } finally {
      isLoadingFilters.value = false;
    }
  }

  /// Load models for selected company
  Future<void> loadModelsForCompany(String company) async {
    try {
      isLoadingModels.value = true;
      models.clear();
      selectedAddModel.value = '';
      modelTextController.clear();
      
      dio.Response? response = await _apiService.requestGetForApi(
        url: '${_config.baseUrl}/api/mobiles/filters?company=${Uri.encodeComponent(company)}',
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        models.value = List<String>.from(data['models'] ?? []);
        
        // Set typeable mode if no models available
        isModelTypeable.value = models.isEmpty;
        
        log("✅ Models loaded for company: $company");
      } else {
        throw Exception('Failed to load models for company: $company');
      }
    } catch (error) {
      log("❌ Error loading models: $error");
      // Enable typeable mode if API fails
      isModelTypeable.value = true;
    } finally {
      isLoadingModels.value = false;
    }
  }

  /// Get company brand color for UI theming
  Color getCompanyColor(String? company) {
    switch (company?.toLowerCase()) {
      case 'apple':
        return const Color(0xFF1D1D1F);
      case 'samsung':
        return const Color(0xFF1428A0);
      case 'google':
        return const Color(0xFF4285F4);
      case 'oneplus':
        return const Color(0xFFEB0028);
      case 'xiaomi':
        return const Color(0xFFFF6900);
      default:
        return const Color(0xFF6B7280);
    }
  }

  /// Check if model selection is enabled
  bool get isModelSelectionEnabled => selectedAddCompany.value.isNotEmpty;

  /// Get formatted device name for display
  String get formattedDeviceName {
    String company = selectedAddCompany.value.isNotEmpty 
        ? selectedAddCompany.value 
        : companyTextController.text;
    String model = selectedAddModel.value.isNotEmpty 
        ? selectedAddModel.value 
        : modelTextController.text;
        
    if (company.isNotEmpty && model.isNotEmpty) {
      return '$company $model';
    }
    return 'Select Company & Model';
  }

  /// Get formatted device specs for display
  String get formattedDeviceSpecs {
    if (selectedAddRam.value.isNotEmpty && selectedAddStorage.value.isNotEmpty) {
      return '${selectedAddRam.value} RAM • ${selectedAddStorage.value} Storage';
    }
    return 'RAM & Storage will appear here';
  }

  /// Handle company selection/input
  void onAddCompanyChanged(String company) {
    selectedAddCompany.value = company;
    selectedAddModel.value = '';
    modelTextController.clear();
    
    if (company.isNotEmpty) {
      loadModelsForCompany(company);
    } else {
      models.clear();
      isModelTypeable.value = false;
    }
  }

  /// Handle company text input
  void onCompanyTextChanged(String text) {
    selectedAddCompany.value = text;
    selectedAddModel.value = '';
    modelTextController.clear();
    
    if (text.isNotEmpty) {
      loadModelsForCompany(text);
    } else {
      models.clear();
      isModelTypeable.value = false;
    }
  }

  /// Handle model selection/input
  void onAddModelChanged(String model) {
    selectedAddModel.value = model;
  }

  /// Handle model text input
  void onModelTextChanged(String text) {
    selectedAddModel.value = text;
  }

  /// Handle RAM selection
  void onAddRamChanged(String ram) {
    selectedAddRam.value = ram;
  }

  /// Handle storage selection
  void onAddStorageChanged(String storage) {
    selectedAddStorage.value = storage;
  }

  /// Handle color selection
  void onAddColorChanged(String color) {
    selectedAddColor.value = color;
  }

  /// Handle color text input
  void onColorTextChanged(String text) {
    selectedAddColor.value = text;
  }

  /// Handle image selection
  void onImageSelected(File? image) {
    selectedImage.value = image;
  }

  /// Validate form fields
  String? validateCompany(String? value) {
    String companyValue = isCompanyTypeable.value 
        ? companyTextController.text 
        : (value ?? '');
    return companyValue.isEmpty ? 'Please select or enter a company' : null;
  }

  String? validateModel(String? value) {
    String modelValue = isModelTypeable.value 
        ? modelTextController.text 
        : (value ?? '');
    return modelValue.isEmpty ? 'Please select or enter a model' : null;
  }

  String? validateRam(String? value) {
    return value == null || value.isEmpty ? 'Please select RAM' : null;
  }

  String? validateStorage(String? value) {
    return value == null || value.isEmpty ? 'Please select storage' : null;
  }

  String? validateColor(String? value) {
    String colorValue = isColorTypeable.value 
        ? colorTextController.text 
        : (value ?? '');
    return colorValue.isEmpty ? 'Please select or enter a color' : null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter selling price';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter valid price';
    }
    return null;
  }

  String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter quantity';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter valid quantity';
    }
    return null;
  }

  /// Reset add mobile form
  void resetAddMobileForm() {
    addMobileFormKey.currentState?.reset();
    selectedAddCompany.value = '';
    selectedAddModel.value = '';
    selectedAddRam.value = '';
    selectedAddStorage.value = '';
    selectedAddColor.value = '';
    selectedImage.value = null;
    quantityController.clear();
    priceController.clear();
    purchasePriceController.clear();
    supplierDetailsController.clear();
    companyTextController.clear();
    modelTextController.clear();
    colorTextController.clear();
    hasAddMobileError.value = false;
    addMobileErrorMessage.value = '';
    models.clear();
    isModelTypeable.value = false;
    isColorTypeable.value = false;
  }

  /// Add mobile to inventory with multipart file upload
  Future<void> addMobileToInventory() async {
    if (!addMobileFormKey.currentState!.validate()) {
      return;
    }

    try {
      isAddingMobile.value = true;
      hasAddMobileError.value = false;
      addMobileErrorMessage.value = '';

      // Get final values (from dropdown or text input)
      String finalCompany = selectedAddCompany.value.isNotEmpty 
          ? selectedAddCompany.value 
          : companyTextController.text;
      String finalModel = selectedAddModel.value.isNotEmpty 
          ? selectedAddModel.value 
          : modelTextController.text;
      String finalColor = selectedAddColor.value.isNotEmpty 
          ? selectedAddColor.value 
          : colorTextController.text;

      // Create FormData for multipart request
      dio.FormData formData = dio.FormData.fromMap({
        'company': finalCompany,
        'model': finalModel,
        'ram': selectedAddRam.value,
        'rom': selectedAddStorage.value,
        'color': finalColor,
        'qty': quantityController.text,
        'sellingPrice': priceController.text,
        'purchasePrice': purchasePriceController.text,
        'supplierDetails': supplierDetailsController.text,
        'itemCategory':"SMARTPHONE"
      });

      // Add file if selected
      if (selectedImage.value != null) {
        String fileName = "${finalCompany}_${finalModel}_${finalColor}.${selectedImage.value!.path.split('.').last}";
        formData.files.add(
          MapEntry(
            'file',
            await dio.MultipartFile.fromFile(
              selectedImage.value!.path,
              filename: fileName,
            ),
          ),
        );
      }

      // Use the multipart API method
      dio.Response? response = await _apiService.requestMultipartApi(
        url: _config.addInventoryItem,
        formData: formData,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Mobile added to inventory successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );

        resetAddMobileForm();
        // Reload filters to get updated data
        loadInitialFilters();
        
      } else {
        String errorMessage = 'Failed to add mobile to inventory';
        if (response?.data != null) {
          errorMessage = response?.data['message'] ?? errorMessage;
        }
        throw Exception(errorMessage);
      }
    } catch (error) {
      hasAddMobileError.value = true;
      addMobileErrorMessage.value = 'Error adding mobile: $error';
      log("❌ Error in addMobileToInventory: $error");

      Get.snackbar(
        'Error',
        'Failed to add mobile to inventory. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isAddingMobile.value = false;
    }
  }

  /// Cancel add mobile form
  void cancelAddMobile() {
    resetAddMobileForm();
    Get.back();
  }
}