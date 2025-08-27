import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/bill%20history/bill_history_model.dart';
import 'package:smartbecho/utils/custom_appbar.dart';

class BillDetailsPage extends StatelessWidget {
  const BillDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Bill bill = Get.arguments as Bill;

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                    // _buildBillSummary(bill),
                    // SizedBox(height: 16),
                    _buildItemsSection(bill),
                    SizedBox(height: 16),
                    _buildAmountBreakdown(bill),
                    SizedBox(height: 16),
                    _buildPaymentStatus(bill),
                    SizedBox(height: 100), // Space for floating action buttons
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
          colors: [
            Color(0xFF1E293B),
            Color(0xFF334155),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E293B).withValues(alpha:0.3),
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
                  color: Colors.white.withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _copyToClipboard(bill.billId.toString(), 'Bill ID'),
                      child: Row(
                        children: [
                          Text(
                            'Bill #${bill.billId}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.copy,
                            color: Colors.white.withValues(alpha:0.7),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      bill.companyName,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha:0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(bill),
            ],
          ),
          SizedBox(height: 16),
          Divider(color: Colors.white.withValues(alpha:0.2)),
          SizedBox(height: 16),
          Row(
            children: [
              _buildHeaderInfo('Date', bill.formattedDate, Icons.calendar_today),
              SizedBox(width: 24),
              _buildHeaderInfo('Items', '${bill.totalItems}', Icons.inventory_2),
              Spacer(),
              _buildHeaderInfo('Amount', bill.formattedAmount, Icons.currency_rupee),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha:0.8), size: 16),
        SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha:0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha:0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          SizedBox(width: 6),
          Text(
            bill.status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

Widget _buildBillSummary(Bill bill) {
    // Calculate SGST and CGST (half of total GST each)
    double totalGstPercent = bill.gst;
    double sgstPercent = totalGstPercent / 2;
    double cgstPercent = totalGstPercent / 2;
    
    // Calculate GST amounts
    double gstAmount = bill.amount - bill.withoutGst;
    double sgstAmount = gstAmount / 2;
    double cgstAmount = gstAmount / 2;
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Bill Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF1E293B).withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'ID: ${bill.billId}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          // GST Breakdown Row 1
          Row(
            children: [
              _buildGstSummaryCard(
                'GST Rate',
                '${totalGstPercent.toStringAsFixed(1)}%',
                Icons.percent,
                Color(0xFF3B82F6),
              ),
              SizedBox(width: 12),
              _buildGstSummaryCard(
                'Without GST',
                '₹${bill.withoutGst.toStringAsFixed(0)}',
                Icons.remove_circle_outline,
                Color(0xFF10B981),
              ),
            ],
          ),
          SizedBox(height: 12),
          
          // GST Breakdown Row 2
          Row(
            children: [
              _buildGstSummaryCard(
                'SGST',
                '${sgstPercent.toStringAsFixed(1)}% (₹${sgstAmount.toStringAsFixed(0)})',
                Icons.account_balance,
                Color(0xFFF59E0B),
              ),
              SizedBox(width: 12),
              _buildGstSummaryCard(
                'CGST',
                '${cgstPercent.toStringAsFixed(1)}% (₹${cgstAmount.toStringAsFixed(0)})',
                Icons.business,
                Color(0xFF8B5CF6),
              ),
            ],
          ),
          SizedBox(height: 12),
          
          // Total Amount Card
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1E293B),
                  Color(0xFF334155),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF1E293B).withValues(alpha:0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.currency_rupee,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount (With GST)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha:0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        bill.formattedAmount,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'GST: ₹${gstAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGstSummaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha:0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF1E293B).withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Total Qty: ${bill.totalItems}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey[200],
            ),
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
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.transparent : Colors.grey[50],
      ),
      child: Row(
        children: [
          // Company logo/avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [companyColor, companyColor.withValues(alpha:0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                item.company.isNotEmpty ? item.company[0].toUpperCase() : 'M',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      item.company,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: companyColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.ramRomDisplay,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.palette, size: 12, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      item.color,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
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
                  color: Color(0xFF10B981).withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Qty: ${item.qty}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10B981),
                  ),
                ),
              ),
              SizedBox(height: 4),
              Text(
                item.formattedPrice,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                'per unit',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountBreakdown(Bill bill) {
    // Calculate SGST and CGST (half of total GST each)
    double gstAmount = bill.amount - bill.withoutGst;
    double sgstAmount = gstAmount / 2;
    double cgstAmount = gstAmount / 2;
    double totalGstPercent = bill.gst;
    double sgstPercent = totalGstPercent / 2;
    double cgstPercent = totalGstPercent / 2;
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 16),
          _buildAmountRow('Subtotal (Without GST)', '₹${bill.withoutGst.toStringAsFixed(0)}', false),
          SizedBox(height: 8),
          _buildAmountRow('SGST (${sgstPercent.toStringAsFixed(1)}%)', '₹${sgstAmount.toStringAsFixed(0)}', false, Color(0xFFF59E0B)),
          SizedBox(height: 8),
          _buildAmountRow('CGST (${cgstPercent.toStringAsFixed(1)}%)', '₹${cgstAmount.toStringAsFixed(0)}', false, Color(0xFF8B5CF6)),
          SizedBox(height: 8),
          Divider(thickness: 2),
          SizedBox(height: 8),
          _buildAmountRow('Total Amount', bill.formattedAmount, true),
          if (bill.dues > 0) ...[
            // SizedBox(height: 8),
            // _buildAmountRow('Paid Amount', '₹${(bill.amount - bill.dues).toStringAsFixed(0)}', false, Colors.green),
            // SizedBox(height: 8),
            // _buildAmountRow('Outstanding Dues', bill.formattedDues, false, Colors.red),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentStatus(Bill bill) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
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
            'Payment Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(
                bill.paid ? Icons.check_circle : Icons.pending,
                color: bill.paid ? Color(0xFF10B981) : Color(0xFFF59E0B),
                size: 24,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bill.paid ? 'Fully Paid' : 'Pending Payment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: bill.paid ? Color(0xFF10B981) : Color(0xFFF59E0B),
                    ),
                  ),
                  Text(
                    bill.paid ? 'All dues have been cleared' : 'Outstanding amount: ${bill.formattedDues}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, String amount, bool isTotal, [Color? color]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: color ?? (isTotal ? Color(0xFF1E293B) : Colors.grey[700]),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: color ?? (isTotal ? Color(0xFF1E293B) : Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButtons(Bill bill) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Expanded(
          //   child: FloatingActionButton.extended(
          //     onPressed: () => _editBill(bill),
          //     backgroundColor: Color(0xFF10B981),
          //     foregroundColor: Colors.white,
          //     icon: Icon(Icons.edit),
          //     label: Text('Edit'),
          //     heroTag: "edit",
          //   ),
          // ),
          // SizedBox(width: 12),
          // Expanded(
          //   child: FloatingActionButton.extended(
          //     onPressed: () => _shareBill(bill),
          //     backgroundColor: Color(0xFF3B82F6),
          //     foregroundColor: Colors.white,
          //     icon: Icon(Icons.share),
          //     label: Text('Share'),
          //     heroTag: "share",
          //   ),
          // ),
          // SizedBox(width: 12),
          Expanded(
            child: FloatingActionButton.extended(
              onPressed: () => _downloadBill(bill),
              backgroundColor: Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
              icon: Icon(Icons.download),
              label: Text('Download'),
              heroTag: "download",
            ),
          ),
        ],
      ),
    );
  }

  Color _getCompanyColor(String company) {
    switch (company.toLowerCase()) {
      case 'apple':
        return Color(0xFF1E293B);
      case 'samsung':
        return Color(0xFF3B82F6);
      case 'xiaomi':
        return Color(0xFFF59E0B);
      case 'mix':
      case 'mixu':
        return Color(0xFF8B5CF6);
      case 'oppo':
        return Color(0xFF10B981);
      case 'vivo':
        return Color(0xFFEF4444);
      case 'oneplus':
        return Color(0xFF06B6D4);
      default:
        return Color(0xFF6B7280);
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Copied',
      '$label copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      backgroundColor: Color(0xFF10B981),
      colorText: Colors.white,
      icon: Icon(Icons.copy, color: Colors.white),
    );
  }

  void _markAsPaid(Bill bill) {
    Get.dialog(
      AlertDialog(
        title: Text('Mark as Paid'),
        content: Text('Are you sure you want to mark this bill as fully paid?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Success',
                'Bill marked as paid',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Color(0xFF10B981),
                colorText: Colors.white,
                icon: Icon(Icons.check_circle, color: Colors.white),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF10B981),
              foregroundColor: Colors.white,
            ),
            child: Text('Mark Paid'),
          ),
        ],
      ),
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

  void _downloadBill(Bill bill) {
    Get.snackbar(
      'Download',
      'Downloading Bill #${bill.billId}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF8B5CF6),
      colorText: Colors.white,
      icon: const Icon(Icons.download, color: Colors.white),
    );
  }
}