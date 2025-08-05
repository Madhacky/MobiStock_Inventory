import 'dart:developer' show log;

import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:smartbecho/models/sales%20history%20models/charts/salesInsight_paymentMethods_model.dart';
import 'package:smartbecho/models/sales%20history%20models/charts/salesInsight_productAnalysis_model.dart';
import 'package:smartbecho/models/sales%20history%20models/charts/salesInsight_revenue_model.dart';

import 'package:smartbecho/services/api_services.dart';

class SalesInsightsAnalyticsController extends GetxController {
  final ApiServices _apiService = ApiServices();

  // Utility methods
  bool get isSmallScreen => Get.width < 360;
  bool get isMediumScreen => Get.width >= 360 && Get.width < 400;
  double get screenWidth => Get.width;
  double get screenHeight => Get.height;

  final RxString selectedTab = 'Revenue Trends'.obs;
  void onTabChanged(String tab) {
    selectedTab.value = tab;
  }

  // 'dashboard', 'history', 'insights'

  ///
  RxnInt selectedMonth = RxnInt();
  RxnInt selectedYear = RxnInt();
  RxnInt selectedInsightRevenueYear = RxnInt();

  RxBool isSalesInsightAnalyticsRevenueLoading = false.obs;
  var salesInsightAnalyticsRevenueErrorMessage = ''.obs;
  var hasSalesInsightAnalyticsRevenueError = false.obs;

  RxMap<String, double> salesInsightAnalyticsRevenueChartPayload =
      RxMap<String, double>({});

  RxMap<String, double> salesInsightAnalyticsBrandDistributionChartPayload =
      RxMap<String, double>({});
  RxMap<String, double> salesInsightAnalyticsTopSellingModelsChartPayload =
      RxMap<String, double>({});

  RxMap<String, double> salesInsightAnalyticsPaymentMethodsChartPayload =
      RxMap<String, double>({});

  @override
  void onInit() {
    super.onInit();
    fetchSalesInsightAnalyticsData(year: DateTime.now().year);
    fetchSalesInsightAnalyticsPaymentMethods(year: DateTime.now().year);
    fetchSalesInsightAnalyticsBrandDistribution(year: DateTime.now().year);
    fetchSalesInsightAnalyticsTopSellingModels(year: DateTime.now().year);
    fetchCompanyDropDownList(); // Fetch list on init
  }

  // API Endpoints
  String get salesInsightRevenueUrl =>
      'https://backend-production-91e4.up.railway.app/api/sales/revenue/monthly?';
  String get salesInsightPaymentMethodsUrl =>
      'https://backend-production-91e4.up.railway.app/api/sales/payment-distribution?';

  String get salesInsightTopSellingModelsUrl =>
      'https://backend-production-91e4.up.railway.app/api/sales/top-models?';

  String get salesInsightBrandDistributionUrl =>
      'https://backend-production-91e4.up.railway.app/api/sales/brand-sales?';

  Future<void> fetchSalesInsightAnalyticsData({int? year}) async {
    try {
      isSalesInsightAnalyticsRevenueLoading.value = true;
      hasSalesInsightAnalyticsRevenueError.value = false;
      salesInsightAnalyticsRevenueErrorMessage.value = '';

      // Build query parameters
      final queryParams = <String, dynamic>{};
      if (year != null) queryParams['year'] = year;

      dio.Response? response = await _apiService.requestGetForApi(
        url: salesInsightRevenueUrl,
        dictParameter: queryParams.isNotEmpty ? queryParams : null,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final responseData = SalesinsightRevenueModel.fromJson(response.data);
        salesInsightAnalyticsRevenueChartPayload.value = responseData.payload;
        log("Sales Insight Analytics Data: ${responseData.toString()}");
        log(
          "Sales Insight Analytics Revenue Chart Payload: ${salesInsightAnalyticsRevenueChartPayload}",
        );
      } else {
        hasSalesInsightAnalyticsRevenueError.value = true;
        salesInsightAnalyticsRevenueErrorMessage.value =
            'Failed to fetch data. Status: ${response?.statusCode}';
      }
    } catch (error) {
      hasSalesInsightAnalyticsRevenueError.value = true;
      salesInsightAnalyticsRevenueErrorMessage.value = 'Error: $error';
    } finally {
      isSalesInsightAnalyticsRevenueLoading.value = false;
    }
  }

