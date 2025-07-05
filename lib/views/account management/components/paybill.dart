import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/account%20management%20controller/pay_bill_controller.dart';
import 'package:smartbecho/models/account%20management%20models/pay_bill_model.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:intl/intl.dart';
import 'package:smartbecho/utils/custom_dropdown.dart';
import 'package:url_launcher/url_launcher.dart';

class PayBillsPage extends StatefulWidget {
  @override
  _PayBillsPageState createState() => _PayBillsPageState();
}

class _PayBillsPageState extends State<PayBillsPage>
    with TickerProviderStateMixin {
  final PayBillsController controller = Get.find<PayBillsController>();

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
        // Header with count and current month/year
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Records',
                    style: AppStyles.custom(
                      color: const Color(0xFF1A1A1A),
                      size: 20,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      '${controller.monthDisplayText} ${controller.selectedYear.value}',
                      style: AppStyles.custom(
                        color: Color(0xFF6B7280),
                        size: 14,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF4CAF50).withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '${controller.filteredPayBills.length}',
                      style: AppStyles.custom(
                        color: Color(0xFF4CAF50),
                        size: 16,
                        weight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Bills',
                      style: AppStyles.custom(
                        color: Color(0xFF4CAF50),
                        size: 10,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Search Bar with improved styling
        Container(
          decoration: BoxDecoration(
            color: AppTheme.backgroundLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.greyOpacity02),
            boxShadow: [
              BoxShadow(
                color: AppTheme.greyOpacity05,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller.searchController,
            onChanged: (value) {
              // Add debouncing for better performance
              Future.delayed(const Duration(milliseconds: 500), () {
                if (controller.searchController.text == value) {
                  controller.onSearchChanged(value);
                }
              });
            },
            decoration: InputDecoration(
              hintText: 'Search by company, person, or purpose...',
              hintStyle: AppStyles.custom(color: Color(0xFF9CA3AF), size: 14),
              prefixIcon: const Icon(
                Icons.search,
                color: Color(0xFF9CA3AF),
                size: 20,
              ),
              suffixIcon: Obx(() {
                if (controller.searchQuery.value.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Color(0xFF9CA3AF),
                      size: 20,
                    ),
                    onPressed: () {
                      controller.searchController.clear();
                      controller.onSearchChanged('');
                    },
                  );
                }
                return const SizedBox.shrink();
              }),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
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
            color: AppTheme.backgroundLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.greyOpacity02),
            boxShadow: [
              BoxShadow(
                color: AppTheme.greyOpacity05,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: AppTheme.transparent,
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
                    Icon(Icons.tune, color: const Color(0xFF3B82F6), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Filters',
                      style: AppStyles.custom(
                        color: Color(0xFF374151),
                        size: 14,
                        weight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Obx(() {
                      if (controller.hasActiveFilters) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Active',
                            style: AppStyles.custom(
                              color: AppTheme.backgroundLight,
                              size: 10,
                              weight: FontWeight.w600,
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
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.greyOpacity02),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.greyOpacity05,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF3B82F6).withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => buildStyledDropdown(
                                labelText: 'Month',
                                hintText: 'Select Month',
                                value: controller.monthDisplayText,
                                items: controller.months,
                                onChanged: (value) {
                                  if (value != null) {
                                    final monthIndex =
                                        controller.months.indexOf(value) + 1;
                                    controller.onMonthChanged(monthIndex);
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
                                hintText: 'Select Year',
                                value: controller.selectedYear.value.toString(),
                                items: List.generate(5, (index) {
                                  final year = DateTime.now().year - index;
                                  return year.toString();
                                }),
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
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => buildStyledDropdown(
                                labelText: 'Company',
                                hintText: 'All Companies',
                                value:
                                    controller.selectedCompany.value == 'All'
                                        ? null
                                        : controller.selectedCompany.value,
                                items:
                                    controller.companies
                                        .where((item) => item != 'All')
                                        .toList(),
                                onChanged:
                                    (value) => controller.onCompanyChanged(
                                      value ?? 'All',
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(
                              () => buildStyledDropdown(
                                labelText: 'Purpose',
                                hintText: 'All Purposes',
                                value:
                                    controller.selectedPurpose.value == 'All'
                                        ? null
                                        : controller.selectedPurpose.value,
                                items:
                                    controller.purposes
                                        .where((item) => item != 'All')
                                        .toList(),
                                onChanged:
                                    (value) => controller.onPurposeChanged(
                                      value ?? 'All',
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Second Row - Payment Mode
                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => buildStyledDropdown(
                                labelText: 'Payment Mode',
                                hintText: 'All Payment Modes',
                                value:
                                    controller.selectedPaymentMode.value ==
                                            'All'
                                        ? null
                                        : controller.selectedPaymentMode.value,
                                items:
                                    controller.paymentModes
                                        .where((item) => item != 'All')
                                        .toList(),
                                onChanged:
                                    (value) => controller.onPaymentModeChanged(
                                      value ?? 'All',
                                    ),
                              ),
                            ),
                          ),
                          const Expanded(
                            child: SizedBox(),
                          ), // Empty space for alignment
                        ],
                      ),
                    ],
                  ),
                ),

                // Clear Filters Button
                Obx(() {
                  if (controller.hasActiveFilters) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: controller.clearFilters,
                          icon: const Icon(Icons.clear_all, size: 18),
                          label: Text(
                            'Clear All Filters',
                            style: AppStyles.custom(
                              size: 14,
                              weight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF4444),
                            foregroundColor: AppTheme.backgroundLight,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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

        // Filter Summary with loading indicator
        Obx(() {
          return Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                if (controller.isLoading.value)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF3B82F6),
                      ),
                    ),
                  )
                else
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF3B82F6),
                    size: 16,
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    controller.getFilterSummary(),
                    style: AppStyles.custom(
                      color: Color(0xFF3B82F6),
                      size: 12,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
                if (controller.hasActiveFilters)
                  GestureDetector(
                    onTap: controller.clearFilters,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.clear,
                        color: Color(0xFF3B82F6),
                        size: 14,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),

        // Bills Grid
        // Replace your entire Expanded widget section with this:
        Flexible(
          child: Obx(() {
            if (controller.isLoading.value && controller.payBills.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                          constraints.maxHeight < 200 ? 16 : 24,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: constraints.maxHeight < 200 ? 20 : 24,
                              height: constraints.maxHeight < 200 ? 20 : 24,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(
                              height: constraints.maxHeight < 200 ? 12 : 16,
                            ),
                            Flexible(
                              child: Text(
                                'Loading payment bills...',
                                style: AppStyles.custom(
                                  color: const Color(0xFF6B7280),
                                  size: constraints.maxHeight < 200 ? 12 : 14,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            if (controller.filteredPayBills.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async => controller.refreshData(),
              child: GridView.builder(
                controller: controller.scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount:
                    controller.filteredPayBills.length +
                    (controller.hasMoreData.value && controller.isLoading.value
                        ? 1
                        : 0),
                itemBuilder: (context, index) {
                  if (index >= controller.filteredPayBills.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final bill = controller.filteredPayBills[index];
                  return _buildPayBillCard(bill);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPayBillCard(PayBill bill) {
    return GestureDetector(
      onTap: () => _showPayBillDetails(bill),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.greyOpacity01,
              blurRadius: 20,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
          border: Border.all(color: AppTheme.greyOpacity01, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with company and amount
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: controller.getCompanyColor(bill.company),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.business,
                    color: AppTheme.backgroundLight,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bill.company,
                        style: AppStyles.custom(
                          color: Color(0xFF1F2937),
                          size: 12,
                          weight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        bill.formattedAmount,
                        style: AppStyles.custom(
                          color: Color(0xFF059669),
                          size: 14,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                // Tap indicator
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Color(0xFF3B82F6),
                    size: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Purpose
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: controller
                    .getPurposeColor(bill.purpose)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                bill.purpose,
                style: AppStyles.custom(
                  color: controller.getPurposeColor(bill.purpose),
                  size: 10,
                  weight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),

            // Paid To Person
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  color: Color(0xFF6B7280),
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Paid to: ',
                  style: AppStyles.custom(
                    color: Color(0xFF9CA3AF),
                    size: 10,
                    weight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Text(
                    bill.paidToPerson,
                    style: AppStyles.custom(
                      color: Color(0xFF6B7280),
                      size: 10,
                      weight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Paid By
            Row(
              children: [
                const Icon(
                  Icons.account_circle_outlined,
                  color: Color(0xFF6B7280),
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Paid by: ',
                  style: AppStyles.custom(
                    color: Color(0xFF9CA3AF),
                    size: 10,
                    weight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Text(
                    bill.paidBy,
                    style: AppStyles.custom(
                      color: Color(0xFF6B7280),
                      size: 10,
                      weight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Date and Payment Mode Row
            Row(
              children: [
                // Date
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Color(0xFF6B7280),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          DateFormat('dd MMM').format(bill.formattedDate),
                          style: AppStyles.custom(
                            color: Color(0xFF6B7280),
                            size: 10,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Payment Mode
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.payment_outlined,
                        color: Color(0xFF6B7280),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          bill.paymentMode,
                          style: AppStyles.custom(
                            color: Color(0xFF6B7280),
                            size: 10,
                            weight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Description preview (if available)
            if (bill.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.notes_outlined,
                      color: Color(0xFF9CA3AF),
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        bill.description,
                        style: AppStyles.custom(
                          color: Color(0xFF6B7280),
                          size: 9,
                          weight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPayBillDetails(PayBill bill) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: AppTheme.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.backgroundDark.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: controller.getCompanyColor(bill.company),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.business,
                        color: AppTheme.backgroundLight,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Details',
                            style: AppStyles.custom(
                              color: Color(0xFF1F2937),
                              size: 18,
                              weight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Bill ID: #${bill.id}',
                            style: AppStyles.custom(
                              color: Color(0xFF6B7280),
                              size: 12,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFF6B7280),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Amount Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF059669).withOpacity(0.1),
                        const Color(0xFF10B981).withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF059669).withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Amount Paid',
                        style: AppStyles.custom(
                          color: Color(0xFF059669),
                          size: 14,
                          weight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        bill.formattedAmount,
                        style: AppStyles.custom(
                          color: Color(0xFF059669),
                          size: 32,
                          weight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Details Grid
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow('Company', bill.company, Icons.business),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Purpose',
                        bill.purpose,
                        Icons.category_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Paid To',
                        bill.paidToPerson,
                        Icons.person_outline,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Paid By',
                        bill.paidBy,
                        Icons.account_circle_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Payment Mode',
                        bill.paymentMode,
                        Icons.payment_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Date',
                        DateFormat('dd MMMM yyyy').format(bill.formattedDate),
                        Icons.calendar_today_outlined,
                      ),
                    ],
                  ),
                ),

                // Description Section
                if (bill.description.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.notes_outlined,
                              color: Color(0xFF6B7280),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Description',
                              style: AppStyles.custom(
                                color: Color(0xFF374151),
                                size: 14,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bill.description,
                          style: AppStyles.custom(
                            color: Color(0xFF6B7280),
                            size: 13,
                            weight: FontWeight.w400,
                            // height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // File Attachment
                if (bill.uploadedFileUrl.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final url = Uri.parse(bill.uploadedFileUrl);
                      if (bill.uploadedFileUrl.isNotEmpty) {
                        await launchUrl(url);
                      } else {
                        Get.snackbar(
                          'Error',
                          'Could not open file',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF3B82F6).withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.attach_file_outlined,
                              color: Color(0xFF3B82F6),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Attachment Available',
                                  style: AppStyles.custom(
                                    color: Color(0xFF3B82F6),
                                    size: 14,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Tap to view uploaded file',
                                  style: AppStyles.custom(
                                    color: Color(0xFF6B7280),
                                    size: 12,
                                    weight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.open_in_new,
                            color: Color(0xFF3B82F6),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Add share functionality
                        },
                        icon: const Icon(Icons.share_outlined, size: 18),
                        label: const Text('Share'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B7280),
                          foregroundColor: AppTheme.backgroundLight,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Add edit functionality
                        },
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: AppTheme.backgroundLight,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6B7280), size: 16),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: AppStyles.custom(
              color: Color(0xFF9CA3AF),
              size: 12,
              weight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: AppStyles.custom(
              color: Color(0xFF374151),
              size: 13,
              weight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Add this
            children: [
              Container(
                width: 100, // Reduced from 120
                height: 100, // Reduced from 120
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50), // Adjusted
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  size: 50, // Reduced from 60
                  color: Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(height: 20), // Reduced from 24
              Text(
                controller.hasActiveFilters
                    ? 'No Bills Found'
                    : 'No Payment Bills Available',
                style: AppStyles.custom(
                  color: Color(0xFF1F2937),
                  size: 18, // Reduced from 20
                  weight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Flexible(
                // Wrap in Flexible
                child: Text(
                  controller.hasActiveFilters
                      ? 'Try adjusting your search criteria or filters to find what you\'re looking for.'
                      : 'Payment bills will appear here once they are added to the system.',
                  style: AppStyles.custom(
                    color: Color(0xFF6B7280),
                    size: 14,
                    weight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3, // Add max lines
                  overflow: TextOverflow.ellipsis, // Add overflow handling
                ),
              ),
              const SizedBox(height: 20), // Reduced from 24
              if (controller.hasActiveFilters)
                ElevatedButton.icon(
                  onPressed: controller.clearFilters,
                  icon: const Icon(Icons.clear_all, size: 18),
                  label: Text(
                    'Clear Filters',
                    style: AppStyles.custom(size: 14, weight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: AppTheme.backgroundLight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
