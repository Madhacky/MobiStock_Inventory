import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/bill%20history%20controllers/bill_history_controller.dart';
import 'package:smartbecho/models/bill%20history/bill_history_model.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:smartbecho/utils/number_formatter.dart';

class BillsHistoryPage extends GetView<BillHistoryController> {
  const BillsHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            buildCustomAppBar("Purchase Bills", isdark: true),
            
            // Loading indicator
            Obx(
              () => controller.isLoading.value && controller.bills.isEmpty
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.grey[200],
                      color: Color(0xFF1E293B),
                    )
                  : SizedBox.shrink(),
            ),
            
            // Search and filters
            _buildSearchAndFilters(),
            
            // Stats summary
            _buildStatsSection(),
            
            // Bills grid with lazy loading
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 200 &&
                      !controller.isLoadingMore.value &&
                      !controller.isLoading.value) {
                    controller.loadMoreBills();
                  }
                  return false;
                },
                child: _buildBillsGrid(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addNewStock),
        backgroundColor: Color(0xFF1E293B),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: TextField(
              controller: controller.searchController,
              onChanged: (value) => controller.onSearchChanged(),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
                hintText: 'Search bills by company, ID, or model...',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                suffixIcon: Obx(
                  () => controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          onPressed: controller.clearSearch,
                          icon: Icon(Icons.clear, size: 20, color: Colors.grey[400]),
                        )
                      : SizedBox.shrink(),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          
          SizedBox(height: 12),
          
          // Filter chips
          Row(
            children: [
              // Expanded(
              //   child: Obx(
              //     () => _buildFilterChip(
              //       'Company',
              //       controller.selectedCompany.value == '' ? 'All' : controller.selectedCompany.value,
              //       () => _showCompanyFilter(),
              //     ),
              //   ),
              // ),
              // SizedBox(width: 8),
              Expanded(
                child: Obx(
                  () => _buildFilterChip(
                    'Status',
                    controller.selectedStatus.value,
                    () => _showStatusFilter(),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Obx(
                  () => _buildFilterChip(
                    'Sort',
                    '${controller.sortBy.value} ${controller.sortDir.value == 'asc' ? '↑' : '↓'}',
                    () => _showSortOptions(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xFF1E293B).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFF1E293B).withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 14,
                  color: Color(0xFF1E293B),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Bills',
                controller.totalElements.value.toString(),
                Icons.receipt_long,
                Color(0xFF1E293B),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildStatCard(
                'Total Amount',
                '₹${numberformatterCompact(controller.totalAmount.value)}',
                Icons.currency_rupee,
                Color(0xFF10B981),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildStatCard(
                'Total Qty',
                controller.totalQty.value.toString(),
                Icons.inventory,
                Color(0xFF3B82F6),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildStatCard(
                'Loaded',
                controller.bills.length.toString(),
                Icons.download_done,
                Color(0xFFF59E0B),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillsGrid() {
    return Obx(() {
      if (controller.error.value.isNotEmpty && controller.bills.isEmpty) {
        return _buildErrorState();
      }

      if (controller.isLoading.value && controller.bills.isEmpty) {
        return _buildLoadingState();
      }

      if (controller.bills.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: controller.refreshBills,
        color: Color(0xFF1E293B),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount: controller.bills.length + (controller.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.bills.length) {
                return _buildLoadingMoreIndicator();
              }

              final bill = controller.bills[index];
              return _buildBillCard(bill);
            },
          ),
        ),
      );
    });
  }

  Widget _buildBillCard(Bill bill) {
    return GestureDetector(
      onTap: () => controller.navigateToBillDetails(bill),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: controller.getStatusColor(bill).withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with company and status
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    controller.getCompanyColor(bill.companyName).withOpacity(0.1),
                    controller.getCompanyColor(bill.companyName).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: controller.getCompanyColor(bill.companyName),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      controller.getCompanyIcon(bill.companyName),
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bill.companyName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: controller.getCompanyColor(bill.companyName),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '#${bill.billId}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(bill),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
                        SizedBox(width: 4),
                        Text(
                          bill.formattedDate,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    // Items preview
                    if (bill.items.isNotEmpty) ...[
                      Text(
                        'Items (${bill.totalItems})',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      ...bill.items.take(2).map((item) => Padding(
                        padding: EdgeInsets.only(bottom: 2),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: controller.getCompanyColor(item.company),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${item.model} (${item.ramRomDisplay})',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[700],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                      if (bill.items.length > 2)
                        Text(
                          '+${bill.items.length - 2} more',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],

                    Spacer(),

                    // Amount section
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.currency_rupee, size: 12, color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text(
                                'Amount',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Spacer(),
                              Text(
                                bill.formattedAmount,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                          if (bill.dues > 0) ...[
                            SizedBox(height: 4),
                            Row(
                              children: [ // Continuation of _buildBillCard method from the dues section
                                Icon(Icons.warning, size: 10, color: Colors.orange),
                                SizedBox(width: 4),
                                Text(
                                  'Dues',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '₹${bill.dues.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(Bill bill) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: controller.getStatusColor(bill),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            controller.getStatusIcon(bill),
            size: 8,
            color: Colors.white,
          ),
          SizedBox(width: 2),
          Text(
            bill.paid ? 'Paid' : 'Pending',
            style: TextStyle(
              fontSize: 8,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFF1E293B),
            strokeWidth: 2,
          ),
          SizedBox(height: 16),
          Text(
            'Loading bills...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
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
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'No bills found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => controller.loadBills(refresh: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E293B),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Obx(
              () => Text(
                controller.error.value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => controller.loadBills(refresh: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E293B),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Color(0xFF1E293B),
                strokeWidth: 2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Loading more...',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCompanyFilter() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter by Company',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 16),
            Obx(
              () => Column(
                children: controller.companyOptions.map((company) {
                  return ListTile(
                    title: Text(company),
                    leading: Radio<String>(
                      value: company,
                      groupValue: controller.selectedCompany.value == '' ? 'All' : controller.selectedCompany.value,
                      onChanged: (value) {
                        controller.onCompanyFilterChanged(value);
                        Get.back();
                      },
                      activeColor: Color(0xFF1E293B),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusFilter() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter by Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: controller.statusOptions.map((status) {
                return ListTile(
                  title: Text(status),
                  leading: Radio<String>(
                    value: status,
                    groupValue: controller.selectedStatus.value,
                    onChanged: (value) {
                      controller.onStatusFilterChanged(value);
                      Get.back();
                    },
                    activeColor: Color(0xFF1E293B),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOptions() {
    final sortOptions = [
      {'value': 'billId', 'label': 'Bill ID'},
      {'value': 'date', 'label': 'Date'},
      {'value': 'amount', 'label': 'Amount'},
      {'value': 'companyName', 'label': 'Company'},
    ];

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort by',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: sortOptions.map((option) {
                return Obx(
                  () => ListTile(
                    title: Text(option['label']!),
                    leading: Radio<String>(
                      value: option['value']!,
                      groupValue: controller.sortBy.value,
                      onChanged: (value) {
                        controller.onSortChanged(value!);
                        Get.back();
                      },
                      activeColor: Color(0xFF1E293B),
                    ),
                    trailing: controller.sortBy.value == option['value']
                        ? Icon(
                            controller.sortDir.value == 'asc' 
                                ? Icons.arrow_upward 
                                : Icons.arrow_downward,
                            size: 16,
                            color: Color(0xFF1E293B),
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}