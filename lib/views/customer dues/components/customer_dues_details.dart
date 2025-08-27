import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smartbecho/controllers/customer%20dues%20controllers/customer_dues_controller.dart';
import 'package:smartbecho/models/customer%20dues%20management/customer_due_detail_model.dart';
import 'package:smartbecho/services/shared_preferences_services.dart';
import 'package:smartbecho/services/whatsapp_chat_launcher.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:smartbecho/utils/show_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDueDetailsScreen extends StatefulWidget {
  final int dueId;

  CustomerDueDetailsScreen({required this.dueId});

  @override
  _CustomerDueDetailsScreenState createState() =>
      _CustomerDueDetailsScreenState();
}

class _CustomerDueDetailsScreenState extends State<CustomerDueDetailsScreen> {
  late CustomerDuesController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CustomerDuesController>();
    // Fetch customer due details when screen loads
    controller.fetchCustomerDueDetails(widget.dueId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Obx(() {
          if (controller.isDetailsLoading.value) {
            return _buildLoadingState();
          }

          if (controller.hasDetailsError.value) {
            return _buildErrorState();
          }

          if (controller.customerDueDetails.value == null) {
            return _buildEmptyState();
          }

          final dueDetails = controller.customerDueDetails.value!;
          return _buildContent(dueDetails);
        }),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        buildCustomAppBar('Loading...', isdark: true),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Color(0xFF6C5CE7),
                  strokeWidth: 3,
                ),
                SizedBox(height: 16),
                Text(
                  'Loading customer details...',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Column(
      children: [
        buildCustomAppBar('Error', isdark: true),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                SizedBox(height: 16),
                Text(
                  'Failed to load customer details',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  controller.detailsErrorMessage.value,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed:
                      () => controller.fetchCustomerDueDetails(widget.dueId),
                  icon: Icon(Icons.refresh, color: Colors.white),
                  label: Text('Retry', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6C5CE7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        buildCustomAppBar('Not Found', isdark: true),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text(
                  'Customer details not found',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'The requested customer due details could not be found.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(CustomerDueDetailsModel dueDetails) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchCustomerDueDetails(widget.dueId),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildCustomAppBar(dueDetails.customer.name ?? ""),
            _buildCustomerHeaderCard(dueDetails),
            _buildQuickActionButtons(dueDetails),
            _buildSummaryCards(dueDetails),
            _buildPaymentProgressCard(dueDetails),
            _buildAmountDetailsCard(dueDetails),
            _buildCustomerInfoCard(dueDetails),
            if (dueDetails.partialPayments.isNotEmpty)
              _buildPaymentHistorySection(dueDetails),
            _buildActionButtons(dueDetails),
            SizedBox(height: 100), // Space for floating action button
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(String title) {
    return buildCustomAppBar(title, isdark: true);
  }

  Widget _buildCustomerHeaderCard(CustomerDueDetailsModel dueDetails) {
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
            color: Color(0xFF6C5CE7).withValues(alpha: 0.3),
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
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    _getInitials(dueDetails.customer.name ?? ""),
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
                      dueDetails.customer.name ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Due ID: #${dueDetails.duesId}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Customer ID: ${dueDetails.customer.id}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Date: ${_formatDate(dueDetails.creationDateTime)}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(dueDetails),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(CustomerDueDetailsModel dueDetails) {
    Color badgeColor;
    String statusText;

    if (dueDetails.isOverpaid) {
      badgeColor = Colors.green[300]!;
      statusText = 'OVERPAID';
    } else if (dueDetails.isFullyPaid) {
      badgeColor = Colors.green[400]!;
      statusText = 'PAID';
    } else {
      badgeColor = Colors.orange[300]!;
      statusText = 'PENDING';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
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

  Widget _buildQuickActionButtons(CustomerDueDetailsModel dueDetails) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionButton(
              icon: Icons.call,
              label: 'Call',
              color: Color(0xFF4CAF50),
              onTap:
                  () => _makePhoneCall(dueDetails.customer.primaryPhone ?? ""),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionButton(
              icon: Icons.message,
              label: 'WhatsApp',
              color: Color(0xFF25D366),
              onTap: () => _openWhatsApp(dueDetails),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionButton(
              icon: Icons.share,
              label: 'Share',
              color: Color(0xFF2196F3),
              onTap: () => _shareDetails(dueDetails),
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
              color: Colors.grey.withValues(alpha: 0.1),
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
                color: color.withValues(alpha: 0.1),
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

  Widget _buildSummaryCards(CustomerDueDetailsModel dueDetails) {
    return Container(
      height: 140,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildSummaryCard(
            'Total Due',
            '₹${_formatAmount(dueDetails.totalDue)}',
            Icons.account_balance_wallet_outlined,
            Color(0xFF6C5CE7),
          ),
          _buildSummaryCard(
            'Total Paid',
            '₹${_formatAmount(dueDetails.totalPaid)}',
            Icons.check_circle_outline,
            Color(0xFF51CF66),
          ),
          _buildSummaryCard(
            'Remaining Due',
            '₹${_formatAmount(dueDetails.remainingDue)}',
            Icons.error_outline,
            dueDetails.remainingDue > 0 ? Color(0xFFFF6B6B) : Color(0xFF51CF66),
          ),
          _buildSummaryCard(
            'Payment\nProgress',
            '${dueDetails.paymentProgress.toStringAsFixed(0)}%',
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
            color: Colors.grey.withValues(alpha: 0.08),
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
              color: color.withValues(alpha: 0.1),
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

  Widget _buildPaymentProgressCard(CustomerDueDetailsModel dueDetails) {
    final progress = (dueDetails.paymentProgress / 100).clamp(0.0, 1.0);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
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
                '${dueDetails.paymentProgress.toStringAsFixed(1)}%',
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
                dueDetails.isOverpaid ? Colors.green[500]! : Colors.blue[600]!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountDetailsCard(CustomerDueDetailsModel dueDetails) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
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
            _buildAmountRow('Total Due', dueDetails.totalDue, Colors.red[600]!),
            SizedBox(height: 12),
            _buildAmountRow(
              'Total Paid',
              dueDetails.totalPaid,
              Colors.green[600]!,
            ),
            SizedBox(height: 12),
            Divider(thickness: 1),
            SizedBox(height: 12),
            _buildAmountRow(
              'Remaining Due',
              dueDetails.remainingDue,
              dueDetails.remainingDue > 0
                  ? Colors.orange[600]!
                  : Colors.green[600]!,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfoCard(CustomerDueDetailsModel dueDetails) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.08),
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
          _buildSectionHeader('Customer Information', Icons.person),
          SizedBox(height: 16),
          _buildInfoRow('Name', dueDetails.customer.name ?? ""),
          SizedBox(height: 12),
          _buildInfoRow('Email', dueDetails.customer.email ?? ""),
          SizedBox(height: 12),
          _buildInfoRow('Phone', dueDetails.customer.primaryPhone ?? ""),
          SizedBox(height: 12),
          _buildInfoRow('Address', dueDetails.customer.primaryAddress ?? ""),
          SizedBox(height: 12),
          _buildInfoRow('Location', dueDetails.customer.location ?? ""),
          // Fix: Check for null before accessing alternatePhones
          if (dueDetails.customer.alternatePhones != null && 
              dueDetails.customer.alternatePhones!.isNotEmpty) ...[
            SizedBox(height: 12),
            _buildInfoRow(
              'Alternate Phones',
              dueDetails.customer.alternatePhones!.join(', '),
            ),
          ],
        ],
      ),
    ),
  );
}

  Widget _buildPaymentHistorySection(CustomerDueDetailsModel dueDetails) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
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
            _buildSectionHeader('Payment History', Icons.history),
            SizedBox(height: 16),
            ...dueDetails.partialPayments
                .map((payment) => _buildPaymentHistoryItem(payment))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentHistoryItem(PartialPaymentDetail payment) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.check_circle, color: Colors.green[600], size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹${_formatAmount(payment.paidAmount)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Paid on ${_formatDate(payment.paidDateTime)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(CustomerDueDetailsModel dueDetails) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          if (dueDetails.remainingDue > 0) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showAddPaymentDialog(dueDetails),
                icon: Icon(Icons.add_circle_outline, color: Colors.white),
                label: Text(
                  'Add Payment',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C5CE7),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton.icon(
            //     onPressed: () => _showMarkAsPaidDialog(dueDetails),
            //     icon: Icon(Icons.check_circle_outline, color: Colors.white),
            //     label: Text(
            //       'Mark as Paid',
            //       style: TextStyle(color: Colors.white, fontSize: 16),
            //     ),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Color(0xFF51CF66),
            //       padding: EdgeInsets.symmetric(vertical: 16),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //   ),
            // ),
          ],
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showNotifyDialog(dueDetails),
              icon: Icon(
                Icons.notifications_outlined,
                color: Color(0xFF6C5CE7),
              ),
              label: Text(
                'Send Reminder',
                style: TextStyle(color: Color(0xFF6C5CE7), fontSize: 16),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xFF6C5CE7)),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widgets
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF6C5CE7).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Color(0xFF6C5CE7), size: 20),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
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
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Text(
          '₹${_formatAmount(amount)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            value.isEmpty ? 'N/A' : value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // Dialog methods
  void _showAddPaymentDialog(CustomerDueDetailsModel dueDetails) {
    final TextEditingController amountController = TextEditingController();
    String selectedPaymentMode = 'CASH';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Add Payment'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Remaining Due: ₹${_formatAmount(dueDetails.remainingDue)}',
                ),
                SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Payment Amount',
                    prefixText: '₹',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedPaymentMode,
                  decoration: InputDecoration(
                    labelText: 'Payment Mode',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items:
                      ['CASH', 'BANK CARD', 'UPI', 'BANK TRANSFER'].map((mode) {
                        return DropdownMenuItem(
                          value: mode,
                          child: Text(mode.replaceAll('_', ' ')),
                        );
                      }).toList(),
                  onChanged: (value) {
                    selectedPaymentMode = value!;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              Obx(
                () => ElevatedButton(
                  onPressed:
                      controller.isPartialAddedloading.value
                          ? null
                          : () async {
                            final amount = double.tryParse(
                              amountController.text,
                            );
                            if (amount != null && amount > 0) {
                              await controller.addPartialPayment(
                                dueDetails.duesId,
                                amount,
                                selectedPaymentMode,
                              );
                              Navigator.pop(context);
                              // Refresh the details
                              controller.fetchCustomerDueDetails(widget.dueId);
                            }
                          },
                  child:
                      controller.isPartialAddedloading.value
                          ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text('Add Payment'),
                ),
              ),
            ],
          ),
    );
  }

  void _showNotifyDialog(CustomerDueDetailsModel dueDetails) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Send Reminder'),
            content: Text(
              'Send payment reminder to ${dueDetails.customer.name}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await controller.notifyCustomer(
                    dueDetails.customer.id ?? 0,
                    dueDetails.customer.name ?? "",
                  );
                  Navigator.pop(context);
                },
                child: Text('Send Reminder'),
              ),
            ],
          ),
    );
  }

  // Action methods
  void _makePhoneCall(String phoneNumber) {
    controller.callCustomer(phoneNumber);
  }

  void _openWhatsApp(CustomerDueDetailsModel customerDue) async {
    final businessName = await SharedPreferencesHelper.getShopStoreName();

    // bool success = await WhatsAppService.openWhatsAppWithFallback(
    //     phoneNumber: phoneNumber,
    //     message: "hi"
    //   );
    bool success = await WhatsAppService.sendDueMessage(
      customerDue: customerDue,
      businessName: businessName ?? "N/A",
      detailed: true,
    );

    if (success) {
      print('WhatsApp opened successfully');
    } else {
      print('Failed to open WhatsApp');
    }
  }

  void _shareDetails(CustomerDueDetailsModel dueDetails) {
    final String shareText = '''
Payment Details:
Customer: ${dueDetails.customer.name}
Due ID: #${dueDetails.duesId}
Total Due: ₹${_formatAmount(dueDetails.totalDue)}
Total Paid: ₹${_formatAmount(dueDetails.totalPaid)}
Remaining Due: ₹${_formatAmount(dueDetails.remainingDue)}
''';

    Clipboard.setData(ClipboardData(text: shareText));
    Get.snackbar(
      'Success',
      'Details copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withValues(alpha: 0.8),
      colorText: Colors.white,
    );
  }

  // Helper methods
  String _getInitials(String name) {
    // Handle null, empty, or whitespace-only strings
    if (name.trim().isEmpty) {
      return 'U';
    }

    List<String> nameParts =
        name
            .trim()
            .split(' ')
            .where((part) => part.isNotEmpty) // Filter out empty parts
            .toList();

    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }

    return 'U'; // Default fallback
  }

  String _formatAmount(double amount) {
    final formatter = NumberFormat('#,##,###');
    return formatter.format(amount);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
}