  RxnInt selectedInsightPaymentMethodsYear = RxnInt();
  RxnInt selectedInsightPaymentMethodsMonth = RxnInt();

  RxBool isSalesInsightAnalyticsPaymentMethodsLoading = false.obs;
  var salesInsightAnalyticsPaymentMethodsErrorMessage = ''.obs;
  var hasSalesInsightAnalyticsPaymentMethodsError = false.obs;
  RxMap<String, double> salesInsightAnalyticsTotalPurchasedAmounts =
      RxMap<String, double>({});

  Future<void> fetchSalesInsightAnalyticsPaymentMethods({
    int? year,
    int? month,
  }) async {
    try {
      isSalesInsightAnalyticsPaymentMethodsLoading.value = true;
      hasSalesInsightAnalyticsPaymentMethodsError.value = false;
      salesInsightAnalyticsPaymentMethodsErrorMessage.value = '';

      // Build query parameters
      final queryParams = <String, dynamic>{};
      if (year != null) queryParams['year'] = year;
      if (month != null) queryParams['month'] = month;

      dio.Response? response = await _apiService.requestGetForApi(
        url: salesInsightPaymentMethodsUrl,
        dictParameter: queryParams.isNotEmpty ? queryParams : null,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final responseData = SalesinsightPaymentmethodsModel.fromJson(
          response.data,
        );
        salesInsightAnalyticsPaymentMethodsChartPayload.value =
            (responseData.payload!.distributions != null
                ? responseData.payload!.distributions!.asMap().map((
                  key,
                  value,
                ) {
                  return MapEntry(
                    value.paymentMethod ?? 'Unknown',
                    value.totalAmount ?? 0.0,
                  );
                })
                : {});

        log("Sales Insight Analytics Data: ${responseData.toString()}");
        log(
          "Sales Insight Analytics Payment Methods Chart Payload: ${salesInsightAnalyticsPaymentMethodsChartPayload}",
        );
      } else {
        hasSalesInsightAnalyticsPaymentMethodsError.value = true;
        salesInsightAnalyticsPaymentMethodsErrorMessage.value =
            'Failed to fetch data. Status: ${response?.statusCode}';
      }
    } catch (error) {
      hasSalesInsightAnalyticsPaymentMethodsError.value = true;
      salesInsightAnalyticsPaymentMethodsErrorMessage.value = 'Error: $error';
    } finally {
      isSalesInsightAnalyticsPaymentMethodsLoading.value = false;
    }
  }

  RxnInt selectedInsightBrandDistributionYear = RxnInt();
  RxnInt selectedInsightBrandDistributionMonth = RxnInt();
  RxnString selectedInsightBrandDistributionCompany = RxnString();

  RxBool isSalesInsightAnalyticsBrandDistributionLoading = false.obs;
  var salesInsightAnalyticsBrandDistributionErrorMessage = ''.obs;
  var hasSalesInsightAnalyticsBrandDistributionError = false.obs;
  RxMap<String, double> salesInsightAnalyticsBrandDistributionAmounts =
      RxMap<String, double>({});

