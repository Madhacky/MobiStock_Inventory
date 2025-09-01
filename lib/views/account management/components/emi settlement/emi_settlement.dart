import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/account%20management%20controller/emi_settlement_controller.dart';
import 'package:smartbecho/models/account%20management%20models/emi%20settlement/emi_settlement_model.dart';
import 'package:intl/intl.dart';
import 'package:smartbecho/utils/custom_dropdown.dart';
import 'package:smartbecho/utils/generic_charts.dart';
import 'package:smartbecho/views/account%20management/components/emi%20settlement/add_emi_settlement.dart';
import 'package:smartbecho/views/account%20management/widgets/emi_settlement_chart.dart';
import 'package:smartbecho/views/dashboard/charts/switchable_chart.dart';

class EmiSettlementPage extends StatefulWidget {
  const EmiSettlementPage({Key? key}) : super(key: key);

  @override
  State<EmiSettlementPage> createState() => _EmiSettlementPageState();
}

class _EmiSettlementPageState extends State<EmiSettlementPage>
    with TickerProviderStateMixin {
  final EmiSettlementController controller = Get.put(EmiSettlementController());

  bool isFilterExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    controller.scrollController.addListener(_onScroll);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFilter() {
    setState(() {
      isFilterExpanded = !isFilterExpanded;
      if (isFilterExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _onScroll() {
    if (controller.scrollController.position.pixels >=
        controller.scrollController.position.maxScrollExtent - 200) {
      controller.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with count
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'EMI Settlements',
                  style: TextStyle(
                    color: const Color(0xFF1A1A1A),
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => AddEmiSettlementPage());
                    },
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4ECDC4),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4ECDC4).withValues(alpha:0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, color: Colors.white, size: 18),
                          const SizedBox(width: 6),
                          const Text(
                            'Add Emi settlement',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${controller.filteredSettlements.length}',
                    style: const TextStyle(
                      color: Color(0xFF3B82F6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha:0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha:0.1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: controller.onSearchChanged,
                    decoration: const InputDecoration(
                      hintText: 'Search settlements...',
                      hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFF9CA3AF),
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha:0.2),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _showChartModal,
                      borderRadius: BorderRadius.circular(20),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.analytics_outlined,
                              color: Color(0xFF10B981),
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Charts',
                              style: TextStyle(
                                color: Color(0xFF10B981),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Filter Toggle Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha:0.2)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _toggleFilter,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: const Color(0xFF3B82F6),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Filters',
                        style: TextStyle(
                          color: Color(0xFF374151),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Obx(() {
                        if (controller.hasActiveFilters) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withValues(alpha:0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Active',
                              style: const TextStyle(
                                color: Color(0xFF3B82F6),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: isFilterExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF6B7280),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Expandable Filter Section
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha:0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Row - Company and Confirmed By
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => buildStyledDropdown(
                          labelText: 'Company',
                          hintText: 'Select company',
                          items: controller.companyOptions,
                          value: controller.selectedCompany.value,
                          onChanged: controller.onCompanyChanged,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(
                        () => buildStyledDropdown(
                          labelText: 'Confirmed By',
                          hintText: 'Select confirmer',
                          items: controller.confirmedByOptions,
                          value: controller.selectedConfirmedBy.value,
                          onChanged: controller.onConfirmedByChanged,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Second Row - Month and Year
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => buildStyledDropdown(
                          labelText: 'Month',
                          hintText: 'Month',
                          items: List.generate(
                            12,
                            (index) => controller.months[index],
                          ),
                          value:
                              controller.months[controller.selectedMonth.value -
                                  1],
                          onChanged: (value) {
                            if (value != null) {
                              controller.onMonthChanged(
                                controller.months.indexOf(value) + 1,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(
                        () => buildStyledDropdown(
                          labelText: 'Year',
                          hintText: 'Year',
                          items: List.generate(
                            5,
                            (index) =>
                                (DateTime.now().year - 2 + index).toString(),
                          ),
                          value: controller.selectedYear.value.toString(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.onYearChanged(int.parse(value));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // Clear Filters Button
                Obx(() {
                  if (controller.hasActiveFilters) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            controller.clearFilters();
                            controller.searchController.clear();
                          },
                          icon: const Icon(Icons.clear, size: 16),
                          label: const Text(
                            'Clear All Filters',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF4444),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Filter Summary
        Obx(() {
          if (controller.hasActiveFilters) {
            return Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withValues(alpha:0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF3B82F6).withValues(alpha:0.1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF3B82F6),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      controller.getFilterSummary(),
                      style: const TextStyle(
                        color: Color(0xFF3B82F6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.clearFilters();
                      controller.searchController.clear();
                    },
                    child: const Icon(
                      Icons.clear,
                      color: Color(0xFF3B82F6),
                      size: 16,
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),

        // Settlements Grid
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.settlements.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.filteredSettlements.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async => controller.refreshData(),
              child: GridView.builder(
                controller: controller.scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                padding: const EdgeInsets.all(16),
                itemCount:
                    controller.filteredSettlements.length +
                    (controller.hasMoreData.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= controller.filteredSettlements.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final settlement = controller.filteredSettlements[index];
                  return _buildSettlementCard(settlement);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSettlementCard(EmiSettlement settlement) {
    return GestureDetector(
      onTap: () => _showSettlementDetails(settlement),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha:0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.withValues(alpha:0.1), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and company + amount
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: controller.getCompanyColor(settlement.companyName),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    controller.getCompanyIcon(settlement.companyName),
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        settlement.companyName,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        settlement.formattedAmount,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    size: 10,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Confirmed By
            // Confirmed By (continuing from where it was cut off)
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 12,
                  color: Color(0xFF6B7280),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Confirmed by:',
                  style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    settlement.confirmedBy,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Shop ID
            Row(
              children: [
                const Icon(
                  Icons.store_outlined,
                  size: 12,
                  color: Color(0xFF6B7280),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Shop ID:',
                  style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    settlement.shopId,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Date
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: Color(0xFF6B7280),
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('MMM dd, yyyy').format(settlement.formattedDate),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Status indicator
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Settled',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF10B981),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 40,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No settlements found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your filters or search terms',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              controller.clearFilters();
              controller.searchController.clear();
              controller.refreshData();
            },
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Reset Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettlementDetails(EmiSettlement settlement) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder:
                (context, scrollController) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Handle bar
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha:0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Header
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: controller.getCompanyColor(
                                  settlement.companyName,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                controller.getCompanyIcon(
                                  settlement.companyName,
                                ),
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    settlement.companyName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                  Text(
                                    settlement.formattedAmount,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.close,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 1),

                      // Details
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // _buildDetailRow(
                              //   'Settlement ID',
                              //   settlement.id.toString(),
                              // ),
                              _buildDetailRow(
                                'Company',
                                settlement.companyName,
                              ),
                              _buildDetailRow(
                                'Amount',
                                settlement.formattedAmount,
                              ),
                              _buildDetailRow(
                                'Confirmed By',
                                settlement.confirmedBy,
                              ),
                              // _buildDetailRow('Shop ID', settlement.shopId),
                              _buildDetailRow(
                                'Date',
                                DateFormat(
                                  'MMMM dd, yyyy',
                                ).format(settlement.formattedDate),
                              ),
                              _buildDetailRow('Status', 'Settled'),

                              // const SizedBox(height: 24),

                              // // Action buttons
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: ElevatedButton.icon(
                              //         onPressed: () {
                              //           // Handle download/export
                              //           Navigator.pop(context);
                              //           Get.snackbar(
                              //             'Download',
                              //             'Settlement details downloaded',
                              //             snackPosition: SnackPosition.BOTTOM,
                              //             backgroundColor: const Color(
                              //               0xFF10B981,
                              //             ),
                              //             colorText: Colors.white,
                              //           );
                              //         },
                              //         icon: const Icon(
                              //           Icons.download,
                              //           size: 16,
                              //         ),
                              //         label: const Text('Download'),
                              //         style: ElevatedButton.styleFrom(
                              //           backgroundColor: const Color(
                              //             0xFF3B82F6,
                              //           ),
                              //           foregroundColor: Colors.white,
                              //           padding: const EdgeInsets.symmetric(
                              //             vertical: 12,
                              //           ),
                              //           shape: RoundedRectangleBorder(
                              //             borderRadius: BorderRadius.circular(
                              //               8,
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //     const SizedBox(width: 12),
                              //     Expanded(
                              //       child: OutlinedButton.icon(
                              //         onPressed: () {
                              //           // Handle share
                              //           Navigator.pop(context);
                              //           Get.snackbar(
                              //             'Share',
                              //             'Settlement details shared',
                              //             snackPosition: SnackPosition.BOTTOM,
                              //             backgroundColor: const Color(
                              //               0xFF10B981,
                              //             ),
                              //             colorText: Colors.white,
                              //           );
                              //         },
                              //         icon: const Icon(Icons.share, size: 16),
                              //         label: const Text('Share'),
                              //         style: OutlinedButton.styleFrom(
                              //           foregroundColor: const Color(
                              //             0xFF3B82F6,
                              //           ),
                              //           side: const BorderSide(
                              //             color: Color(0xFF3B82F6),
                              //           ),
                              //           padding: const EdgeInsets.symmetric(
                              //             vertical: 12,
                              //           ),
                              //           shape: RoundedRectangleBorder(
                              //             borderRadius: BorderRadius.circular(
                              //               8,
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

 void _showChartModal() {
  // Load chart data when modal is opened
  controller.loadChartData();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha:0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.analytics_outlined,
                    color: Color(0xFF3B82F6),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'EMI Settlement Analytics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  // Year Selector
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF3B82F6).withValues(alpha:0.2),
                        ),
                      ),
                      child: DropdownButton<int>(
                        value: controller.chartYear.value,
                        underline: const SizedBox(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF3B82F6),
                          size: 16,
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3B82F6),
                        ),
                        items: List.generate(5, (index) {
                          final year = DateTime.now().year - 2 + index;
                          return DropdownMenuItem(
                            value: year,
                            child: Text(year.toString()),
                          );
                        }),
                        onChanged: (year) {
                          if (year != null) {
                            controller.onChartYearChanged(year);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Chart Content
            Expanded(
              child: Obx(() {
                if (controller.isChartLoading.value) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFF3B82F6),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading chart data...',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!controller.hasChartData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha:0.1),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(
                            Icons.bar_chart,
                            size: 40,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No chart data available',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No data found for ${controller.chartYear.value}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: EmiSettlementChartWidget(
                    title: 'Monthly EMI Settlement Chart',
                    data: controller.chartData,
                    screenWidth: MediaQuery.of(context).size.width,
                    screenHeight: MediaQuery.of(context).size.height,
                    isSmallScreen: MediaQuery.of(context).size.width < 600,
                    initialChartType: "barchart",
                    customColors: const [
                      Color(0xFF3B82F6),
                      Color(0xFF10B981),
                      Color(0xFF8B5CF6),
                      Color(0xFFF59E0B),
                      Color(0xFFEF4444),
                      Color(0xFF06B6D4),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    ),
  );
}
}
