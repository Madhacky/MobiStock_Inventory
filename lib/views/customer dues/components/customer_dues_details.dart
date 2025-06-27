import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/customer%20dues%20management/all_customer_dues_model.dart';

class CustomerDueDetailsScreen extends StatelessWidget {
  final CustomerDue due;

  CustomerDueDetailsScreen({required this.due});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
      floatingActionButton: due.remainingDue > 0 ? _buildFloatingActionButton() : null,
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
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              due.customerName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _makeCall(),
            icon: Icon(Icons.call, color: Colors.white, size: 20),
          ),
          IconButton(
            onPressed: () => _shareDetails(),
            icon: Icon(Icons.share, color: Colors.white, size: 20),
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
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
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
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'ID: #${due.id}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Date: ${_formatDate(DateTime.parse(due.creationDate))}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: due.remainingDue > 0 ? Colors.red[50] : Colors.green[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: due.remainingDue > 0 ? Colors.red[200]! : Colors.green[200]!,
              ),
            ),
            child: Text(
              due.remainingDue > 0 ? 'PENDING' : 'PAID',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: due.remainingDue > 0 ? Colors.red[700] : Colors.green[700],
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

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 140,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(12),
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
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
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

  Widget _buildContactInformationSection() {
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
            _buildInfoRow(Icons.location_on, 'Address', '123 Main St, City, State'),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalInformationSection() {
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
            _buildInfoRow(Icons.access_time, 'Approval Date', _formatDate(DateTime.parse(due.creationDate))),
          ],
        ),
      ),
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
                      icon: Icon(Icons.add, size: 14, color: Colors.white),
                      label: Text('Add', style: TextStyle(color: Colors.white, fontSize: 12)),
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
                    icon: Icon(Icons.add_comment, size: 14, color: Colors.white),
                    label: Text('Add Note', style: TextStyle(color: Colors.white, fontSize: 12)),
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
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Text(
                'Customer notes and additional information will be displayed here. This includes payment terms, special conditions, and any other relevant details about the due amount.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  height: 1.5,
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
                icon: Icon(Icons.call, color: Colors.white, size: 18),
                label: Text('Call Customer', style: TextStyle(color: Colors.white, fontSize: 14)),
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
                icon: Icon(Icons.message, color: Colors.white, size: 18),
                label: Text('Send Reminder', style: TextStyle(color: Colors.white, fontSize: 14)),
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
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
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
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: Colors.grey[600], size: 16),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => _copyToClipboard(value),
          icon: Icon(Icons.copy, color: Colors.grey[400], size: 16),
          constraints: BoxConstraints(),
          padding: EdgeInsets.all(4),
        ),
      ],
    );
  }

  Widget _buildPaymentHistoryItem(String amount, String date, String method, bool showDivider) {
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
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '$date • $method',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
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
                  style: TextStyle(
                    color: Color(0xFF51CF66),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _showAddPaymentDialog(),
      backgroundColor: Color(0xFF6C5CE7),
      icon: Icon(Icons.payment, color: Colors.white),
      label: Text(
        'Add Payment',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Helper Methods
  String _getInitials(String name) {
    List<String> parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.length == 1) {
      return parts[0].length >= 2 ? parts[0].substring(0, 2).toUpperCase() : parts[0][0].toUpperCase();
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
      colorText: Colors.white,
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
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 8,
      margin: EdgeInsets.all(16),
    );
  }

  void _copyToClipboard(String text) {
    Get.snackbar(
      'Copied',
      'Copied to clipboard',
      backgroundColor: Colors.grey[700],
      colorText: Colors.white,
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
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 8,
      margin: EdgeInsets.all(16),
    );
  }

  void _addNote() {
    TextEditingController noteController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Note', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: noteController,
          maxLines: 4,
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            hintText: 'Enter note...',
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
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
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              if (noteController.text.isNotEmpty) {
                Get.back();
                Get.snackbar(
                  'Note Added',
                  'Note has been added successfully',
                  backgroundColor: Color(0xFF51CF66),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                  borderRadius: 8,
                  margin: EdgeInsets.all(16),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6C5CE7),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Add Note', style: TextStyle(color: Colors.white)),
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
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Payment', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Customer: ${due.customerName}', style: TextStyle(color: Colors.grey[600])),
                SizedBox(height: 8),
                Text('Remaining Due: ₹${due.remainingDue.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey[600])),
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
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
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
                DropdownButtonFormField<String>(
                  value: selectedMethod,
                  style: TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: 'Payment Method',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF6C5CE7)),
                    ),
                  ),
                  items: ['Cash', 'UPI', 'Card', 'Bank Transfer']
                      .map((method) => DropdownMenuItem(
                            value: method,
                            child: Text(method, style: TextStyle(color: Colors.black87)),
                          ))
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
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
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
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                  borderRadius: 8,
                  margin: EdgeInsets.all(16),
                );
              } else {
                Get.snackbar(
                  'Invalid Amount',
                  'Please enter a valid amount',
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Add Payment', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}