  Future<void> fetchSalesInsightAnalyticsBrandDistribution({
    int? year,
    int? month,
    String? company,
  }) async {
    try {
      isSalesInsightAnalyticsBrandDistributionLoading.value = true;
      hasSalesInsightAnalyticsBrandDistributionError.value = false;
      salesInsightAnalyticsBrandDistributionErrorMessage.value = '';

      // Build query parameters
      final queryParams = <String, dynamic>{};
      if (year != null) queryParams['year'] = year;
      if (month != null) queryParams['month'] = month;
      if (company != null) queryParams['company'] = company;

      dio.Response? response = await _apiService.requestGetForApi(
        url: salesInsightBrandDistributionUrl,
        dictParameter: queryParams.isNotEmpty ? queryParams : null,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final responseData = SalesinsightBrandDistributionModel.fromJson(
          response.data,
        );

        log("Sales Insight Analytics Data: ${responseData.toString()}");
        log(
          "Sales Insight Analytics Payment Methods Chart Payload: ${salesInsightAnalyticsBrandDistributionAmounts}",
        );
      } else {
        hasSalesInsightAnalyticsBrandDistributionError.value = true;
        salesInsightAnalyticsBrandDistributionErrorMessage.value =
            'Failed to fetch data. Status: ${response?.statusCode}';
      }
    } catch (error) {
      hasSalesInsightAnalyticsBrandDistributionError.value = true;
      salesInsightAnalyticsBrandDistributionErrorMessage.value =
          'Error: $error';
    } finally {
      isSalesInsightAnalyticsBrandDistributionLoading.value = false;
    }
  }

  RxnInt selectedInsightTopSellingModelsYear = RxnInt();
  RxnInt selectedInsightTopSellingModelsMonth = RxnInt();

  RxBool isSalesInsightAnalyticsTopSellingModelsLoading = false.obs;
  var salesInsightAnalyticsTopSellingModelsErrorMessage = ''.obs;
  var hasSalesInsightAnalyticsTopSellingModelsError = false.obs;
  RxMap<String, double> salesInsightAnalyticsTopSellingModelsAmounts =
      RxMap<String, double>({});

  Future<void> fetchSalesInsightAnalyticsTopSellingModels({
    int? year,
    int? month,
  }) async {
    try {
      isSalesInsightAnalyticsTopSellingModelsLoading.value = true;
      hasSalesInsightAnalyticsTopSellingModelsError.value = false;
      salesInsightAnalyticsTopSellingModelsErrorMessage.value = '';

      // Build query parameters
      final queryParams = <String, dynamic>{};
      if (year != null) queryParams['year'] = year;
      if (month != null) queryParams['month'] = month;

      dio.Response? response = await _apiService.requestGetForApi(
        url: salesInsightTopSellingModelsUrl,
        dictParameter: queryParams.isNotEmpty ? queryParams : null,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final responseData = SalesinsightTopSellingModelsModel.fromJson(
          response.data,
        );
        salesInsightAnalyticsTopSellingModelsAmounts.value = responseData
            .payload
            .asMap()
            .map((key, value) {
              return MapEntry(value.model.toString(), value.totalAmount);
            });

        log("Sales Insight Analytics Data: ${responseData.toString()}");
        log(
          "Sales Insight Analytics Payment Methods Chart Payload: ${salesInsightAnalyticsTopSellingModelsAmounts}",
        );
      } else {
        hasSalesInsightAnalyticsTopSellingModelsError.value = true;
        salesInsightAnalyticsTopSellingModelsErrorMessage.value =
            'Failed to fetch data. Status: ${response?.statusCode}';
      }
    } catch (error) {
      hasSalesInsightAnalyticsTopSellingModelsError.value = true;
      salesInsightAnalyticsTopSellingModelsErrorMessage.value = 'Error: $error';
    } finally {
      isSalesInsightAnalyticsTopSellingModelsLoading.value = false;
    }
  }

  RxnString selectedCompany = RxnString();

  // companyDropDownList
  final RxList<String> companyDropDownList = <String>[].obs;
  Future<void> fetchCompanyDropDownList() async {
    try {
      dio.Response? response = await _apiService.requestGetForApi(
        url:
            'https://backend-production-91e4.up.railway.app/api/mobiles/filters',
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final responsData = CompanyDropDownList.fromJson(response.data);
        companyDropDownList.value = responsData.itemCategories ?? [];
        log("Company Drop Down List: ${companyDropDownList.toString()}");
      } else {
        log(
          'Failed to fetch company drop down list. Status: ${response?.statusCode}',
        );
      }
    } catch (error) {
      log('Error fetching company drop down list: $error');
    }
  }
}
