import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/account%20management%20models/account_summary_dashboard_model.dart';
import 'package:smartbecho/models/account%20management%20models/account_summary_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:dio/dio.dart' as dio;

class AccountManagementController extends GetxController {
  // Utility methods
  bool get isSmallScreen => Get.width < 360;
  bool get isMediumScreen => Get.width >= 360 && Get.width < 400;
  double get screenWidth => Get.width;
  double get screenHeight => Get.height;

  // Observable variables
  var selectedTab = 'account-summary'.obs;
  var isLoading = false.obs;
  var accountData = Rxn<AccountSummaryModel>();

  final Rx<AccountSummaryDashboardModel?> accountDashboardData =
      Rx<AccountSummaryDashboardModel?>(null);

  // API service instance
  final ApiServices _apiService = ApiServices();
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
    loadAccountData();
    fetchAccountSummaryDashboard();
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

  // Base URLs for sales API
  String get accountSummaryDashboardUrl =>
      'https://backend-production-91e4.up.railway.app/api/ledger/analytics/daily?date=2025-08-06';

  // Fetch account summary dashboard data from API
  Future<void> fetchAccountSummaryDashboard() async {
    try {
      isStatsLoading.value = true;

      log("Fetching account summary dashboard...");

      dio.Response? response = await _apiService.requestGetForApi(
        url: accountSummaryDashboardUrl,
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
        backgroundColor: Colors.red.withOpacity(0.8),
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

  Map<String, double> get creditByAccount =>
      accountDashboardData.value?.payload.creditByAccount ?? {};
  Map<String, double> get debitByAccount =>
      accountDashboardData.value?.payload.debitByAccount ?? {};

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
