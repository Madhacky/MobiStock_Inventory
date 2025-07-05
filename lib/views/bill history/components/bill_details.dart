import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/bill%20history/bill_history_model.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/utils/custom_appbar.dart';

class BillDetailsPage extends StatelessWidget {
  const BillDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Bill bill = Get.arguments as Bill;

    return Scaffold(
      backgroundColor: AppTheme.grey50,
      body: SafeArea(
        child: Column(
          children: [
            buildCustomAppBar("Bill Details", isdark: true),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBillHeader(bill),
                    SizedBox(height: 16),
                    _buildBillSummary(bill),
                    SizedBox(height: 16),
                    _buildItemsSection(bill),
                    SizedBox(height: 16),
                    _buildAmountBreakdown(bill),
                    SizedBox(height: 80), // Space for floating action buttons
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButtons(bill),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBillHeader(Bill bill) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E293B).withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: AppTheme.backgroundLight,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bill #${bill.billId}',
                      style: AppStyles.custom(
                        size: 24,
                        weight: FontWeight.bold,
                        color: AppTheme.backgroundLight,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      bill.companyName,
                      style: AppStyles.custom(
                        size: 16,
                        color: AppTheme.backgroundLight.withOpacity(0.8),
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(bill),
            ],
          ),
          SizedBox(height: 16),
          Divider(color: AppTheme.backgroundLight.withOpacity(0.2)),
          SizedBox(height: 16),
          Row(
            children: [
              _buildHeaderInfo(
                'Date',
                bill.formattedDate,
                Icons.calendar_today,
              ),
              SizedBox(width: 24),
              _buildHeaderInfo(
                'Items',
                '${bill.totalItems}',
                Icons.inventory_2,
              ),
              Spacer(),
              _buildHeaderInfo(
                'Amount',
                bill.formattedAmount,
                Icons.currency_rupee,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.backgroundLight.withOpacity(0.8), size: 16),
        SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppStyles.custom(
                size: 12,
                color: AppTheme.backgroundLight.withOpacity(0.7),
                weight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: AppStyles.custom(
                size: 14,
                color: AppTheme.backgroundLight,
                weight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(Bill bill) {
    Color statusColor = bill.paid ? Color(0xFF10B981) : Color(0xFFF59E0B);
    IconData statusIcon = bill.paid ? Icons.check_circle : Icons.pending;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          SizedBox(width: 6),
          Text(
            bill.status,
            style: AppStyles.custom(
              size: 12,
              weight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillSummary(Bill bill) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity08,
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bill Summary',
            style: AppStyles.custom(
              size: 18,
              weight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildSummaryCard(
                'Total Items',
                '${bill.totalItems}',
                Icons.inventory_2,
                Color(0xFF3B82F6),
              ),
              SizedBox(width: 12),
              _buildSummaryCard(
                'Unique Products',
                '${bill.items.length}',
                Icons.widgets,
                Color(0xFF8B5CF6),
              ),
            ],
          ),
          if (bill.dues > 0) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFEF4444).withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFEF4444),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Outstanding Dues: ${bill.formattedDues}',
                    style: AppStyles.custom(
                      size: 14,
                      weight: FontWeight.w600,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            Text(
              value,
              style: AppStyles.custom(
                size: 18,
                weight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: AppStyles.custom(
                size: 12,
                color: AppTheme.grey600,
                weight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSection(Bill bill) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity08,
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Items (${bill.items.length})',
                  style: AppStyles.custom(
                    size: 18,
                    weight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF1E293B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Total Qty: ${bill.totalItems}',
                    style: AppStyles.custom(
                      size: 12,
                      weight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: bill.items.length,
            separatorBuilder:
                (context, index) => Divider(height: 1, color: AppTheme.grey200),
            itemBuilder: (context, index) {
              final item = bill.items[index];
              return _buildItemCard(item, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(BillItem item, int index) {
    Color companyColor = _getCompanyColor(item.company);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Company logo/avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [companyColor, companyColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                item.company.isNotEmpty ? item.company[0].toUpperCase() : 'M',
                style: AppStyles.custom(
                  size: 18,
                  weight: FontWeight.bold,
                  color: AppTheme.backgroundLight,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),

          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.model,
                  style: AppStyles.custom(
                    size: 16,
                    weight: FontWeight.bold,
                    color: AppTheme.black87,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      item.company,
                      style: AppStyles.custom(
                        size: 14,
                        weight: FontWeight.w600,
                        color: companyColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.grey100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.ramRomDisplay,
                        style: AppStyles.custom(
                          size: 10,
                          weight: FontWeight.w500,
                          color: AppTheme.grey600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.palette, size: 12, color: AppTheme.grey500),
                    SizedBox(width: 4),
                    Text(
                      item.color,
                      style: AppStyles.custom(
                        size: 12,
                        color: AppTheme.grey600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Quantity and price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Qty: ${item.qty}',
                  style: AppStyles.custom(
                    size: 12,
                    weight: FontWeight.bold,
                    color: Color(0xFF10B981),
                  ),
                ),
              ),
              SizedBox(height: 4),
              Text(
                item.formattedPrice,
                style: AppStyles.custom(
                  size: 16,
                  weight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                'per unit',
                style: AppStyles.custom(size: 10, color: AppTheme.grey500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountBreakdown(Bill bill) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity08,
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amount Breakdown',
            style: AppStyles.custom(
              size: 18,
              weight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 16),
          _buildAmountRow(
            'Subtotal (Without GST)',
            '₹${bill.withoutGst.toStringAsFixed(0)}',
            false,
          ),
          SizedBox(height: 8),
          _buildAmountRow('GST', bill.formattedGst, false),
          SizedBox(height: 8),
          Divider(),
          SizedBox(height: 8),
          _buildAmountRow('Total Amount', bill.formattedAmount, true),
          if (bill.dues > 0) ...[
            SizedBox(height: 8),
            _buildAmountRow(
              'Paid Amount',
              '₹${(bill.amount - bill.dues).toStringAsFixed(0)}',
              false,
              AppTheme.primaryGreen,
            ),
            SizedBox(height: 8),
            _buildAmountRow(
              'Outstanding Dues',
              bill.formattedDues,
              false,
              AppTheme.primaryRed,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAmountRow(
    String label,
    String amount,
    bool isTotal, [
    Color? color,
  ]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.custom(
            size: isTotal ? 16 : 14,
            weight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: color ?? (isTotal ? Color(0xFF1E293B) : AppTheme.grey700),
          ),
        ),
        Text(
          amount,
          style: AppStyles.custom(
            size: isTotal ? 18 : 14,
            weight: FontWeight.bold,
            color: color ?? (isTotal ? Color(0xFF1E293B) : AppTheme.grey800),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButtons(Bill bill) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton.extended(
          onPressed: () => _editBill(bill),
          backgroundColor: Color(0xFF10B981),
          foregroundColor: AppTheme.backgroundLight,
          icon: Icon(Icons.edit),
          label: Text('Edit'),
          heroTag: "edit",
        ),
        FloatingActionButton.extended(
          onPressed: () => _shareBill(bill),
          backgroundColor: Color(0xFF3B82F6),
          foregroundColor: AppTheme.backgroundLight,
          icon: Icon(Icons.share),
          label: Text('Share'),
          heroTag: "share",
        ),
        FloatingActionButton.extended(
          onPressed: () => _downloadBill(bill),
          backgroundColor: Color(0xFF8B5CF6),
          foregroundColor: AppTheme.backgroundLight,
          icon: Icon(Icons.download),
          label: Text('Download'),
          heroTag: "download",
        ),
      ],
    );
  }

  Color _getCompanyColor(String company) {
    final colors = [
      Color(0xFF3B82F6), // Blue
      Color(0xFF10B981), // Green
      Color(0xFFF59E0B), // Yellow
      Color(0xFFEF4444), // Red
      Color(0xFF8B5CF6), // Purple
      Color(0xFF06B6D4), // Cyan
      Color(0xFFEC4899), // Pink
      Color(0xFF84CC16), // Lime
    ];

    int hash = company.hashCode;
    return colors[hash.abs() % colors.length];
  }

  void _editBill(Bill bill) {
    Get.toNamed('/edit-bill', arguments: bill);
  }

  void _shareBill(Bill bill) {
    Get.snackbar(
      'Share',
      'Sharing Bill #${bill.billId}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.primaryBlue,
      colorText: AppTheme.backgroundLight,
      icon: const Icon(Icons.share, color: AppTheme.backgroundLight),
    );
  }

  void _downloadBill(Bill bill) {
    Get.snackbar(
      'Download',
      'Downloading Bill #${bill.billId}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF8B5CF6),
      colorText: AppTheme.backgroundLight,
      icon: const Icon(Icons.download, color: AppTheme.backgroundLight),
    );
  }
}
