import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/customer%20dues%20management/all_customer_dues_model.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';

class CustomerDueDetailsScreen extends StatelessWidget {
  final CustomerDue due;

  CustomerDueDetailsScreen({required this.due});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey50,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildCustomAppBar(),
              _buildCustomerHeaderCard(),
              _buildSummaryCards(),
              _buildContactInformationSection(),
              _buildApprovalInformationSection(),
              _buildPaymentHistorySection(),
              _buildNotesSection(),
              _buildActionButtons(),
              SizedBox(height: 100), // Space for floating action button
            ],
          ),
        ),
      ),
      floatingActionButton:
          due.remainingDue > 0 ? _buildFloatingActionButton() : null,
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back,
              color: AppTheme.backgroundLight,
              size: 24,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              due.customerName,
              style: AppStyles.custom(
                size: 18,
                weight: FontWeight.bold,
                color: AppTheme.backgroundLight,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _makeCall(),
            icon: Icon(Icons.call, color: AppTheme.backgroundLight, size: 20),
          ),
          IconButton(
            onPressed: () => _shareDetails(),
            icon: Icon(Icons.share, color: AppTheme.backgroundLight, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerHeaderCard() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity08,
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C5CE7), Color(0xFF4C51BF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                _getInitials(due.customerName),
                style: AppStyles.custom(
                  color: AppTheme.backgroundLight,
                  weight: FontWeight.bold,
                  size: 20,
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
                  due.customerName,
                  style: AppStyles.custom(
                    color: AppTheme.black87,
                    size: 18,
                    weight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'ID: #${due.id}',
                  style: AppStyles.custom(color: AppTheme.grey600, size: 14),
                ),
                Text(
                  'Date: ${_formatDate(DateTime.parse(due.creationDate))}',
                  style: AppStyles.custom(color: AppTheme.grey600, size: 14),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: due.remainingDue > 0 ? AppTheme.red50 : AppTheme.green50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    due.remainingDue > 0 ? AppTheme.red200 : AppTheme.green200,
              ),
            ),
            child: Text(
              due.remainingDue > 0 ? 'PENDING' : 'PAID',
              style: AppStyles.custom(
                size: 12,
                weight: FontWeight.bold,
                color:
                    due.remainingDue > 0 ? AppTheme.red700 : AppTheme.green700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      height: 120,
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
            Color(0xFFFF6B6B),
          ),
          _buildSummaryCard(
            'Payment\nProgress',
            '${((due.totalPaid / due.totalDue) * 100).toStringAsFixed(0)}%',
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
      width: 140,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity08,
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
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: AppStyles.custom(
              size: 14,
              weight: FontWeight.bold,
              color: AppTheme.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            title,
            style: AppStyles.custom(
              size: 10,
              color: AppTheme.grey600,
              // height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildContactInformationSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity08,
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Contact Information', Icons.contact_phone),
            SizedBox(height: 16),
            _buildInfoRow(Icons.phone, 'Phone', '+91 98765 43210'),
            SizedBox(height: 12),
            _buildInfoRow(Icons.email, 'Email', 'customer@example.com'),
            SizedBox(height: 12),
            _buildInfoRow(
              Icons.location_on,
              'Address',
              '123 Main St, City, State',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalInformationSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity08,
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Approval Information', Icons.verified_user),
            SizedBox(height: 16),
            _buildInfoRow(Icons.check_circle, 'Approved by', 'Admin User'),
            SizedBox(height: 12),
            _buildInfoRow(Icons.person, 'Given by', 'Sales Person'),
            SizedBox(height: 12),
            _buildInfoRow(
              Icons.access_time,
              'Approval Date',
              _formatDate(DateTime.parse(due.creationDate)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentHistorySection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity08,
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader('Payment History', Icons.payment),
                if (due.remainingDue > 0)
                  Container(
                    height: 32,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddPaymentDialog(),
                      icon: Icon(
                        Icons.add,
                        size: 14,
                        color: AppTheme.backgroundLight,
                      ),
                      label: Text(
                        'Add',
                        style: AppStyles.custom(
                          color: AppTheme.backgroundLight,
                          size: 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6C5CE7),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16),
            _buildPaymentHistoryItem('₹500', '20/06/2025', 'Cash', true),
            _buildPaymentHistoryItem('₹300', '19/06/2025', 'UPI', true),
            _buildPaymentHistoryItem('₹200', '18/06/2025', 'Cash', true),
            _buildPaymentHistoryItem('₹150', '17/06/2025', 'Card', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity08,
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader('Notes', Icons.note),
                Container(
                  height: 32,
                  child: ElevatedButton.icon(
                    onPressed: () => _addNote(),
                    icon: Icon(
                      Icons.add_comment,
                      size: 14,
                      color: AppTheme.backgroundLight,
                    ),
                    label: Text(
                      'Add Note',
                      style: AppStyles.custom(
                        color: AppTheme.backgroundLight,
                        size: 12,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4ECDC4),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.grey50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.greyOpacity02),
              ),
              child: Text(
                'Customer notes and additional information will be displayed here. This includes payment terms, special conditions, and any other relevant details about the due amount.',
                style: AppStyles.custom(
                  color: AppTheme.grey600,
                  size: 14,
                  // height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => _makeCall(),
                icon: Icon(
                  Icons.call,
                  color: AppTheme.backgroundLight,
                  size: 18,
                ),
                label: Text(
                  'Call Customer',
                  style: AppStyles.custom(
                    color: AppTheme.backgroundLight,
                    size: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF51CF66),
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
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => _sendReminder(),
                icon: Icon(
                  Icons.message,
                  color: AppTheme.backgroundLight,
                  size: 18,
                ),
                label: Text(
                  'Send Reminder',
                  style: AppStyles.custom(
                    color: AppTheme.backgroundLight,
                    size: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF9500),
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
          style: AppStyles.custom(
            color: AppTheme.black87,
            size: 16,
            weight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppTheme.grey100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: AppTheme.grey600, size: 16),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppStyles.custom(
                  color: AppTheme.grey600,
                  size: 12,
                  weight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: AppStyles.custom(
                  color: AppTheme.black87,
                  size: 14,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => _copyToClipboard(value),
          icon: Icon(Icons.copy, color: AppTheme.grey400, size: 16),
          constraints: BoxConstraints(),
          padding: EdgeInsets.all(4),
        ),
      ],
    );
  }

  Widget _buildPaymentHistoryItem(
    String amount,
    String date,
    String method,
    bool showDivider,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF51CF66).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.payment, color: Color(0xFF51CF66), size: 16),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      amount,
                      style: AppStyles.custom(
                        color: AppTheme.black87,
                        size: 16,
                        weight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '$date • $method',
                      style: AppStyles.custom(
                        color: AppTheme.grey600,
                        size: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF51CF66).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF51CF66).withOpacity(0.3)),
                ),
                child: Text(
                  'Paid',
                  style: AppStyles.custom(
                    color: Color(0xFF51CF66),
                    size: 10,
                    weight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, color: AppTheme.greyOpacity02),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _showAddPaymentDialog(),
      backgroundColor: Color(0xFF6C5CE7),
      icon: Icon(Icons.payment, color: AppTheme.backgroundLight),
      label: Text(
        'Add Payment',
        style: AppStyles.custom(
          color: AppTheme.backgroundLight,
          weight: FontWeight.w600,
        ),
      ),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }

  // Action Methods
  void _makeCall() {
    Get.snackbar(
      'Calling',
      'Calling ${due.customerName}...',
      backgroundColor: Color(0xFF51CF66),
      colorText: AppTheme.backgroundLight,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 8,
      margin: EdgeInsets.all(16),
    );
  }

  void _shareDetails() {
    Get.snackbar(
      'Share',
      'Sharing customer due details...',
      backgroundColor: Color(0xFF6C5CE7),
      colorText: AppTheme.backgroundLight,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 8,
      margin: EdgeInsets.all(16),
    );
  }

  void _copyToClipboard(String text) {
    Get.snackbar(
      'Copied',
      'Copied to clipboard',
      backgroundColor: AppTheme.grey700,
      colorText: AppTheme.backgroundLight,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 1),
      borderRadius: 8,
      margin: EdgeInsets.all(16),
    );
  }

  void _sendReminder() {
    Get.snackbar(
      'Reminder Sent',
      'Payment reminder sent to ${due.customerName}',
      backgroundColor: Color(0xFFFF9500),
      colorText: AppTheme.backgroundLight,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 8,
      margin: EdgeInsets.all(16),
    );
  }

  void _addNote() {
    TextEditingController noteController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.backgroundLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Add Note',
          style: AppStyles.custom(
            color: AppTheme.black87,
            weight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: noteController,
          maxLines: 4,
          style: AppStyles.custom(color: AppTheme.black87),
          decoration: InputDecoration(
            hintText: 'Enter note...',
            hintStyle: AppStyles.custom(color: AppTheme.grey500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.greyOpacity03),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF6C5CE7)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppStyles.custom(color: AppTheme.grey600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (noteController.text.isNotEmpty) {
                Get.back();
                Get.snackbar(
                  'Note Added',
                  'Note has been added successfully',
                  backgroundColor: Color(0xFF51CF66),
                  colorText: AppTheme.backgroundLight,
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
            child: Text(
              'Add Note',
              style: AppStyles.custom(color: AppTheme.backgroundLight),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPaymentDialog() {
    TextEditingController amountController = TextEditingController();
    String selectedMethod = 'Cash';

    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.backgroundLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Add Payment',
          style: AppStyles.custom(
            color: AppTheme.black87,
            weight: FontWeight.bold,
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer: ${due.customerName}',
                  style: AppStyles.custom(color: AppTheme.grey600),
                ),
                SizedBox(height: 8),
                Text(
                  'Remaining Due: ₹${due.remainingDue.toStringAsFixed(2)}',
                  style: AppStyles.custom(color: AppTheme.grey600),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: AppStyles.custom(color: AppTheme.black87),
                  decoration: InputDecoration(
                    labelText: 'Payment Amount',
                    labelStyle: AppStyles.custom(color: AppTheme.grey600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppTheme.greyOpacity03),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF6C5CE7)),
                    ),
                    prefixText: '₹',
                    prefixStyle: AppStyles.custom(color: AppTheme.black87),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedMethod,
                  style: AppStyles.custom(color: AppTheme.black87),
                  decoration: InputDecoration(
                    labelText: 'Payment Method',
                    labelStyle: AppStyles.custom(color: AppTheme.grey600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppTheme.greyOpacity03),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF6C5CE7)),
                    ),
                  ),
                  items:
                      ['Cash', 'UPI', 'Card', 'Bank Transfer']
                          .map(
                            (method) => DropdownMenuItem(
                              value: method,
                              child: Text(
                                method,
                                style: AppStyles.custom(
                                  color: AppTheme.black87,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMethod = value!;
                    });
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppStyles.custom(color: AppTheme.grey600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              double amount = double.tryParse(amountController.text) ?? 0;
              if (amount > 0 && amount <= due.remainingDue) {
                Get.back();
                Get.snackbar(
                  'Payment Added',
                  'Payment of ₹${amount.toStringAsFixed(2)} added successfully',
                  backgroundColor: Color(0xFF51CF66),
                  colorText: AppTheme.backgroundLight,
                  snackPosition: SnackPosition.BOTTOM,
                  borderRadius: 8,
                  margin: EdgeInsets.all(16),
                );
              } else {
                Get.snackbar(
                  'Invalid Amount',
                  'Please enter a valid amount',
                  backgroundColor: Color(0xFFFF6B6B),
                  colorText: AppTheme.backgroundLight,
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
            child: Text(
              'Add Payment',
              style: AppStyles.custom(color: AppTheme.backgroundLight),
            ),
          ),
        ],
      ),
    );
  }
}
