import 'package:get/get.dart';
import 'package:mobistock/controllers/sales_managenment_controller.dart';

class SalesManagenmentBinding extends Bindings {
  @override
  void dependencies() {
     Get.put<SalesManagementController>(
      SalesManagementController(),
       permanent: true,
    );
  }
}