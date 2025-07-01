import 'package:get/get.dart';
import 'package:smartbecho/models/account%20management%20models/account_summary_model.dart';

class AccountManagementController extends GetxController {
  // Observable variables
  var selectedTab = 'account-summary'.obs;
  var isLoading = false.obs;
  var accountData = Rxn<AccountSummaryModel>();
  
  // Animation states
  var isAnimating = false.obs;
  var navBarExpanded = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadAccountData();
  }
  
  void loadAccountData() {
    isLoading.value = true;
    
    // Simulate API call
    Future.delayed(Duration(seconds: 1), () {
      accountData.value = AccountSummaryModel(
        openingBalance: 25000,
        inCounterCash: 15000,
        inAccountBalance: 35000,
        totalSales: 120000,
        totalPaidBills: 45000,
        totalCommission: 8500,
        netBalance: 83500,
        closingBalance: 108500,
        cashPercentage: 30,
        accountPercentage: 70,
      );
      isLoading.value = false;
    });
  }
  
  void onTabChanged(String tabId) {
    if (tabId != selectedTab.value) {
      isAnimating.value = true;
      selectedTab.value = tabId;
      
      // Simulate screen transition animation
      Future.delayed(Duration(milliseconds: 300), () {
        isAnimating.value = false;
      });
      
      
    }
  }
  
  void refreshData() {
    loadAccountData();
  }
  
  void toggleNavBar() {
    navBarExpanded.value = !navBarExpanded.value;
  }
  
  String formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }
}