import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/account%20management%20models/account_summary_model.dart';
import 'package:smartbecho/models/account%20management%20models/account_summay_dashboard_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:dio/dio.dart' as dio;
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/debuggers.dart';

class AccountManagementController extends GetxController {
  // Utility methods
  bool get isSmallScreen => Get.width < 360;
  bool get isMediumScreen => Get.width >= 360 && Get.width < 400;
  double get screenWidth => Get.width;
  double get screenHeight => Get.height;

  // Observable variables
  var selectedTab = 'account-summary'.obs;
  var isLoading = false.obs;

  final Rx<AccountSummaryDashboardModel?> accountDashboardData =
      Rx<AccountSummaryDashboardModel?>(null);

  // API service instance
  final ApiServices _apiService = ApiServices();
  final AppConfig _config = AppConfig.instance;

  // Loading states
  final RxBool isLoadingMore = false.obs;
  final RxBool isStatsLoading = false.obs;
  final RxBool isLoadingFilters = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Animation states
  var isAnimating = false.obs;
  var navBarExpanded = true.obs;
  @override
  void onInit() {
    super.onInit();
    fetchAccountSummaryDashboard();
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

  void refreshData() {}

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

  // Fetch account summary dashboard data from API

  Future<void> fetchAccountSummaryDashboard() async {
    try {
      isStatsLoading.value = true;
      String todaysDate = getTodayDate();
      log("Fetching account summary dashboard...");

      dio.Response? response = await _apiService.requestGetForApi(
        url: "${_config.baseUrl}/api/ledger/analytics/daily?date=$todaysDate",
        authToken: true,
      );

      if (response != null) {
        final statsResponse = AccountSummaryDashboardModel.fromJson(
          response.data,
        );
        accountDashboardData.value = statsResponse;

        log("Account summary dashboard data: ${statsResponse.payload}");
        log("Account summary dashboard status: ${accountDashboardData}");

        if (statsResponse.status == "Success") {
          log("Account summary dashboard loaded successfully");
        } else {
          throw Exception(statsResponse.message);
        }
      } else {
        throw Exception('No stats data received from server');
      }
    } catch (error) {
      log("❌ Error in fetchSalesStats: $error");
      Get.snackbar(
        'Error',
        'Failed to load sales stats: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorLight.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isStatsLoading.value = false;
    }
  }

  // Getters for account dashboard summary data
  double get openingBalance =>
      accountDashboardData.value?.payload.openingBalance ?? 0.0;
  double get totalCredit =>
      accountDashboardData.value?.payload.totalCredit ?? 0.0;
  double get totalDebit =>
      accountDashboardData.value?.payload.totalDebit ?? 0.0;
  double get closingBalance =>
      accountDashboardData.value?.payload.closingBalance ?? 0.0;
  double get emiReceivedToday =>
      accountDashboardData.value?.payload.emiReceivedToday ?? 0.0;
  double get duesRecovered =>
      accountDashboardData.value?.payload.duesRecovered ?? 0.0;
  double get payBills => accountDashboardData.value?.payload.payBills ?? 0.0;
  double get withdrawals =>
      accountDashboardData.value?.payload.withdrawals ?? 0.0;
  double get commissionReceived =>
      accountDashboardData.value?.payload.commissionReceived ?? 0.0;
  double get gstOnSales =>
      accountDashboardData.value?.payload.gst.gstOnSales ?? 0.0;
  double get gstOnPurchases =>
      accountDashboardData.value?.payload.gst.gstOnPurchases ?? 0.0;
  double get netGst => accountDashboardData.value?.payload.gst.netGst ?? 0.0;
  String get shopId => accountDashboardData.value?.payload.shopId ?? '';
  double get totalSale =>
      accountDashboardData.value?.payload.sale.totalSale ?? 0.0;
  double get downPayment =>
      accountDashboardData.value?.payload.sale.downPayment ?? 0.0;
  double get givenAsDues =>
      accountDashboardData.value?.payload.sale.givenAsDues ?? 0.0;
  double get pendingEMI =>
      accountDashboardData.value?.payload.sale.pendingEMI ?? 0.0;

  Map<String, double> get moneyInOut => {
    "Money Out": accountDashboardData.value?.payload.totalCredit ?? 0,
    "Money In": accountDashboardData.value?.payload.totalDebit ?? 0,
  };

  // Format amount for display
  String get formattedOpeningBalance => '₹${openingBalance.toStringAsFixed(2)}';
  String get formattedTotalCredit => '₹${totalCredit.toStringAsFixed(2)}';
  String get formattedTotalDebit => '₹${totalDebit.toStringAsFixed(2)}';
  String get formattedClosingBalance =>
      '₹${closingBalance.toStringAsFixed(2)}  ';
  String get formattedEmiReceivedToday =>
      '₹${emiReceivedToday.toStringAsFixed(2)}';
  String get formattedDuesRecovered => '₹${duesRecovered.toStringAsFixed(2)}';
  String get formattedPayBills => '₹${payBills.toStringAsFixed(2)}';
  String get formattedWithdrawals => '₹${withdrawals.toStringAsFixed(2)}';
  String get formattedCommissionReceived =>
      '₹${commissionReceived.toStringAsFixed(2)}';
  String get formattedGstOnSales => '₹${gstOnSales.toStringAsFixed(2)}';
  String get formattedGstOnPurchases => '₹${gstOnPurchases.toStringAsFixed(2)}';
  String get formattedNetGst => '₹${netGst.toStringAsFixed(2)}';
  String get formattedTotalSale => '₹${totalSale.toStringAsFixed(2)}';
  String get formattedDownPayment => '₹${downPayment.toStringAsFixed(2)}  ';
  String get formattedGivenAsDues => '₹${givenAsDues.toStringAsFixed(2)}';
  String get formattedPendingEMI => '₹${pendingEMI.toStringAsFixed(2)}';
  String get formattedShopId => shopId.isNotEmpty ? shopId : 'N/A';
}
