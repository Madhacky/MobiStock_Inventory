import 'package:get/get.dart';
import 'package:mobistock/controllers/auth_controller.dart';
import 'package:mobistock/controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Put controllers needed for home and main app
    Get.put<DashboardController>(DashboardController());
    Get.put<AuthController>(AuthController());
    // Add other controllers as needed
  }
}
