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

  // Dropdown options
  List<String> companies = ['Apple', 'Samsung', 'OnePlus', 'Xiaomi', 'Realme'];
  List<String> models = ['iPhone 14', 'iPhone 15', 'Galaxy S23', 'OnePlus 11'];
  List<String> ramOptions = ['4', '6', '8', '12', '16'];
  List<String> storageOptions = ['64', '128', '256', '512', '1024'];
  List<String> colorOptions = ['White', 'Black', 'Blue', 'Red', 'Green'];

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
    // final gst = double.tryParse(value);
    // if (gst == null || gst < 0 || gst > 100) {
    //   return 'Enter valid GST percentage (0-100)';
    // }
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
        if (item.company.isEmpty ||
            item.model.isEmpty ||
            item.sellingPrice.isEmpty ||
            item.qty.isEmpty) {
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
    List<Map<String, dynamic>> itemsArray =
        billItems.map((item) {
          return {
            "company": item.company,
            "model": item.model,
            "ram": int.tryParse(item.ram) ?? 0,
            "rom": int.tryParse(item.rom) ?? 0,
            "sellingPrice": item.sellingPrice,
            "color": item.color,
            "qty": item.qty,
          };
        }).toList();

    // Prepare main bill data
    return {
      "companyName": companyNameController.text.trim(),
      "isPaid": isPaid.value,
      "amount": amountController.text.trim(),
      "withoutGst": double.tryParse(withoutGstController.text) ?? 0,
      "gst": gstController.text.trim(),
      "dues": duesController.text.trim(),
      "items": itemsArray,
    };
  }

  Future<void> _sendBillToAPI() async {
  const String apiUrl =
      "https://backend-production-91e4.up.railway.app/bill/add";

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
      // Verify file exists and is readable
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

  // Note: You'll need to modify your requestPostForApi method to handle FormData
  // Here's how it should look:

  /*
  Future<Response?> requestPostForApi({
    required String url,
    required Map<String, dynamic> dictParameter,
    required bool authToken,
  }) async {
    try {
      print("Url:  $url");
      print("DictParameter: $dictParameter");

      BaseOptions options = BaseOptions(
        receiveTimeout: const Duration(minutes: 1),
        connectTimeout: const Duration(minutes: 1),
        headers: await getHeader(authToken),
      );
      _dio.options = options;

      // Create FormData for multipart request
      FormData formData = FormData.fromMap(dictParameter);

      Response response = await _dio.post(
        url,
        data: formData, // Use FormData instead of dictParameter directly
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: await getHeader(authToken),
        ),
      );

      print("Response: $response");
      print("Response_headers: ${response.headers}");
      print("Response_real_url: ${response.realUri}");

      return response;
    } catch (error) {
      print("Exception_Main: $error");
      return null;
    }
  }
  */

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
        double price = double.tryParse(item.sellingPrice) ?? 0;
        int quantity = int.tryParse(item.qty) ?? 0;
        totalAmount += price * quantity;
      }
    }

    double gstRate = double.tryParse(gstController.text) ?? 0;
   // double withoutGstAmount = totalAmount / (1 + (gstRate / 100));
    //double gstAmount = totalAmount - withoutGstAmount;

   // withoutGstController.text = withoutGstAmount.toStringAsFixed(2);
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
        case 'company':
          billItems[index].company = value;
          break;
        case 'model':
          billItems[index].model = value;
          break;
        case 'ram':
          billItems[index].ram = value;
          break;
        case 'rom':
          billItems[index].rom = value;
          break;
        case 'color':
          billItems[index].color = value;
          break;
        case 'sellingPrice':
          billItems[index].sellingPrice = value;
          break;
        case 'qty':
          billItems[index].qty = value;
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
  String company = '';
  String model = '';
  String ram = '';
  String rom = '';
  String sellingPrice = '';
  String color = '';
  String qty = '';

  // Add controllers for price and quantity to maintain state
  late TextEditingController priceController;
  late TextEditingController qtyController;

  BillItem() {
    priceController = TextEditingController();
    qtyController = TextEditingController();
  }

  void dispose() {
    priceController.dispose();
    qtyController.dispose();
  }
}
