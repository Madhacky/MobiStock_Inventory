import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/common_textfield.dart';
import 'package:smartbecho/utils/custom_dropdown.dart';
import 'package:smartbecho/utils/custom_back_button.dart';
import 'package:smartbecho/utils/app_styles.dart';

class BillOperationController extends GetxController {
  final GlobalKey<FormState> addBillFormKey = GlobalKey<FormState>();

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
    final gst = double.tryParse(value);
    if (gst == null || gst < 0 || gst > 100) {
      return 'Enter valid GST percentage (0-100)';
    }
    return null;
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

      isAddingBill.value = true;
      hasAddBillError.value = false;

      try {
        Map<String, dynamic> billData = _prepareBillData();

        log('=== SENDING BILL DATA ===');
        log(jsonEncode(billData));
        log('========================');

        // Send to API
        // await _sendBillToAPI(billData);
        isAddingBill.value = false;
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

  Future<void> _sendBillToAPI(Map<String, dynamic> billData) async {
    const String apiUrl =
        "YOUR_API_ENDPOINT_HERE"; // Replace with your actual API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          // Add any additional headers you need (like authorization)
          // 'Authorization': 'Bearer YOUR_TOKEN_HERE',
        },
        body: jsonEncode(billData),
      );

      log('API Response Status: ${response.statusCode}');
      log('API Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Success
        isAddingBill.value = false;
        Get.snackbar(
          'Success',
          'Bill created successfully!',
          backgroundColor: AppTheme.primaryGreen,
          colorText: AppTheme.backgroundLight,
          duration: Duration(seconds: 3),
        );

        // Clear the form after successful submission
        _clearForm();

        // Go back to previous screen
        Get.back();
      } else {
        // API returned an error
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException {
      throw Exception('Server error. Please try again later.');
    } on FormatException {
      throw Exception('Invalid response format from server.');
    } catch (e) {
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
    double withoutGstAmount = totalAmount / (1 + (gstRate / 100));
    double gstAmount = totalAmount - withoutGstAmount;

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
