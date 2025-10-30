import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/sales%20hisrory%20controllers/sales_history_comtroller.dart';
import 'package:smartbecho/models/sales%20history%20models/sales_details_model.dart';
import 'package:smartbecho/utils/custom_appbar.dart';

class SaleDetailsPage extends StatefulWidget {
  @override
  _SaleDetailsPageState createState() => _SaleDetailsPageState();
}

class _SaleDetailsPageState extends State<SaleDetailsPage> {
  final SalesManagementController controller =
      Get.find<SalesManagementController>();
  late int saleId;

  @override
  void initState() {
    super.initState();
    saleId = Get.arguments as int;
    controller.fetchSaleDetail(saleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: BuildAppBar(title: "Sales Details", isdark: true),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoadingDetail.value) {
            return _buildLoadingState();
          }

          if (controller.hasDetailError.value) {
            return _buildErrorState();
          }

          if (controller.saleDetail.value == null) {
            return _buildEmptyState();
          }

          return _buildDetailContent();
        }),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
            ),
            SizedBox(height: 16),
            Text(
              'Loading sale details...',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            SizedBox(height: 16),
            Text(
              'Failed to load sale details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              controller.detailErrorMessage.value,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => controller.fetchSaleDetail(saleId),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3B82F6),
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No sale details found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailContent() {
    final sale = controller.saleDetail.value!;

    return CustomScrollView(
      slivers: [
        // Modern App Bar
        // SliverToBoxAdapter(
        //   child: buildCustomAppBar("Sales Details", isdark: true),
        // ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSaleOverview(sale),
                SizedBox(height: 16),
                _buildCustomerSection(sale),
                SizedBox(height: 16),
                _buildItemsList(sale),
                SizedBox(height: 16),
                _buildPricingBreakdown(sale),
                SizedBox(height: 16),
                if (sale.dues != null) _buildDuesSection(sale.dues!),
                if (sale.emi != null) ...[
                  SizedBox(height: 16),
                  _buildEmiSection(sale.emi!),
                ],
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaleOverview(SaleDetailResponse sale) {
    return Container(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invoice',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '#${sale.invoiceNumber}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      sale.paid
                          ? Color(0xFF10B981).withValues(alpha: 0.1)
                          : Color(0xFFF59E0B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      sale.paid ? Icons.check_circle : Icons.pending,
                      size: 16,
                      color: sale.paid ? Color(0xFF10B981) : Color(0xFFF59E0B),
                    ),
                    SizedBox(width: 4),
                    Text(
                      sale.paymentStatus,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            sale.paid ? Color(0xFF10B981) : Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date & Time',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${sale.formattedDate}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (sale.formattedTime.isNotEmpty)
                      Text(
                        '${sale.formattedTime}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Shop',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      sale.shopName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Divider(color: Colors.grey[200]),

          SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                sale.formattedTotalAmount,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection(SaleDetailResponse sale) {
    return Container(
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
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(0xFF3B82F6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(Icons.person, color: Color(0xFF3B82F6), size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      sale.customer.displayName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: sale.customer.displayPhone,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.location_on,
                  label: 'Location',
                  value: sale.customer.location,
                ),
              ),
            ],
          ),

          if (sale.customer.displayAddress != 'No address') ...[
            SizedBox(height: 12),
            _buildInfoItem(
              icon: Icons.home,
              label: 'Address',
              value: sale.customer.displayAddress,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemsList(SaleDetailResponse sale) {
    return Container(
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
            children: [
              Icon(Icons.shopping_bag, size: 20, color: Color(0xFF3B82F6)),
              SizedBox(width: 8),
              Text(
                'Items Sold',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF3B82F6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${sale.items.length} ${sale.items.length == 1 ? 'item' : 'items'}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          ...sale.items.asMap().entries.map((entry) {
            SaleItem item = entry.value;

            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.phone_android,
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
                              item.model,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${item.color} • ${item.specifications}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Qty: ${item.quantity}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            item.formattedPrice,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  if (item.accessoryIncluded &&
                      item.accessoryName.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Color(0xFF10B981),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Includes: ${item.accessoryName}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPricingBreakdown(SaleDetailResponse sale) {
    return Container(
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
            children: [
              Icon(Icons.receipt, size: 20, color: Color(0xFF8B5CF6)),
              SizedBox(width: 8),
              Text(
                'Pricing Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          _buildPriceRow('Amount (without GST)', sale.formattedWithoutGst),
          SizedBox(height: 8),
          _buildPriceRow(
            'GST (${sale.gst.toStringAsFixed(0)}%)',
            '₹${(sale.withGst - sale.withoutGst).toStringAsFixed(2)}',
          ),
          SizedBox(height: 8),
          _buildPriceRow('Amount (with GST)', sale.formattedWithGst),

          if (sale.accessoriesCost > 0) ...[
            SizedBox(height: 8),
            _buildPriceRow('Accessories Cost', sale.formattedAccessoriesCost),
          ],

          if (sale.extraCharges > 0) ...[
            SizedBox(height: 8),
            _buildPriceRow('Extra Charges', sale.formattedExtraCharges),
          ],

          if (sale.repairCharges > 0) ...[
            SizedBox(height: 8),
            _buildPriceRow('Repair Charges', sale.formattedRepairCharges),
          ],

          if (sale.totalDiscount > 0) ...[
            SizedBox(height: 8),
            _buildPriceRow(
              'Discount',
              '- ${sale.formattedTotalDiscount}',
              isDiscount: true,
            ),
          ],

          SizedBox(height: 12),
          Divider(color: Colors.grey[300]),
          SizedBox(height: 12),

          _buildPriceRow(
            'Total Amount',
            sale.formattedTotalAmount,
            isBold: true,
            isTotal: true,
          ),

          if (sale.downPayment > 0) ...[
            SizedBox(height: 8),
            _buildPriceRow(
              'Down Payment',
              sale.formattedDownPayment,
              isDownPayment: true,
            ),
            SizedBox(height: 8),
            _buildPriceRow(
              'Remaining',
              '₹${(sale.totalAmount - sale.downPayment).toStringAsFixed(2)}',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isBold = false,
    bool isTotal = false,
    bool isDiscount = false,
    bool isDownPayment = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black87 : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color:
                isTotal
                    ? Color(0xFF10B981)
                    : isDiscount
                    ? Colors.red[600]
                    : isDownPayment
                    ? Color(0xFF3B82F6)
                    : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDuesSection(SaleDues dues) {
    return Container(
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
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 20,
                color: dues.paid ? Color(0xFF10B981) : Color(0xFFF59E0B),
              ),
              SizedBox(width: 8),
              Text(
                'Payment Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      dues.paid
                          ? Color(0xFF10B981).withValues(alpha: 0.1)
                          : Color(0xFFF59E0B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  dues.paid ? 'Paid' : 'Pending',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: dues.paid ? Color(0xFF10B981) : Color(0xFFF59E0B),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Payment Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment Progress',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${(dues.paymentProgress * 100).toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 8),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: dues.paymentProgress),
                duration: Duration(milliseconds: 1500),
                builder: (context, progressValue, child) {
                  return LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      dues.paid ? Color(0xFF10B981) : Color(0xFFF59E0B),
                    ),
                  );
                },
              ),
            ],
          ),

          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildDueItem('Total Due', dues.formattedTotalDue),
              ),
              Expanded(child: _buildDueItem('Paid', dues.formattedTotalPaid)),
              Expanded(
                child: _buildDueItem('Remaining', dues.formattedRemainingDue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDueItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildEmiSection(SaleEmi emi) {
    return Container(
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
            children: [
              Icon(Icons.schedule, size: 20, color: Color(0xFF8B5CF6)),
              SizedBox(width: 8),
              Text(
                'EMI Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // EMI Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'EMI Progress',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${emi.paidMonths}/${emi.totalMonths} months',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 8),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: emi.completionPercentage / 100),
                duration: Duration(milliseconds: 1500),
                builder: (context, progressValue, child) {
                  return LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF8B5CF6),
                    ),
                  );
                },
              ),
            ],
          ),

          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildEmiItem('Monthly EMI', emi.formattedMonthlyEmi),
              ),
              Expanded(
                child: _buildEmiItem('Total Months', '${emi.totalMonths}'),
              ),
              Expanded(
                child: _buildEmiItem('Start Date', emi.formattedStartDate),
              ),
            ],
          ),

          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildEmiItem(
                  'Total EMI Amount',
                  emi.formattedTotalEmiAmount,
                ),
              ),
              Expanded(
                child: _buildEmiItem('Paid Amount', emi.formattedPaidAmount),
              ),
              Expanded(
                child: _buildEmiItem('Remaining', emi.formattedRemainingAmount),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Customer Info for EMI
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF8B5CF6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.person, size: 16, color: Color(0xFF8B5CF6)),
                SizedBox(width: 8),
                Text(
                  'EMI Customer: ${emi.customer.displayName}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
                if (emi.customer.primaryPhone.isNotEmpty) ...[
                  Spacer(),
                  Icon(Icons.phone, size: 14, color: Color(0xFF8B5CF6)),
                  SizedBox(width: 4),
                  Text(
                    emi.customer.primaryPhone,
                    style: TextStyle(fontSize: 12, color: Color(0xFF8B5CF6)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmiItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
