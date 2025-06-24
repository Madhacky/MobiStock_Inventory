import 'package:get/get.dart';
import 'package:smartbecho/controllers/bill%20history%20controllers/bill_operation_controller.dart';

class BillOperationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BillOperationController>(BillOperationController(),permanent: false);
  }
}
