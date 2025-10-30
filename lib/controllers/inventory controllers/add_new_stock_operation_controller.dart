import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/utils/common_textfield.dart';
import 'package:smartbecho/utils/custom_dropdown.dart';
import 'package:smartbecho/utils/custom_back_button.dart';
import 'package:smartbecho/utils/app_styles.dart';

class AddNewStockOperationController extends GetxController {
  final GlobalKey<FormState> addBillFormKey = GlobalKey<FormState>();
  final ApiServices _apiService = ApiServices();

  // Bill Details
  final companyNameController = TextEditingController();
  final amountController = TextEditingController();
  final withoutGstController = TextEditingController();
  final gstController = TextEditingController();
  final duesController = TextEditingController();

  // Observable variables
  var isPaid = false.obs;
  var isAddingBill = false.obs;
  var hasAddBillError = false.obs;
  var addBillErrorMessage = ''.obs;

  // File upload variables
  var selectedFile = Rx<File?>(null);
  var fileName = ''.obs;
  var isFileUploading = false.obs;

  // Items list
  var billItems = <BillItem>[].obs;

  // Category management
  var categories = <String>[].obs;
  var isLoadingCategories = false.obs;

  // Flag to prevent circular calculation updates
  var _isCalculating = false;

  // Dropdown options
  List<String> companies = ['Apple', 'Samsung', 'OnePlus', 'Xiaomi', 'Realme'];
  List<String> models = ['iPhone 14', 'iPhone 15', 'Galaxy S23', 'OnePlus 11'];
  List<String> ramOptions = ['4', '6', '8', '12', '16'];
  List<String> storageOptions = ['64', '128', '256', '512', '1024'];
  List<String> colorOptions = ['White', 'Black', 'Blue', 'Red', 'Green'];

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    _initializeCalculation();
    _setupControllerListeners();
  }

  void _initializeCalculation() {
    // Initialize with default values
    gstController.text = '0';
    withoutGstController.text = '0';
    amountController.text = '0';
    duesController.text = '0';
  }

  void _setupControllerListeners() {
    // Listen to total amount changes
    amountController.addListener(() {
      if (!_isCalculating) {
        _onTotalAmountChanged();
      }
    });

    // Listen to GST changes
    gstController.addListener(() {
      if (!_isCalculating) {
        _onGstChanged();
      }
    });
  }

  void _onTotalAmountChanged() {
    if (_isCalculating) return;
    _isCalculating = true;

    String totalAmountText = amountController.text.trim();
    String gstText = gstController.text.trim();

    if (totalAmountText.isNotEmpty && gstText.isNotEmpty) {
      double totalAmount = double.tryParse(totalAmountText) ?? 0;
      double gstRate = double.tryParse(gstText) ?? 0;

      if (gstRate > 0) {
        // Calculate without GST: Total Amount / (1 + GST/100)
        double withoutGst = totalAmount / (1 + (gstRate / 100));
        withoutGstController.text = withoutGst.toStringAsFixed(2);
      } else {
        // If no GST, without GST equals total amount
        withoutGstController.text = totalAmount.toStringAsFixed(2);
      }
    }

    _updateDues();
    _isCalculating = false;
  }

  void _onGstChanged() {
    if (_isCalculating) return;
    _isCalculating = true;

    String gstText = gstController.text.trim();
    String totalAmountText = amountController.text.trim();

    if (gstText.isNotEmpty && totalAmountText.isNotEmpty) {
      double gstRate = double.tryParse(gstText) ?? 0;
      double totalAmount = double.tryParse(totalAmountText) ?? 0;

      if (gstRate > 0 && totalAmount > 0) {
        // Calculate without GST: Total Amount / (1 + GST/100)
        double withoutGst = totalAmount / (1 + (gstRate / 100));
        withoutGstController.text = withoutGst.toStringAsFixed(2);
      } else if (gstRate == 0 && totalAmount > 0) {
        // If no GST, without GST equals total amount
        withoutGstController.text = totalAmount.toStringAsFixed(2);
      }
    }

    _updateDues();
    _isCalculating = false;
  }

  void _updateDues() {
    String totalAmountText = amountController.text.trim();
    if (totalAmountText.isNotEmpty) {
      double totalAmount = double.tryParse(totalAmountText) ?? 0;
      
      if (!isPaid.value) {
        duesController.text = totalAmount.toStringAsFixed(2);
      } else {
        duesController.text = '0.00';
      }
    }
  }

  // Fetch categories from API
  Future<void> fetchCategories() async {
    try {
      isLoadingCategories.value = true;
      
      dio.Response? response = await _apiService.requestGetForApi(
        url: 'https://backend-production-91e4.up.railway.app/inventory/item-types',
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        List<dynamic> categoryData = response.data;
        categories.value = categoryData.map((e) => e.toString()).toList();
      } else {
        log('Failed to fetch categories: ${response?.statusCode}');
      }
    } catch (e) {
      log('Error fetching categories: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // Validation methods
  String? validateCompanyName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Company name is required';
    }
    return null;
  }

  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    if (double.tryParse(value) == null) {
      return 'Enter valid amount';
    }
    return null;
  }

  String? validateGst(String? value) {
    if (value == null || value.isEmpty) {
      return 'GST is required';
    }
    final gst = double.tryParse(value);
    if (gst == null || gst < 0 || gst > 100) {
      return 'Enter valid GST percentage (0-100)';
    }
    return null;
  }

  // File picker method
  Future<void> pickFile() async {
    try {
      isFileUploading.value = true;

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        selectedFile.value = File(result.files.single.path!);
        fileName.value = result.files.single.name;

        Get.snackbar(
          'Success',
          'File selected: ${result.files.single.name}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Info',
          'No file selected',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick file: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isFileUploading.value = false;
    }
  }

  // Remove selected file
  void removeFile() {
    selectedFile.value = null;
    fileName.value = '';
  }

  // Methods
  void addBillToSystem() async {
    if (addBillFormKey.currentState!.validate()) {
      if (billItems.isEmpty) {
        hasAddBillError.value = true;
        addBillErrorMessage.value = 'Please add at least one item';
        return;
      }

      // Validate that all items have required fields
      for (int i = 0; i < billItems.length; i++) {
        BillItem item = billItems[i];
        if (item.category.value.isEmpty ||
            item.company.value.isEmpty ||
            item.model.value.isEmpty ||
            item.sellingPrice.value.isEmpty ||
            item.qty.value.isEmpty ||
            item.color.value.isEmpty) {
          hasAddBillError.value = true;
          addBillErrorMessage.value =
              'Please fill all required fields for Item ${i + 1}';
          return;
        }

        // Validate RAM/ROM for SMARTPHONE and TABLET
        if ((item.category.value == 'SMARTPHONE' || item.category.value == 'TABLET') &&
            (item.ram.value.isEmpty || item.rom.value.isEmpty)) {
          hasAddBillError.value = true;
          addBillErrorMessage.value =
              'Please select RAM and ROM for Item ${i + 1}';
          return;
        }
      }

      isAddingBill.value = true;
      hasAddBillError.value = false;

      try {
        await _sendBillToAPI();
      } catch (e) {
        isAddingBill.value = false;
        hasAddBillError.value = true;
        addBillErrorMessage.value = 'Failed to create bill: ${e.toString()}';
        log('Error creating bill: $e');
      }
    }
  }

  Map<String, dynamic> _prepareBillData() {
    // Prepare items array
    List<Map<String, dynamic>> itemsArray = billItems.map((item) {
      Map<String, dynamic> itemData = {
        "company": item.company.value,
        "model": item.model.value,
        "sellingPrice": item.sellingPrice.value,
        "color": item.color.value,
        "qty": item.qty.value,
        "itemCategory": item.category.value,
        "description": item.description.value.isEmpty ? "" : item.description.value,
      };

      // Only add RAM and ROM if category is SMARTPHONE or TABLET
      if (item.category.value == "SMARTPHONE" || item.category.value == 'TABLET') {
        itemData["ram"] = int.tryParse(item.ram.value) ?? 0;
        itemData["rom"] = int.tryParse(item.rom.value) ?? 0;
      }

      return itemData;
    }).toList();

    // Helper function to safely parse string to number
    double parseToDouble(String value) {
      if (value.isEmpty) return 0.0;
      return double.tryParse(value) ?? 0.0;
    }

    // Prepare main bill data - matching the API structure
    return {
      "companyName": companyNameController.text.trim(),
      "amount": parseToDouble(amountController.text.trim()),
      "withoutGst": withoutGstController.text.trim(),
      "gst": parseToDouble(gstController.text.trim()),
      "items": itemsArray,
      "date":"2025-10-22",
    };
  }

  Future<void> _sendBillToAPI() async {
    const String apiUrl = "https://backend-production-91e4.up.railway.app/api/purchase-bills";

    try {
      // Prepare bill data as JSON string
      Map<String, dynamic> billData = _prepareBillData();
      String billJsonString = jsonEncode(billData);

      log('=== SENDING BILL DATA ===');
      log(billJsonString);
      log('========================');

      // Prepare form data
      Map<String, dynamic> formDataMap = {'bill': billJsonString};

      // Add file if selected (optional)
      if (selectedFile.value != null) {
        File file = File(selectedFile.value!.path);
        if (!await file.exists()) {
          throw Exception('Selected file does not exist');
        }
        
        formDataMap['file'] = await dio.MultipartFile.fromFile(
          selectedFile.value!.path,
          filename: fileName.value ?? 'invoice.pdf',
        );
      }

      // Create FormData
      dio.FormData formData = dio.FormData.fromMap(formDataMap);

      // Use your existing API method
      dio.Response? response = await _apiService.requestMultipartApi(
        url: apiUrl,
        formData: formData,
        authToken: true,
      );

      if (response != null) {
        log('API Response Status: ${response.statusCode}');
        log('API Response Body: ${response.data}');

        if (response.statusCode == 201 || response.statusCode == 200) {
          // Success
          isAddingBill.value = false;

          // Parse response data safely
          dynamic responseData = response.data;
          String billId = 'Unknown';
          
          if (responseData is Map<String, dynamic> && responseData.containsKey('billId')) {
            billId = responseData['billId'].toString();
          }

          Get.snackbar(
            'Success',
            'Purchase Bill created successfully! Bill ID: $billId',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );

          _clearForm();
          // Get.back(); // Go back after successful creation
          Get.offAllNamed('/inventory-management');
        } else {
          String errorMessage = 'Unknown error';
          if (response.data is Map<String, dynamic>) {
            errorMessage = response.data['message'] ?? response.data.toString();
          } else {
            errorMessage = response.data.toString();
          }
          
          throw Exception(
            'API Error: ${response.statusCode} - $errorMessage',
          );
        }
      } else {
        throw Exception('Failed to connect to server - no response received');
      }
    } on dio.DioException catch (e) {
      isAddingBill.value = false;
      String errorMessage = 'Network error occurred';
      
      switch (e.type) {
        case dio.DioExceptionType.connectionTimeout:
          errorMessage = 'Connection timeout - please check your internet connection';
          break;
        case dio.DioExceptionType.receiveTimeout:
          errorMessage = 'Server response timeout';
          break;
        case dio.DioExceptionType.sendTimeout:
          errorMessage = 'Request timeout - file might be too large';
          break;
        case dio.DioExceptionType.badResponse:
          errorMessage = 'Server error: ${e.response?.statusCode}';
          if (e.response?.data != null) {
            errorMessage += ' - ${e.response?.data}';
          }
          break;
        case dio.DioExceptionType.cancel:
          errorMessage = 'Request was cancelled';
          break;
        case dio.DioExceptionType.unknown:
          errorMessage = 'Network error: ${e.message}';
          break;
        default:
          errorMessage = 'Network error occurred';
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      isAddingBill.value = false;
      log('Unexpected error in _sendBillToAPI: $e');
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  void _clearForm() {
    // Clear all controllers
    companyNameController.clear();
    amountController.clear();
    withoutGstController.clear();
    gstController.clear();
    duesController.clear();

    // Reset observables
    isPaid.value = false;
    hasAddBillError.value = false;
    addBillErrorMessage.value = '';

    // Clear file selection
    selectedFile.value = null;
    fileName.value = '';

    // Clear all items
    for (var item in billItems) {
      item.dispose();
    }
    billItems.clear();

    // Reset calculation
    _initializeCalculation();
  }

  void cancelAddBill() {
    Get.back();
  }

  void addNewItem() {
    billItems.add(BillItem());
  }

  void removeItem(int index) {
    if (index >= 0 && index < billItems.length) {
      billItems[index].dispose();
      billItems.removeAt(index);
    }
  }

  // Method to update item field (no longer triggers total calculation)
  void updateItemField(int index, String field, String value) {
    if (index >= 0 && index < billItems.length) {
      switch (field) {
        case 'category':
          billItems[index].category.value = value;
          break;
        case 'company':
          billItems[index].company.value = value;
          billItems[index].companyController.text = value;
          break;
        case 'model':
          billItems[index].model.value = value;
          billItems[index].modelController.text = value;
          break;
        case 'ram':
          billItems[index].ram.value = value;
          billItems[index].ramController.text = value;
          break;
        case 'rom':
          billItems[index].rom.value = value;
          billItems[index].romController.text = value;
          break;
        case 'color':
          billItems[index].color.value = value;
          billItems[index].colorController.text = value;
          break;
        case 'sellingPrice':
          billItems[index].sellingPrice.value = value;
          billItems[index].priceController.text = value;
          break;
        case 'qty':
          billItems[index].qty.value = value;
          billItems[index].qtyController.text = value;
          break;
        case 'description':
          billItems[index].description.value = value;
          billItems[index].descriptionController.text = value;
          break;
      }
    }
  }

  // Method to handle GST changes (kept for backward compatibility)
  void onGstChanged(String value) {
    // This will be handled by the listener automatically
  }

  // Method to handle payment status change
  void onPaymentStatusChanged() {
    _updateDues();
  }

  @override
  void onClose() {
    companyNameController.dispose();
    amountController.dispose();
    withoutGstController.dispose();
    gstController.dispose();
    duesController.dispose();

    // Dispose item controllers
    for (var item in billItems) {
      item.dispose();
    }

    super.onClose();
  }
}

class BillItem {
  RxString category = ''.obs;
  RxString company = ''.obs;
  RxString model = ''.obs;
  RxString ram = ''.obs;
  RxString rom = ''.obs;
  RxString sellingPrice = ''.obs;
  RxString color = ''.obs;
  RxString qty = ''.obs;
  RxString description = ''.obs;

  // Add controllers for text fields
  late TextEditingController companyController;
  late TextEditingController modelController;
  late TextEditingController ramController;
  late TextEditingController romController;
  late TextEditingController colorController;
  late TextEditingController priceController;
  late TextEditingController qtyController;
  late TextEditingController descriptionController;

  BillItem() {
    companyController = TextEditingController();
    modelController = TextEditingController();
    ramController = TextEditingController();
    romController = TextEditingController();
    colorController = TextEditingController();
    priceController = TextEditingController();
    qtyController = TextEditingController();
    descriptionController = TextEditingController();
    
    // Set default quantity
    qty.value = '1';
    qtyController.text = '1';
    
    // Sync controllers with observable values
    _setupControllerListeners();
  }

  void _setupControllerListeners() {
    // Listen to controller changes and update observables
    companyController.addListener(() {
      company.value = companyController.text;
    });
    
    modelController.addListener(() {
      model.value = modelController.text;
    });
    
    ramController.addListener(() {
      ram.value = ramController.text;
    });
    
    romController.addListener(() {
      rom.value = romController.text;
    });
    
    colorController.addListener(() {
      color.value = colorController.text;
    });
    
    priceController.addListener(() {
      sellingPrice.value = priceController.text;
    });
    
    qtyController.addListener(() {
      qty.value = qtyController.text;
    });
    
    descriptionController.addListener(() {
      description.value = descriptionController.text;
    });
  }

  void dispose() {
    companyController.dispose();
    modelController.dispose();
    ramController.dispose();
    romController.dispose();
    colorController.dispose();
    priceController.dispose();
    qtyController.dispose();
    descriptionController.dispose();
  }
}