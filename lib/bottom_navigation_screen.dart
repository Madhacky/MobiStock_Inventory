import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/account%20management%20controller/account_management_controller.dart';
import 'package:smartbecho/controllers/auth%20controllers/auth_controller.dart';
import 'package:smartbecho/controllers/bill%20history%20controllers/bill_history_controller.dart';
import 'package:smartbecho/controllers/customer%20controllers/customer_controller.dart';
import 'package:smartbecho/controllers/customer%20dues%20controllers/customer_dues_controller.dart';
import 'package:smartbecho/controllers/dashboard_controller.dart';
import 'package:smartbecho/controllers/inventory%20controllers/inventory_management_controller.dart';
import 'package:smartbecho/controllers/sales%20hisrory%20controllers/sales_history_comtroller.dart';
import 'package:smartbecho/controllers/user_prefs_controller.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/views/account%20management/account_management.dart';
import 'package:smartbecho/views/bill%20history/bill_history.dart';
import 'package:smartbecho/views/customer%20dues/customer_dues_management.dart';
import 'package:smartbecho/views/dashboard/dashboard_screen.dart';
import 'package:smartbecho/views/inventory/inventory_management.dart';
import 'package:smartbecho/views/sales%20management/sales_managenment_screen.dart';

/// Controller to manage the selected tab
class BottomNavigationController extends GetxController {
  final InventoryController inventoryController = Get.put<InventoryController>(
    InventoryController(),
  );
  final DashboardController dashboardController = Get.put(
    DashboardController(),
  );
  final CustomerController customerController = Get.put(CustomerController());
  final SalesManagementController salesManagementController = Get.put(
    SalesManagementController(),
  );
  final AuthController authController = Get.put(AuthController());
  final CustomerDuesController customerDuesController = Get.put(
    CustomerDuesController(),
  );
  final UserPrefsController userPrefsController = Get.put(
    UserPrefsController(),
    permanent: true,
  );
  final AccountManagementController accountManagementController = Get.put(
    AccountManagementController(),
  );
  final BillHistoryController billHistoryController = Get.put(
    BillHistoryController(),
  );

  var selectedIndex = 0.obs;

  void setIndex(int i) => selectedIndex.value = i;

  // Your actual pages
  final pages = <Widget>[
    InventoryDashboard(),
    InventoryManagementScreen(),
    BillsHistoryPage(),
    SalesManagementScreen(),
    CustomerDuesManagementScreen(),
    AccountManagementScreen(),
  ];
}

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(BottomNavigationController());

    return Obx(
      () => Scaffold(
        body: IndexedStack(index: c.selectedIndex.value, children: c.pages),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color.fromARGB(255, 0, 0, 0),
              width: 1,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: c.selectedIndex.value,
              onTap: c.setIndex,
              selectedItemColor: AppTheme.primaryLight,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.inventory_2_outlined),
                  label: 'Inventory',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long_outlined),
                  label: 'Bills',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sell_outlined),
                  label: 'Sales',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.money_off_csred_outlined),
                  label: 'Dues',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  label: 'Accounts',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
