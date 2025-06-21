import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SalesManagementController extends GetxController {
  

 var currentStep = 0.obs;









  //Salesformstep1

  final company =
      [
        "Apple",
        "Samsung",
        "Nokia",
        "OnePlus",
        "Realme",
        "Oppo",
        "Vivo",
        "Xiaomi",
      ].obs;
  final selectedCompany = 'Apple'.obs;

  void setSelectedCompany(String value) {
    selectedCompany.value = value;
  }

  final model =
      [
        "iphone 6s",
        "iphone 7",
        "iphone 8",
        "iphone X",
        "iphone XR",
        "iphone XS Max",
        "iphone 12 Pro Max",
        "iphone SE",
      ].obs;
  final selectedModel = 'iphone 6s'.obs;

  void setSelectedModel(String value) {
    selectedModel.value = value;
  }

  final ram = ["4GB", "6GB", "8GB", "16GB", "32GB", "12GB"].obs;
  final selectedRam = '4GB'.obs;

  void setSelectedRam(String value) {
    selectedRam.value = value;
  }

  final color = ["Black", "White", "Gold", "Silver"].obs;
  final selectedColor = 'Black'.obs;

  void setSelectedColor(String value) {
    selectedColor.value = value;
  }

  TextEditingController quantity = TextEditingController();
  GlobalKey<FormState> salesformstep1 = GlobalKey<FormState>();

  //Salesformstep2
  GlobalKey<FormState> salesformstep2 = GlobalKey<FormState>();
   TextEditingController customerNameController = TextEditingController();
 TextEditingController customerAddressController = TextEditingController();
 TextEditingController customerPhoneController = TextEditingController();

  final emi = ["3Months", "6Months", "9Months", "1Year", "2Years"].obs;
  final selectedEmi = '3Months'.obs;

  void setSelectedEmi(String value) {
    selectedEmi.value = value;
  }

  var radioGroupValue = true.obs; // or false.obs, depending on your default

  void setRadioValue(bool? value) {
    if (value != null) radioGroupValue.value = value;
  }

  void onButtonPressed() {
    // Your button logic here
    // print('Button pressed! Selected: ${radioGroupValue.value}');
  }

// Salesformstep3
  GlobalKey<FormState> salesformstep3 = GlobalKey<FormState>();
  TextEditingController basePriceController = TextEditingController();
  TextEditingController gstController = TextEditingController();  
  TextEditingController accessoriesController = TextEditingController();
  TextEditingController repairController = TextEditingController();
  TextEditingController discountController = TextEditingController();


// Salesformstep4
  GlobalKey<FormState> salesformstep4 = GlobalKey<FormState>();
    TextEditingController customerNameControllerstep4 = TextEditingController();
   TextEditingController phoneNoController = TextEditingController();
   TextEditingController emailController = TextEditingController();
   TextEditingController addressController = TextEditingController();







//validators

  String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }



static String? numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }
    final number = int.tryParse(value);
    if (number == null || number <= 0) {
      return 'Enter a valid number greater than 0';
    }
    return null;
  }



  String? salesValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  
}
