import 'package:get/get.dart';
import 'package:smartbecho/controllers/account%20management%20controller/account_management_controller.dart';

class AccountManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AccountManagementController>(AccountManagementController(),permanent: false);
  }
}
