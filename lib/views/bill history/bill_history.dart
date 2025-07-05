import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/bill%20history%20controllers/bill_history_controller.dart';
import 'package:smartbecho/models/bill%20history/bill_history_model.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/utils/custom_appbar.dart';

class BillsHistoryPage extends GetView<BillHistoryController> {
  const BillsHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            buildCustomAppBar("Bills Management", isdark: true),
            // Show loading indicator when initially loading
            Obx(
              () => controller.isLoading.value && controller.bills.isEmpty
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.grey[200],
                      color: Color(0xFF1E293B),
                    )
                  : SizedBox(),
            ),
            _buildCompactSearchAndFilters(),
            NotificationListener(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent &&
                    !controller.isLoadingMore.value &&
                    !controller.isLoading.value) {
                  controller.loadMoreBills();
                }
                return false;
              },
              child: Expanded(
                child: CustomScrollView(
                  slivers: [
                    // Stats as a sliver that can scroll with content
                    SliverToBoxAdapter(child: _buildCompactStatsRow()),
                    // Bill cards in grid
                    _buildBillCardsSlivers(),
                  ],
                ),
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

  Widget _buildCompactSearchAndFilters() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.search, color: Color(0xFF1E293B), size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(2),
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: (value) => controller.onSearchChanged(),
                    decoration: InputDecoration(
                      hintText: 'Search bills by company, ID...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                      suffixIcon: Obx(
                        () => controller.searchQuery.value.isNotEmpty
                            ? IconButton(
                                onPressed: controller.clearSearch,
                                icon: Icon(
                                  Icons.clear,
                                  size: 16,
                                  color: Colors.grey[400],
                                ),
                              )
                            : SizedBox(),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                onPressed: () => _showExportDialog(Get.context!),
                icon: Icon(Icons.file_download, size: 18, color: Color(0xFF1E293B)),
                tooltip: 'Export',
              ),
              IconButton(
                onPressed: () => controller.refreshBills(),
                icon: Icon(Icons.refresh, size: 18, color: Color(0xFF1E293B)),
                tooltip: 'Refresh',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatsRow() {
    return Container(
      height: 60,
      margin: EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Obx(
        () => Row(
          children: [
            _buildCompactStatItem(
              'Total Bills',
              controller.totalElements.value.toString(),
              Icons.receipt_long,
              Color(0xFF1E293B),
            ),
            _buildCompactStatItem(
              'Loaded',
              controller.bills.length.toString(),
              Icons.download_done,
              Color(0xFF10B981),
            ),
            _buildCompactStatItem(
              'Paid',
              controller.bills.where((bill) => bill.paid).length.toString(),
              Icons.check_circle,
              Color(0xFF10B981),
            ),
            _buildCompactStatItem(
              'Pending',
              controller.bills.where((bill) => !bill.paid).length.toString(),
              Icons.pending,
              Color(0xFFF59E0B),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactStatItem(String label, String count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 6),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 6,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 12),
                SizedBox(width: 4),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillCardsSlivers() {
    return Obx(() {
      if (controller.error.value.isNotEmpty && controller.bills.isEmpty) {
        return SliverFillRemaining(child: _buildErrorState());
      }

      if (controller.isLoading.value && controller.bills.isEmpty) {
        return SliverFillRemaining(child: _buildLoadingState());
      }

      if (controller.bills.isEmpty) {
        return SliverFillRemaining(child: _buildEmptyState());
      }

      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75, // Adjust this to control card height
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == controller.bills.length) {
                return controller.isLoadingMore.value
                    ? Container(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF1E293B),
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : SizedBox.shrink();
              }

              final bill = controller.bills[index];
              return _buildCompactBillCard(bill);
            },
            childCount: controller.bills.length + (controller.isLoadingMore.value ? 1 : 0),
          ),
        ),
      );
    });
  }

  Widget _buildCompactBillCard(Bill bill) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: 10,
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
          // Top section with bill ID and status badge
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      controller.getCompanyColor(bill.companyName),
                      controller.getCompanyColor(bill.companyName).withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              Spacer(),
              _buildCompactStatusBadge(bill),
            ],
          ),

          SizedBox(height: 12),

          // Bill ID
          Text(
            '#${bill.billId}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 6),

          // Company name
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: controller.getCompanyColor(bill.companyName),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  bill.companyName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 4),

          // Date
          Row(
            children: [
              Icon(Icons.calendar_today, size: 10, color: Colors.grey[500]),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  bill.formattedDate,
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          Spacer(),

          // Amount and dues section
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Amount row
                Row(
                  children: [
                    Icon(
                      Icons.currency_rupee,
                      size: 10,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Amount',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      bill.formattedAmount,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),

                if (bill.dues > 0) ...[
                  SizedBox(height: 4),
                  // Dues row
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        size: 10,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Dues',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Text(
                        bill.formattedDues,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: 4),

                // Items count
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2,
                      size: 10,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Items',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${bill.totalItems}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () => controller.navigateToBillDetails(bill),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E293B).withOpacity(0.1),
                      foregroundColor: Color(0xFF1E293B),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(Icons.visibility, size: 12),
                  ),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () => _editBill(bill),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF10B981).withOpacity(0.1),
                      foregroundColor: Color(0xFF10B981),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(Icons.edit, size: 12),
                  ),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () => _shareBill(bill),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3B82F6).withOpacity(0.1),
                      foregroundColor: Color(0xFF3B82F6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(Icons.share, size: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatusBadge(Bill bill) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: controller.getStatusColor(bill).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: controller.getStatusColor(bill).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            controller.getStatusIcon(bill),
            size: 8,
            color: controller.getStatusColor(bill),
          ),
          SizedBox(width: 2),
          Text(
            bill.paid ? 'Paid' : 'Pending',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: controller.getStatusColor(bill),
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
          CircularProgressIndicator(color: Color(0xFF1E293B)),
          SizedBox(height: 16),
          Text(
            'Loading bills...',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          SizedBox(height: 16),
          Text(
            'Error loading bills',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red[600],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Obx(() => Text(
              controller.error.value,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            )),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.loadBills(refresh: true),
            child: Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E293B),
              foregroundColor: Colors.white,
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
          Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            controller.searchQuery.value.isNotEmpty 
                ? 'No bills found for "${controller.searchQuery.value}"'
                : 'No bills found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            controller.searchQuery.value.isNotEmpty
                ? 'Try searching with different keywords'
                : 'Bills will appear here once you create them',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          if (controller.searchQuery.value.isNotEmpty) ...[
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.clearSearch,
              child: Text('Clear Search'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E293B),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Export Bills',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose export format:'),
            const SizedBox(height: 16),
            Obx(() => Text(
              '${controller.bills.length} bills will be exported',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _exportToPDF();
            },
            icon: const Icon(Icons.picture_as_pdf, size: 16),
            label: const Text('PDF'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _exportToExcel();
            },
            icon: const Icon(Icons.table_chart, size: 16),
            label: const Text('Excel'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  void _exportToPDF() {
    Get.snackbar(
      'Export',
      'PDF export feature coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
    );
  }

  void _exportToExcel() {
    Get.snackbar(
      'Export',
      'Excel export feature coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.table_chart, color: Colors.white),
    );
  }

  void _editBill(Bill bill) {
    Get.toNamed('/edit-bill', arguments: bill);
  }

  void _shareBill(Bill bill) {
    Get.snackbar(
      'Share',
      'Sharing Bill #${bill.billId}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      icon: const Icon(Icons.share, color: Colors.white),
    );
  }
}