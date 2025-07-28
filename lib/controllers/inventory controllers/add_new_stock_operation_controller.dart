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
  var isPaid = true.obs;
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
            item.qty.value.isEmpty) {
          hasAddBillError.value = true;
          addBillErrorMessage.value =
              'Please fill all required fields for Item ${i + 1}';
          return;
        }
      }

      // Check if file is selected (optional based on your requirements)
      if (selectedFile.value == null) {
        hasAddBillError.value = true;
        addBillErrorMessage.value = 'Please select an invoice file';
        return;
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
      "sellingPrice": double.tryParse(item.sellingPrice.value) ?? 0.0,  // Convert to double
      "color": item.color.value,
      "qty": int.tryParse(item.qty.value) ?? 0,  // Convert to int
      "itemCategory": item.category.value,
      "description": item.description.value.isEmpty ? "" : item.description.value,  // Use empty string instead of "none"
    };

    // Only add RAM and ROM if category is SMARTPHONE or TABLET
    if (item.category.value == "SMARTPHONE" || item.category.value == 'TABLET') {
      itemData["ram"] = int.tryParse(item.ram.value) ?? 0;
      itemData["rom"] = int.tryParse(item.rom.value) ?? 0;
    }

    return itemData;
  }).toList();

  // Helper function to safely parse string to double
  double parseToDouble(String value) {
    if (value.isEmpty) return 0.0;
    return double.tryParse(value) ?? 0.0;
  }

  // Prepare main bill data
  return {
    "companyName": companyNameController.text.trim(),
    "isPaid": isPaid.value,
    "amount": parseToDouble(amountController.text.trim()),        // Convert to double
    "withoutGst": parseToDouble(withoutGstController.text.trim()), // Convert to double
    "gst": parseToDouble(gstController.text.trim()),             // Convert to double
    "dues": parseToDouble(duesController.text.trim()),           // Convert to double
    "items": itemsArray,
  };
}

  Future<void> _sendBillToAPI() async {
    const String apiUrl = "https://backend-production-91e4.up.railway.app/bill/add";

    try {
      // Prepare bill data as JSON string
      Map<String, dynamic> billData = _prepareBillData();
      String billJsonString = jsonEncode(billData);

      log('=== SENDING BILL DATA ===');
      log(billJsonString);
      log('========================');

      // Prepare form data
      Map<String, dynamic> formDataMap = {'bill': billJsonString};

      // Add file if selected
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
            'Bill created successfully! Bill ID: $billId',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );

          _clearForm();

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
    isPaid.value = true;
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
  }

  void cancelAddBill() {
    Get.back();
  }

  void addNewItem() {
    billItems.add(BillItem());
  }

  void removeItem(int index) {
    if (index >= 0 && index < billItems.length) {
      billItems.removeAt(index);
      calculateTotals(); // Recalculate totals after removing item
    }
  }

  void calculateTotals() {
    double totalAmount = 0;
    for (var item in billItems) {
      if (item.sellingPrice.isNotEmpty && item.qty.isNotEmpty) {
        double price = double.tryParse(item.sellingPrice.value) ?? 0;
        int quantity = int.tryParse(item.qty.value) ?? 0;
        totalAmount += price * quantity;
      }
    }

    double gstRate = double.tryParse(gstController.text) ?? 0;
    double withoutGstAmount = totalAmount / (1 + (gstRate / 100));
    
    withoutGstController.text = withoutGstAmount.toStringAsFixed(2);
    amountController.text = totalAmount.toStringAsFixed(2);

    if (!isPaid.value) {
      duesController.text = totalAmount.toStringAsFixed(2);
    } else {
      duesController.text = '0';
    }
  }

  // Method to update item field and trigger calculation
  void updateItemField(int index, String field, String value) {
  if (index >= 0 && index < billItems.length) {
    switch (field) {
      case 'category':
        billItems[index].category.value = value;
        break;
      case 'company':
        billItems[index].company.value = value;
        break;
      case 'model':
        billItems[index].model.value = value;
        break;
      case 'ram':
        billItems[index].ram.value = value;
        break;
      case 'rom':
        billItems[index].rom.value = value;
        break;
      case 'color':
        billItems[index].color.value = value;
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
    calculateTotals();
  }
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

  // Add controllers for various fields
  late TextEditingController companyController;
  late TextEditingController modelController;
  late TextEditingController priceController;
  late TextEditingController qtyController;
  late TextEditingController descriptionController;

  BillItem() {
    companyController = TextEditingController();
    modelController = TextEditingController();
    priceController = TextEditingController();
    qtyController = TextEditingController();
    descriptionController = TextEditingController();
    
    // Sync controllers with observable values
    _setupControllerListeners();
  }

  void _setupControllerListeners() {
    // Listen to controller changes and update observables
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
    priceController.dispose();
    qtyController.dispose();
    descriptionController.dispose();
  }

}