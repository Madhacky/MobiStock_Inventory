import 'package:get/get.dart';
import 'package:mobistock/controllers/auth_controller.dart';
import 'package:mobistock/controllers/dashboard_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(
      AuthController(),
       permanent: true,
    );
    Get.put<DashboardController>(
      DashboardController(),
       permanent: false,
    );
    
  }
}