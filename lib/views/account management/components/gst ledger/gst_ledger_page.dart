// views/account management/gst_ledger_history_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/account%20management%20controller/gst_ledger_controller.dart';
import 'package:smartbecho/models/account%20management%20models/gst_ledger_model.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/utils/custom_dropdown.dart';

class GstLedgerHistoryPage extends StatefulWidget {
  @override
  _GstLedgerHistoryPageState createState() => _GstLedgerHistoryPageState();
}

class _GstLedgerHistoryPageState extends State<GstLedgerHistoryPage>
    with TickerProviderStateMixin {
  final GstLedgerController controller = Get.put(GstLedgerController());

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with count
        Row(
          children: [
            Expanded(
              child: Text(
                'GST Ledger History',
                style: AppStyles.custom(
                  color: const Color(0xFF1A1A1A),
                  size: 20,
                  weight: FontWeight.w600,
                ),
              ),
            ),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${controller.filteredLedgerEntries.length} Entries',
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
        const SizedBox(height: 16),

        // Search Bar
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          ),
          child: TextField(
            controller: controller.searchController,
            onChanged: controller.onSearchChanged,
            decoration: const InputDecoration(
              hintText: 'Search ledger entries...',
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
        const SizedBox(height: 16),

        // Filter Toggle Button
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
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
                            color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
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

        // Expandable Filter Section
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Row - Entity Name and Transaction Type
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => buildStyledDropdown(
                          labelText: 'Entity Name',
                          hintText: 'Select Entity',
                          value: controller.selectedEntityName.value == 'All'
                              ? null
                              : controller.selectedEntityName.value,
                          items: controller.entityNames
                              .where((item) => item != 'All')
                              .toList(),
                          onChanged: (value) =>
                              controller.onEntityNameChanged(value ?? 'All'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(
                        () => buildStyledDropdown(
                          labelText: 'Transaction Type',
                          hintText: 'Select Type',
                          value: controller.selectedTransactionType.value == 'All'
                              ? null
                              : controller.selectedTransactionType.value,
                          items: controller.transactionTypes
                              .where((item) => item != 'All')
                              .toList(),
                          onChanged: (value) =>
                              controller.onTransactionTypeChanged(value ?? 'All'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Second Row - HSN Code and Date Selection
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => buildStyledDropdown(
                          labelText: 'HSN Code',
                          hintText: 'Select HSN',
                          value: controller.selectedHsnCode.value == 'All'
                              ? null
                              : controller.selectedHsnCode.value,
                          items: controller.hsnCodes
                              .where((item) => item != 'All')
                              .toList(),
                          onChanged: (value) =>
                              controller.onHsnCodeChanged(value ?? 'All'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date Selection',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      controller.isCustomDateRange.value = false;
                                      controller.startDateController.clear();
                                      controller.endDateController.clear();
                                      controller.loadLedgerEntries(refresh: true);
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      child: Obx(() => Row(
                                        children: [
                                          Icon(
                                            Icons.radio_button_checked,
                                            size: 16,
                                            color: !controller.isCustomDateRange.value
                                                ? const Color(0xFF3B82F6)
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Month/Year',
                                            style: TextStyle(overflow: TextOverflow.ellipsis,
                                              fontSize: 12,
                                              color: !controller.isCustomDateRange.value
                                                  ? const Color(0xFF3B82F6)
                                                  : Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      controller.isCustomDateRange.value = true;
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      child: Obx(() => Row(
                                        children: [
                                          Icon(
                                            Icons.radio_button_checked,
                                            size: 16,
                                            color: controller.isCustomDateRange.value
                                                ? const Color(0xFF3B82F6)
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Custom',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: controller.isCustomDateRange.value
                                                  ? const Color(0xFF3B82F6)
                                                  : Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Third Row - Month/Year or Custom Date Range
                Obx(() {
                  if (controller.isCustomDateRange.value) {
                    return Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Start Date',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF374151),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => controller.selectStartDate(context),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: Color(0xFF6B7280),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              controller.startDateController.text.isEmpty
                                                  ? 'Select start date'
                                                  : controller.startDateController.text,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: controller.startDateController.text.isEmpty
                                                    ? const Color(0xFF9CA3AF)
                                                    : const Color(0xFF374151),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'End Date',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF374151),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => controller.selectEndDate(context),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: Color(0xFF6B7280),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              controller.endDateController.text.isEmpty
                                                  ? 'Select end date'
                                                  : controller.endDateController.text,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: controller.endDateController.text.isEmpty
                                                    ? const Color(0xFF9CA3AF)
                                                    : const Color(0xFF374151),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => buildStyledDropdown(
                              labelText: 'Month',
                              hintText: 'Month',
                              value: controller.selectedMonth.value.toString(),
                              items: List.generate(
                                12,
                                (index) => (index + 1).toString(),
                              ),
                              onChanged: (value) => controller.onMonthChanged(
                                int.parse(value ?? '1'),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(
                            () => buildStyledDropdown(
                              labelText: 'Year',
                              hintText: 'Year',
                              value: controller.selectedYear.value.toString(),
                              items: List.generate(5, (index) {
                                final year = DateTime.now().year - index;
                                return year.toString();
                              }),
                              onChanged: (value) => controller.onYearChanged(
                                int.parse(
                                  value ?? DateTime.now().year.toString(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }),

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
                color: const Color(0xFF3B82F6).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
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

        // GST Ledger Grid
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.ledgerEntries.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.filteredLedgerEntries.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async => controller.refreshData(),
              child: GridView.builder(
                controller: controller.scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.filteredLedgerEntries.length +
                    (controller.hasMoreData.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= controller.filteredLedgerEntries.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final entry = controller.filteredLedgerEntries[index];
                  return _buildLedgerCard(entry);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildLedgerCard(GstLedgerEntry entry) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with transaction type and amount
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: controller.getTransactionTypeColor(entry.transactionType),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  entry.transactionType == 'CREDIT' 
                      ? Icons.arrow_downward 
                      : Icons.arrow_upward,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.transactionType,
                      style: TextStyle(
                        color: controller.getTransactionTypeColor(entry.transactionType),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      entry.formattedTaxableAmount,
                      style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Entity name with icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: controller.getEntityColor(entry.relatedEntityName)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      entry.relatedEntityName == 'SALE' 
                          ? Icons.shopping_cart 
                          : Icons.shopping_bag,
                      size: 12,
                      color: controller.getEntityColor(entry.relatedEntityName),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      entry.relatedEntityName,
                      style: TextStyle(
                        color: controller.getEntityColor(entry.relatedEntityName),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // GST Rate
          Row(
            children: [
              const Icon(
                Icons.percent,
                size: 14,
                color: Color(0xFF6B7280),
              ),
              const SizedBox(width: 6),
              Text(
                'GST: ${entry.gstRateLabel}',
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // HSN Code
          // Row(
          //   children: [
          //     const Icon(
          //       Icons.qr_code,
          //       size: 14,
          //       color: Color(0xFF6B7280),
          //     ),
          //     const SizedBox(width: 6),
          //     Text(
          //       'HSN: ${entry.hsnCode}',
          //       style: const TextStyle(
          //         color: Color(0xFF6B7280),
          //         fontSize: 12,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 6),

          // Date
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 12,
                color: Color(0xFF6B7280),
              ),
              const SizedBox(width: 6),
              Text(
                entry.formattedDate,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // GST Breakdown (if GST amount > 0)
          if (entry.cgstAmount > 0 || entry.sgstAmount > 0 || entry.igstAmount > 0) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  if (entry.cgstAmount > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('CGST:', style: TextStyle(fontSize: 10)),
                        Text(entry.formattedCgstAmount, style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  if (entry.sgstAmount > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('SGST:', style: TextStyle(fontSize: 10)),
                        Text(entry.formattedSgstAmount, style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  if (entry.igstAmount > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('IGST:', style: TextStyle(fontSize: 10)),
                        Text(entry.formattedIgstAmount, style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                ],
              ),
            ),
          ],

          const Spacer(),

          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showLedgerDetails(entry),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                foregroundColor: const Color(0xFF3B82F6),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'View Details',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 60,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              controller.hasActiveFilters
                  ? 'No ledger entries found'
                  : 'No ledger entries yet',
              style: const TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.hasActiveFilters
                  ? 'Try adjusting your filters to find what you\'re looking for'
                  : 'GST ledger entries will appear here once transactions are recorded',
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            if (controller.hasActiveFilters) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.clearFilters();
                  controller.searchController.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Clear Filters',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showLedgerDetails(GstLedgerEntry entry) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: controller.getTransactionTypeColor(entry.transactionType),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      entry.transactionType == 'CREDIT'
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
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
                          'GST Ledger Details',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        Text(
                          entry.formattedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.withValues(alpha: 0.1),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Amount
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: controller.getTransactionTypeColor(entry.transactionType)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Taxable Amount',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.formattedTaxableAmount,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: controller.getTransactionTypeColor(entry.transactionType),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Details
              _buildDetailRow('ID', entry.id.toString(), Icons.tag),
              _buildDetailRow('Transaction Type', entry.transactionType, Icons.swap_horiz),
              _buildDetailRow('Entity Name', entry.relatedEntityName, Icons.business),
              _buildDetailRow('HSN Code', entry.hsnCode, Icons.qr_code),
              _buildDetailRow('GST Rate', entry.gstRateLabel, Icons.percent),

              // GST Breakdown
              if (entry.cgstAmount > 0 || entry.sgstAmount > 0 || entry.igstAmount > 0) ...[
                const SizedBox(height: 16),
                const Text(
                  'GST Breakdown',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      if (entry.cgstAmount > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('CGST', style: TextStyle(fontSize: 13)),
                            Text(entry.formattedCgstAmount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      if (entry.sgstAmount > 0) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('SGST', style: TextStyle(fontSize: 13)),
                            Text(entry.formattedSgstAmount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                      if (entry.igstAmount > 0) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('IGST', style: TextStyle(fontSize: 13)),
                            Text(entry.formattedIgstAmount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total GST', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(entry.formattedTotalGst, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF6B7280)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}