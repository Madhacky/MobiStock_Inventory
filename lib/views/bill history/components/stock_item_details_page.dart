import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/bill%20history/stock_history_item_response.dart';
import 'package:smartbecho/utils/custom_appbar.dart';

class StockItemDetailsPage extends StatelessWidget {
  final StockItem stockItem;

  const StockItemDetailsPage({Key? key, required this.stockItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            buildCustomAppBar("Product Details", isdark: true),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeaderSection(),
                    _buildSpecificationsSection(),
                    if (stockItem.parsedColorImeiMapping != null) 
                      _buildImeiMappingSection(),
                    _buildPricingSection(),
                    _buildGSTSection(),
                    _buildAdditionalInfoSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getCategoryColor(stockItem.itemCategory),
            _getCategoryColor(stockItem.itemCategory).withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getCategoryColor(stockItem.itemCategory).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Category Icon
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _getCategoryIcon(stockItem.itemCategory),
              size: 48,
              color: Colors.white,
            ),
          ),
          
          SizedBox(height: 16),
          
          // Company Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              stockItem.company.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
          
          SizedBox(height: 12),
          
          // Model Name
          Text(
            stockItem.model,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 8),
          
          // Category Display
          Text(
            stockItem.categoryDisplayName,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          SizedBox(height: 16),
          
          // Quantity Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: stockItem.qty > 0 
                  ? Color(0xFF10B981) 
                  : Color(0xFFEF4444),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  stockItem.qty > 0 ? Icons.check_circle : Icons.warning,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Quantity: ${stockItem.qty}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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

  Widget _buildSpecificationsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Specifications', Icons.settings),
          SizedBox(height: 16),
          
          if (stockItem.ram > 0 && stockItem.rom > 0) ...[
            _buildSpecRow('RAM', '${stockItem.ram} GB', Icons.memory),
            Divider(height: 24),
            _buildSpecRow('Storage (ROM)', '${stockItem.rom} GB', Icons.storage),
            Divider(height: 24),
          ],
          
          _buildSpecRow('Color', stockItem.color, Icons.palette),
          
          if (stockItem.imei != null && stockItem.imei!.isNotEmpty) ...[
            Divider(height: 24),
            _buildSpecRow('IMEI', stockItem.imei!, Icons.smartphone),
          ],
          
          Divider(height: 24),
          _buildSpecRow('HSN Code', stockItem.hsnCode??"", Icons.qr_code),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Pricing Information', Icons.currency_rupee),
          SizedBox(height: 16),
          
          // Selling Price - Main highlight
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF10B981).withValues(alpha: 0.1),
                  Color(0xFF10B981).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFF10B981).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.local_offer,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selling Price',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      stockItem.formattedPrice,
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
          ),
          
          SizedBox(height: 16),
          
          _buildPriceRow(
            'Amount (Without GST)',
            stockItem.formattedWithoutGst,
            Icons.money_off,
          ),
          Divider(height: 24),
          _buildPriceRow(
            'Amount (With GST)',
            stockItem.formattedWithGst,
            Icons.attach_money,
          ),
        ],
      ),
    );
  }

  Widget _buildGSTSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('GST Information', Icons.receipt_long),
          SizedBox(height: 16),
          
          _buildInfoRow('GST Amount', stockItem.formattedGstAmount),
          Divider(height: 24),
          _buildInfoRow(
            'GST Percentage',
            '${stockItem.gstPercentage.toStringAsFixed(1)}%',
          ),
          Divider(height: 24),
          _buildInfoRow('HSN Code', stockItem.hsnCode??""),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Additional Information', Icons.info_outline),
          SizedBox(height: 16),
          
          _buildInfoRow('Shop ID', stockItem.shopId),
          Divider(height: 24),
          _buildInfoRow('Bill Item #', stockItem.billMobileItem.toString()),
          Divider(height: 24),
          _buildInfoRow('Created Date', stockItem.formattedDate),
          
          if (stockItem.description.isNotEmpty) ...[
            Divider(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    stockItem.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
          
          if (stockItem.logo.isNotEmpty && stockItem.logo != 'photo added') ...[
            Divider(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Image',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

   Widget _buildImeiMappingSection() {
    final colorImeiMap = stockItem.parsedColorImeiMapping;
    if (colorImeiMap == null) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildSectionHeader('IMEI Numbers', Icons.phone_android),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF3B82F6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${stockItem.totalImeiCount} Total',
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
          
          // Display IMEI by color
          ...colorImeiMap.entries.map((entry) {
            final colorName = entry.key;
            final imeiList = entry.value;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Color header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getColorBadgeColor(colorName).withValues(alpha: 0.15),
                        _getColorBadgeColor(colorName).withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getColorBadgeColor(colorName).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _getColorBadgeColor(colorName),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        colorName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getColorBadgeColor(colorName),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${imeiList.length}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 8),
                
                // IMEI list
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: imeiList.asMap().entries.map((imeiEntry) {
                      final index = imeiEntry.key;
                      final imei = imeiEntry.value;
                      
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _getColorBadgeColor(colorName).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _getColorBadgeColor(colorName),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                imei,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'monospace',
                                  color: Color(0xFF1E293B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.copy, size: 16),
                              color: Colors.grey[600],
                              onPressed: () {
                                // Copy to clipboard functionality
                                Get.snackbar(
                                  'Copied',
                                  'IMEI copied to clipboard',
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Color(0xFF10B981),
                                  colorText: Colors.white,
                                  margin: EdgeInsets.all(8),
                                );
                              },
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                if (colorImeiMap.entries.last.key != colorName)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

 Color _getColorBadgeColor(String colorName) {
    switch (colorName.toUpperCase()) {
      case 'RED':
        return Color(0xFFEF4444);
      case 'BLUE':
        return Color(0xFF3B82F6);
      case 'GREEN':
        return Color(0xFF10B981);
      case 'BLACK':
        return Color(0xFF1E293B);
      case 'WHITE':
        return Color(0xFF94A3B8);
      case 'GOLD':
        return Color(0xFFF59E0B);
      case 'SILVER':
        return Color(0xFF6B7280);
      case 'PINK':
        return Color(0xFFEC4899);
      case 'PURPLE':
        return Color(0xFF8B5CF6);
      case 'YELLOW':
        return Color(0xFFEAB308);
      default:
        return Color(0xFF6B7280);
    }
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF1E293B).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Color(0xFF1E293B),
            size: 20,
          ),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        SizedBox(width: 12),
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
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toUpperCase()) {
      case 'SMARTPHONE':
        return Color(0xFF3B82F6);
      case 'TABLET':
        return Color(0xFF8B5CF6);
      case 'LAPTOP':
        return Color(0xFF10B981);
      case 'ACCESSORY':
        return Color(0xFFF59E0B);
      case 'SMARTWATCH':
        return Color(0xFFEC4899);
      default:
        return Color(0xFF6B7280);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toUpperCase()) {
      case 'SMARTPHONE':
        return Icons.phone_android;
      case 'TABLET':
        return Icons.tablet;
      case 'LAPTOP':
        return Icons.laptop;
      case 'ACCESSORY':
        return Icons.headphones;
      case 'SMARTWATCH':
        return Icons.watch;
      default:
        return Icons.category;
    }
  }
}