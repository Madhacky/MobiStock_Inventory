import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smartbecho/controllers/customer%20dues%20controllers/customer_dues_controller.dart';
import 'package:smartbecho/models/customer%20dues%20management/all_customer_dues_model.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDueDetailsScreen extends StatelessWidget {
  final CustomerDue due;

  CustomerDueDetailsScreen({required this.due});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerDuesController>();
    log(due.partialPayments.length.toString());
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildCustomAppBar(),
              _buildCustomerHeaderCard(),
              _buildQuickActionButtons(),
              _buildSummaryCards(),
              _buildPaymentProgressCard(),
              _buildAmountDetailsCard(),
              if (due.partialPayments.isNotEmpty) _buildPaymentHistorySection(),
              _buildActionButtons(controller),
              SizedBox(height: 100), // Space for floating action button
            ],
          ),
        ),
      ),
      floatingActionButton:
          due.remainingDue > 0 ? _buildFloatingActionButton(controller) : null,
    );
  }

  Widget _buildCustomAppBar() {
    return buildCustomAppBar(due.name, isdark: true);
  }

  Widget _buildCustomerHeaderCard() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFF4C51BF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6C5CE7).withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    _getInitials(due.name),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      due.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Sale ID: #${due.saleId}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Customer ID: ${due.customerId}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Date: ${_formatDate(due.creationDate)}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    String statusText;

    if (due.isOverpaid) {
      badgeColor = Colors.green[300]!;
      statusText = 'OVERPAID';
    } else if (due.isFullyPaid) {
      badgeColor = Colors.green[400]!;
      statusText = 'PAID';
    } else {
      badgeColor = Colors.orange[300]!;
      statusText = 'PENDING';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildQuickActionButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionButton(
              icon: Icons.call,
              label: 'Call',
              color: Color(0xFF4CAF50),
              onTap: () => _makePhoneCall(),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionButton(
              icon: Icons.message,
              label: 'WhatsApp',
              color: Color(0xFF25D366),
              onTap: () => _openWhatsApp(),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionButton(
              icon: Icons.share,
              label: 'Share',
              color: Color(0xFF2196F3),
              onTap: () => _shareDetails(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      height: 130,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildSummaryCard(
            'Total Due',
            '₹${_formatAmount(due.totalDue)}',
            Icons.account_balance_wallet_outlined,
            Color(0xFF6C5CE7),
          ),
          _buildSummaryCard(
            'Total Paid',
            '₹${_formatAmount(due.totalPaid)}',
            Icons.check_circle_outline,
            Color(0xFF51CF66),
          ),
          _buildSummaryCard(
            'Remaining Due',
            '₹${_formatAmount(due.remainingDue)}',
            Icons.error_outline,
            due.remainingDue > 0 ? Color(0xFFFF6B6B) : Color(0xFF51CF66),
          ),
          _buildSummaryCard(
            'Payment\nProgress',
            '${due.paymentProgress.toStringAsFixed(0)}%',
            Icons.trending_up_outlined,
            Color(0xFF4ECDC4),
          ),
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
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentProgressCard() {
    final progress = (due.paymentProgress / 100).clamp(0.0, 1.0);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('Payment Progress', Icons.trending_up),
              Text(
                '${due.paymentProgress.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                due.isOverpaid ? Colors.green[500]! : Colors.blue[600]!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountDetailsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Amount Details', Icons.account_balance),
            SizedBox(height: 16),
            _buildAmountRow('Total Due', due.totalDue, Colors.red[600]!),
            SizedBox(height: 12),
            _buildAmountRow('Total Paid', due.totalPaid, Colors.green[600]!),
            SizedBox(height: 12),
            Divider(thickness: 1),
            SizedBox(height: 12),
            _buildAmountRow(
              'Remaining Due',
              due.remainingDue,
              due.remainingDue > 0 ? Colors.orange[600]! : Colors.green[600]!,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(
    String label,
    double amount,
    Color color, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 15,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: Color(0xFF475569),
          ),
        ),
        Text(
          '₹${_formatAmount(amount)}',
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentHistorySection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader('Payment History', Icons.payment),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${due.partialPayments.length} payments',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Constrained height container for scrollable payment history
            Container(
              height: due.partialPayments.length > 3 ? 280 : null,
              child: ListView.separated(
                shrinkWrap: true,
                physics:
                    due.partialPayments.length > 3
                        ? AlwaysScrollableScrollPhysics()
                        : NeverScrollableScrollPhysics(),
                itemCount: due.partialPayments.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final payment = due.partialPayments[index];
                  return _buildPaymentHistoryItem(payment, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentHistoryItem(PartialPayment payment, int index) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF51CF66).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.payment, color: Color(0xFF51CF66), size: 18),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment #${index + 1}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'ID: ${payment.id}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                Text(
                  _formatDate(payment.paidDate),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${_formatAmount(payment.paidAmount)}',
                style: TextStyle(
                  color: Color(0xFF51CF66),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF51CF66).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF51CF66).withOpacity(0.3)),
                ),
                child: Text(
                  'Paid',
                  style: TextStyle(
                    color: Color(0xFF51CF66),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(CustomerDuesController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              child: ElevatedButton.icon(
                onPressed:
                    due.remainingDue > 0 ? () => _showAddPaymentDialog(controller) : null,
                icon: Icon(Icons.payment, color: Colors.white, size: 20),
                label: Text(
                  'Add Payment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      due.remainingDue > 0 ? Color(0xFF6C5CE7) : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => _generateInvoice(),
                icon: Icon(
                  Icons.receipt_long,
                  color: Color(0xFF6C5CE7),
                  size: 20,
                ),
                label: Text(
                  'Generate Invoice',
                  style: TextStyle(
                    color: Color(0xFF6C5CE7),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF6C5CE7), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(CustomerDuesController controller) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddPaymentDialog(controller),
      backgroundColor: Color(0xFF6C5CE7),
      icon: Icon(Icons.payment, color: Colors.white),
      label: Text(
        'Add Payment',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF6C5CE7).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Color(0xFF6C5CE7), size: 18),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Helper Methods
  String _getInitials(String name) {
    List<String> parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.length == 1) {
      return parts[0].length >= 2
          ? parts[0].substring(0, 2).toUpperCase()
          : parts[0][0].toUpperCase();
    }
    return 'UN';
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatAmount(double amount) {
    return NumberFormat('#,##,###.##').format(amount);
  }

  // Action Methods
  void _shareDetails() {
    Get.snackbar(
      'Share',
      'Sharing customer due details...',
      backgroundColor: Color(0xFF6C5CE7),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 8,
      margin: EdgeInsets.all(16),
    );
  }

  void _generateInvoice() {
    Get.snackbar(
      'Invoice',
      'Generating invoice for ${due.name}...',
      backgroundColor: Color(0xFF4ECDC4),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 8,
      margin: EdgeInsets.all(16),
    );
  }

  void _makePhoneCall() async {
    // Replace with actual phone number from your model
    final phoneNumber = 'tel:+1234567890'; // due.phoneNumber
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      Get.snackbar(
        'Error',
        'Could not make phone call',
        backgroundColor: Color(0xFFFF6B6B),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(16),
      );
    }
  }

  void _openWhatsApp() async {
    // Replace with actual phone number from your model
    final phoneNumber = '+1234567890'; // due.phoneNumber
    final message =
        'Hello ${due.name}, regarding your payment due of ₹${_formatAmount(due.remainingDue)}';
    final whatsappUrl =
        'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}';

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      Get.snackbar(
        'Error',
        'WhatsApp is not installed on this device',
        backgroundColor: Color(0xFFFF6B6B),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(16),
      );
    }
  }

  void _showAddPaymentDialog(CustomerDuesController controller) {
    if (due.remainingDue <= 0) return;

    TextEditingController amountController = TextEditingController();
    String selectedMethod = 'Cash';

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Add Payment',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer: ${due.name}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  'Due ID: ${due.id}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  'Remaining Due: ₹${_formatAmount(due.remainingDue)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: 'Payment Amount',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF6C5CE7)),
                    ),
                    prefixText: '₹',
                    prefixStyle: TextStyle(color: Colors.black87),
                  ),
                ),
                SizedBox(height: 16),
                // DropdownButtonFormField<String>(
                //   value: selectedMethod,
                //   style: TextStyle(color: Colors.black87),
                //   decoration: InputDecoration(
                //     labelText: 'Payment Method',
                //     labelStyle: TextStyle(color: Colors.grey[600]),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(8),
                //       borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(8),
                //       borderSide: BorderSide(color: Color(0xFF6C5CE7)),
                //     ),
                //   ),
                //   items: ['Cash', 'UPI', 'Card', 'Bank Transfer']
                //       .map((method) => DropdownMenuItem(
                //             value: method,
                //             child: Text(method, style: TextStyle(color: Colors.black87)),
                //           ))
                //       .toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       selectedMethod = value!;
                //     });
                //   },
                // ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () {
                double amount = double.tryParse(amountController.text) ?? 0;
                if (amount > 0 && amount <= due.remainingDue) {
                  controller.addPartialPayment(due.saleId, amount);
                } else {
                  Get.snackbar(
                    'Invalid Amount',
                    'Please enter a valid amount (max ₹${_formatAmount(due.remainingDue)})',
                    backgroundColor: Color(0xFFFF6B6B),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    borderRadius: 8,
                    margin: EdgeInsets.all(16),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6C5CE7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:
                  controller.isPartialAddedloading.value
                      ? Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : Text(
                        'Record Payment',
                        style: TextStyle(color: Colors.white),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
