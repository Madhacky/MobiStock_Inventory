import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobistock/controllers/customer_controller.dart';
import 'package:mobistock/utils/common_chart_loader.dart';
import 'package:mobistock/utils/custom_appbar.dart';
import 'package:mobistock/utils/generic_charts.dart';
import 'package:mobistock/views/customer/customer_screen_shimmers.dart';
import 'package:mobistock/views/dashboard/widgets/dashboard_shimmers.dart';
import 'package:mobistock/views/dashboard/widgets/error_cards.dart';

class CustomerAnalytics extends StatefulWidget {
  const CustomerAnalytics({super.key});

  @override
  State<CustomerAnalytics> createState() => _CustomerAnalyticsState();
}

class _CustomerAnalyticsState extends State<CustomerAnalytics>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCustomerCount = 5;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    customerAnalyticsController.fetchMonthlyNewCustomerChart();
    customerAnalyticsController.fetchVillageDistributionChart();
    customerAnalyticsController.fetchMonthlyRepeatCustomerChart();
    customerAnalyticsController.fetchTopCustomerChart();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final customerAnalyticsController = Get.find<CustomerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            buildCustomAppBar("Customer Analytics", isdark: true),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildNewCustomersTab(),
                  _buildRepeatCustomersTab(),
                  _buildTopCustomersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(6),
        child: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C5CE7).withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          indicatorPadding: EdgeInsets.zero,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[600],
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.2,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: Colors.grey[500],
            letterSpacing: 0.1,
          ),
          splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          dividerColor: Colors.transparent,
          tabs: [
            _buildTab('New', Icons.person_add_outlined),
            _buildTab('Repeat', Icons.refresh_outlined),
            _buildTab('Top', Icons.star_outline),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, IconData icon) {
    return Tab(
      height: 48,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewCustomersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isSmallScreen = screenWidth < 600;

          if (isSmallScreen) {
            return Column(
              children: [
                commonChartloader(
                  isChartLoaded:
                      customerAnalyticsController
                          .isMonthlyNewCustomerChartLoading,
                  chartTitle: 'Monthly New Customers',
                  chartHasError:
                      customerAnalyticsController
                          .hasMonthlyNewCustomerChartError,
                  chartErrorMessage:
                      customerAnalyticsController
                          .monthlyNewCustomerCharterrorMessage,
                  chartData:
                      customerAnalyticsController.monthlyNewCustomerPayload,
                  chartDataType: ChartDataType.quantity,
                  chartError:
                      customerAnalyticsController
                          .hasMonthlyNewCustomerChartError,
                  isSmallScreen: true,
                ),
                commonChartloader(
                  isChartLoaded:
                      customerAnalyticsController
                          .isVillageDistributionChartLoading,
                  chartTitle: 'Village Distribution',
                  chartHasError:
                      customerAnalyticsController
                          .hasVillageDistributionChartError,
                  chartErrorMessage:
                      customerAnalyticsController
                          .villageDistributionChartErrorMessage,
                  chartData:
                      customerAnalyticsController.villageDistributionPayload,
                  chartDataType: ChartDataType.quantity,
                  chartError:
                      customerAnalyticsController
                          .hasVillageDistributionChartError,
                  isSmallScreen: true,
                ),
                const SizedBox(height: 16),
                Obx(
                  () => customerAnalyticsController
                          .isVillageDistributionChartLoading
                          .value
                      ? const SizedBox.shrink()
                      : _buildLegendCard(),
                ),
              ],
            );
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: commonChartloader(
                    isChartLoaded:
                        customerAnalyticsController
                            .isMonthlyNewCustomerChartLoading,
                    chartTitle: 'Monthly New Customers',
                    chartHasError:
                        customerAnalyticsController
                            .hasMonthlyNewCustomerChartError,
                    chartErrorMessage:
                        customerAnalyticsController
                            .monthlyNewCustomerCharterrorMessage,
                    chartData:
                        customerAnalyticsController.monthlyNewCustomerPayload,
                    chartDataType: ChartDataType.quantity,
                    chartError:
                        customerAnalyticsController
                            .hasMonthlyNewCustomerChartError,
                    isSmallScreen: isSmallScreen,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      commonChartloader(
                        isChartLoaded:
                            customerAnalyticsController
                                .isVillageDistributionChartLoading,
                        chartTitle: 'Village Distribution',
                        chartHasError:
                            customerAnalyticsController
                                .hasVillageDistributionChartError,
                        chartErrorMessage:
                            customerAnalyticsController
                                .villageDistributionChartErrorMessage,
                        chartData:
                            customerAnalyticsController
                                .villageDistributionPayload,
                        chartDataType: ChartDataType.quantity,
                        chartError:
                            customerAnalyticsController
                                .hasVillageDistributionChartError,
                        isSmallScreen: isSmallScreen,
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => customerAnalyticsController
                                .isVillageDistributionChartLoading
                                .value
                            ? const SizedBox.shrink()
                            : _buildLegendCard(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildRepeatCustomersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isSmallScreen = screenWidth < 600;

          return GenericLineChart(
            title: 'Monthly Repeat Customers',
            payload: customerAnalyticsController.monthlyRepeatCustomerPayload,
            screenWidth: screenWidth,
            isSmallScreen: isSmallScreen,
            dataType: ChartLineDataType.users,
            chartHeight: 400,
          );
        },
      ),
    );
  }

  Widget _buildTopCustomersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isSmallScreen = screenWidth < 600;

          return Obx(
            () => customerAnalyticsController
                    .isTopCustomerChartLoading
                    .value
                ? buildTopCustomersShimmer(isSmallScreen)
                : customerAnalyticsController
                        .hasTopCustomerChartError
                        .value
                    ? buildErrorCard(
                        customerAnalyticsController
                            .topCustomerChartErrorMessage,
                        Get.width,
                        Get.height,
                        true,
                      )
                    : Column(
                        children: [
                          _buildTopCustomersChart(screenWidth, isSmallScreen),
                          const SizedBox(height: 16),
                          _buildTopCustomersList(),
                        ],
                      ),
          );
        },
      ),
    );
  }

  Widget _buildTopCustomersChart(double screenWidth, bool isSmallScreen) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Customers Overview',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Top Customers by Purchase Amount',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildCustomerCountDropdown(),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: Obx(
              () => customerAnalyticsController.isTopCustomerChartLoading.value
                  ? const GenericBarChartShimmer(title: "")
                  : customerAnalyticsController
                          .hasTopCustomerChartError
                          .value
                      ? buildErrorCard(
                          customerAnalyticsController
                              .topCustomerChartErrorMessage,
                          screenWidth,
                          Get.height,
                          isSmallScreen,
                        )
                      : _buildHorizontalBarChartFromList(
                          customerAnalyticsController.topCustomerChartData,
                          isSmallScreen,
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCountDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF6C5CE7).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF6C5CE7).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Show top',
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
          ),
          const SizedBox(width: 8),
          DropdownButton<int>(
            value: _selectedCustomerCount,
            dropdownColor: Colors.white,
            underline: Container(),
            style: const TextStyle(
              color: Color(0xFF6C5CE7),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            items: [5, 10, 15, 20].map((count) {
              return DropdownMenuItem<int>(
                value: count,
                child: Text('$count'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCustomerCount = value!;
              });
            },
          ),
          const SizedBox(width: 8),
          Text(
            'customers',
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalBarChartFromList(
    List<Map<String, dynamic>> dataList,
    bool isSmallScreen,
  ) {
    final maxValue = dataList.isNotEmpty
        ? dataList
            .map((e) => e['totalSales'] as double)
            .reduce((a, b) => a > b ? a : b)
        : 100.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            children: dataList.map((entry) {
              final name = entry['name'] ?? '';
              final value = (entry['totalSales'] as num).toDouble();
              final percentage = value / maxValue;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: isSmallScreen ? 60 : 80,
                      child: Text(
                        name,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: isSmallScreen ? 10 : 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 800),
                              width: (constraints.maxWidth - 92) * percentage,
                              height: 32,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6C5CE7),
                                    Color(0xFFA29BFE),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  '₹${_formatAmount(value)}',
                                  style: TextStyle(
                                    color: percentage > 0.5
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: isSmallScreen ? 10 : 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildTopCustomersList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Rankings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF6C5CE7).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  '#',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    'Customer',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Text(
                  'Amount',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...customerAnalyticsController.topCustomerChartData
              .asMap()
              .entries
              .map((entry) {
            final index = entry.key;
            final customer = entry.value;
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: index.isEven ? Colors.grey[50] : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      customer['name'],
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '₹${_formatAmount(customer['totalSales'])}',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLegendCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location Distribution',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: customerAnalyticsController.villageDistributionPayload
                .entries
                .map((entry) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getColorForLocation(entry.key),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${entry.key} (${entry.value.toInt()}%)',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getColorForLocation(String location) {
    const colors = [
      Color(0xFF6C5CE7),
      Color(0xFFFF9500),
      Color(0xFF51CF66),
      Color(0xFFE74C3C),
      Color(0xFF00CEC9),
      Color(0xFFA29BFE),
    ];
    final index = customerAnalyticsController.villageDistributionPayload.keys
        .toList()
        .indexOf(location);
    return colors[index % colors.length];
  }

 

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}