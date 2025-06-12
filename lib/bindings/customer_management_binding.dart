import 'package:get/get.dart';
import 'package:mobistock/controllers/customer_controller.dart';

class CustomerManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CustomerController>(CustomerController());
  }
}
