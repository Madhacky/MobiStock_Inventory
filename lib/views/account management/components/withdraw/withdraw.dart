import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/account%20management%20controller/withdraw_history_controller.dart';
import 'package:smartbecho/models/account%20management%20models/withdraw_history_model.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:intl/intl.dart';
import 'package:smartbecho/utils/custom_dropdown.dart';
import 'package:smartbecho/views/account%20management/components/withdraw/add_withdraw.dart';

class WithdrawHistoryPage extends StatefulWidget {
  @override
  _WithdrawHistoryPageState createState() => _WithdrawHistoryPageState();
}

class _WithdrawHistoryPageState extends State<WithdrawHistoryPage>
    with TickerProviderStateMixin {
  final WithdrawController controller = Get.find<WithdrawController>();

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
                'Withdraw History',
                style: AppStyles.custom(
                  color: const Color(0xFF1A1A1A),
                  size: 20,
                  weight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () {
                  Get.to(() => AddWithdrawPage());
                },
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:const Color(0xFFFF9500),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withOpacity(0.3),
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
                        'Add Withdraw',
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
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${controller.filteredWithdrawals.length} Withdrawals',
                  style: const TextStyle(
                    color: Color(0xFFEF4444),
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
            color: Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: TextField(
            controller: controller.searchController,
            onChanged: controller.onSearchChanged,
            decoration: const InputDecoration(
              hintText: 'Search withdrawals...',
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
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
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
                            color: const Color(0xFF3B82F6).withOpacity(0.1),
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
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Row - Withdrawn By and Purpose
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => buildStyledDropdown(
                          labelText: 'Withdrawn By',
                          hintText: 'Select Person',
                          value:
                              controller.selectedWithdrawnBy.value == 'All'
                                  ? null
                                  : controller.selectedWithdrawnBy.value,
                          items:
                              controller.withdrawnByOptions
                                  .where((item) => item != 'All')
                                  .toList(),
                          onChanged:
                              (value) => controller.onWithdrawnByChanged(
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
                          hintText: 'Select Purpose',
                          value:
                              controller.selectedPurpose.value == 'All'
                                  ? null
                                  : controller.selectedPurpose.value,
                          items:
                              controller.purposes
                                  .where((item) => item != 'All')
                                  .toList(),
                          onChanged:
                              (value) =>
                                  controller.onPurposeChanged(value ?? 'All'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Second Row - Payment Mode and Date
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => buildStyledDropdown(
                          labelText: 'Payment Mode',
                          hintText: 'Select Payment',
                          value:
                              controller.selectedPaymentMode.value == 'All'
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => buildStyledDropdown(
                                labelText: 'Month',
                                hintText: 'Month',
                                value:
                                    controller.selectedMonth.value.toString(),
                                items: List.generate(
                                  12,
                                  (index) => (index + 1).toString(),
                                ),
                                onChanged:
                                    (value) => controller.onMonthChanged(
                                      int.parse(value ?? '1'),
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
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
                                onChanged:
                                    (value) => controller.onYearChanged(
                                      int.parse(
                                        value ?? DateTime.now().year.toString(),
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ],
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
                color: const Color(0xFF3B82F6).withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
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

        // Withdrawals Grid
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.withdrawals.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.filteredWithdrawals.isEmpty) {
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
                    controller.filteredWithdrawals.length +
                    (controller.hasMoreData.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= controller.filteredWithdrawals.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final withdrawal = controller.filteredWithdrawals[index];
                  return _buildWithdrawCard(withdrawal);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildWithdrawCard(Withdraw withdrawal) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with person and amount
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: controller.getWithdrawnByColor(withdrawal.withdrawnBy),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      withdrawal.withdrawnBy,
                      style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      withdrawal.formattedAmount,
                      style: const TextStyle(
                        color: Color(0xFFEF4444),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Purpose with icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: controller
                      .getPurposeColor(withdrawal.purpose)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getPurposeIcon(withdrawal.purpose),
                      size: 12,
                      color: controller.getPurposeColor(withdrawal.purpose),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      withdrawal.purpose,
                      style: TextStyle(
                        color: controller.getPurposeColor(withdrawal.purpose),
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

          // Payment mode
          Row(
            children: [
              Icon(
                _getPaymentModeIcon(withdrawal.paymentMode),
                size: 14,
                color: controller.getPaymentModeColor(withdrawal.paymentMode),
              ),
              const SizedBox(width: 6),
              Text(
                withdrawal.paymentMode,
                style: TextStyle(
                  color: controller.getPaymentModeColor(withdrawal.paymentMode),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

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
                withdrawal.formattedDate.toString(),
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Notes (if available)
          if (withdrawal.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                withdrawal.notes,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],

          const Spacer(),

          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showWithdrawDetails(withdrawal),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              size: 60,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            controller.hasActiveFilters
                ? 'No withdrawals found'
                : 'No withdrawals yet',
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
                : 'Withdrawals will appear here once they are recorded',
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
    );
  }

  void _showWithdrawDetails(Withdraw withdrawal) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
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
                          color: controller.getWithdrawnByColor(
                            withdrawal.withdrawnBy,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.person,
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
                              'Withdrawal Details',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            Text(
                              withdrawal.formattedDate.toString(),
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
                          backgroundColor: Colors.grey.withOpacity(0.1),
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
                      color: const Color(0xFFEF4444).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Amount Withdrawn',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          withdrawal.formattedAmount,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Details
                  _buildDetailRow(
                    'Withdrawn By',
                    withdrawal.withdrawnBy,
                    Icons.person,
                  ),
                  _buildDetailRow(
                    'Purpose',
                    withdrawal.purpose,
                    _getPurposeIcon(withdrawal.purpose),
                  ),
                  _buildDetailRow(
                    'Payment Mode',
                    withdrawal.paymentMode,
                    _getPaymentModeIcon(withdrawal.paymentMode),
                  ),
                  _buildDetailRow(
                    'Date',
                    withdrawal.formattedDate.toString(),
                    Icons.calendar_today,
                  ),

                  if (withdrawal.notes.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Notes',
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
                        color: Colors.grey.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        withdrawal.notes,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
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

  IconData _getPurposeIcon(String purpose) {
    switch (purpose.toLowerCase()) {
      case 'salary':
        return Icons.work;
      case 'petty cash':
        return Icons.money;
      case 'vendor payment':
        return Icons.business;
      case 'personal use':
        return Icons.person;
      case 'office expenses':
        return Icons.business_outlined;
      case 'maintenance':
        return Icons.build;
      case 'utilities':
        return Icons.electrical_services;
      default:
        return Icons.category;
    }
  }

  IconData _getPaymentModeIcon(String paymentMode) {
    switch (paymentMode.toLowerCase()) {
      case 'cash':
        return Icons.money;
      case 'account':
        return Icons.account_balance;
      case 'card':
        return Icons.credit_card;
      case 'upi':
        return Icons.qr_code;
      case 'cheque':
        return Icons.receipt;
      default:
        return Icons.payment;
    }
  }
}
