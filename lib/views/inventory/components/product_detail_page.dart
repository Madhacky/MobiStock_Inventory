import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/inventory%20controllers/inventory_management_controller.dart';
import 'package:smartbecho/models/inventory%20management/inventory_item_model.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class InventoryDetailScreen extends StatelessWidget {
  final InventoryItem item;

  const InventoryDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildCustomAppBar(),
                  _buildHeroSection(),
                  _buildQuickStats(),
                  _buildSpecificationCard(),
                  _buildPricingCard(),
                  _buildStockCard(),
                  if (item.description != null && item.description!.isNotEmpty)
                    _buildDescriptionCard(),
                  _buildActionButtons(),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cachedImage(
    String url, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? error,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) =>
            placeholder ?? const Center(child: CircularProgressIndicator()),
        errorWidget: (_, __, ___) =>
            error ?? const Center(child: Icon(Icons.broken_image)),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return buildCustomAppBar(item.company, isdark: true);
  }

  Widget _buildHeroSection() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.1),
            blurRadius: 30,
            spreadRadius: 0,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Product Image Section
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Stack(
              children: [
                item.logo.isNotEmpty
                    ? cachedImage(
                        item.logo,
                        fit: BoxFit.fill,width: AppConfig.screenWidth,
                        borderRadius: BorderRadius.circular(20),
                        placeholder: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF6C5CE7),
                            ),
                          ),
                        ),
                        error: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.phone_android,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'No Image',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone_android,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'No Image',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF6C5CE7),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF6C5CE7).withValues(alpha:0.3),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      'ID: ${item.id}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha:0.2),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      item.itemCategory,
                      style: TextStyle(
                        color: Color(0xFF6C5CE7),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Product Details Section
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.model,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF6C5CE7).withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.company,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6C5CE7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.palette, color: Colors.grey[500], size: 16),
                    SizedBox(width: 4),
                    Text(
                      item.color,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (item.createdDate != null) ...[
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.grey[500], size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Added ${_formatDate(item.createdDate!)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
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
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              '₹${item.sellingPrice.toStringAsFixed(0)}',
              'Selling Price',
              Icons.currency_rupee,
              Color(0xFF51CF66),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              '${item.quantity}',
              'In Stock',
              Icons.inventory_2,
              _getStockStatusColor(item.quantity),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              '${item.ram}GB',
              'RAM',
              Icons.memory,
              Color(0xFF00CEC9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
            blurRadius: 25,
            spreadRadius: 0,
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
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF6C5CE7).withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.phone_android, color: Color(0xFF6C5CE7)),
              ),
              SizedBox(width: 12),
              Text(
                'Technical Specifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildSpecItem(
                  'RAM',
                  '${item.ram}GB',
                  Icons.memory,
                  Color(0xFF00CEC9),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildSpecItem(
                  'Storage',
                  '${item.rom}GB',
                  Icons.storage,
                  Color(0xFFFF9500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha:0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
            blurRadius: 25,
            spreadRadius: 0,
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
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF51CF66).withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.currency_rupee, color: Color(0xFF51CF66)),
              ),
              SizedBox(width: 12),
              Text(
                'Pricing Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF51CF66), Color(0xFF8CE99A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF51CF66).withValues(alpha:0.3),
                  blurRadius: 15,
                  spreadRadius: 0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.sell, color: Colors.white.withValues(alpha:0.8), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Current Selling Price',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha:0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  '₹${item.sellingPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
            blurRadius: 25,
            spreadRadius: 0,
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
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getStockStatusColor(item.quantity).withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.inventory, color: _getStockStatusColor(item.quantity)),
              ),
              SizedBox(width: 12),
              Text(
                'Stock Management',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getStockStatusColor(item.quantity).withValues(alpha:0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _getStockStatusColor(item.quantity).withValues(alpha:0.2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Quantity',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${item.quantity}',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: _getStockStatusColor(item.quantity),
                              height: 1,
                            ),
                          ),
                          SizedBox(width: 8),
                          Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text(
                              'units',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildStockBadge(item.quantity),
              ],
            ),
          ),
          if (item.lowStockQty != null) ...[
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange, size: 16),
                SizedBox(width: 6),
                Text(
                  'Low stock alert at ${item.lowStockQty} units',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
            blurRadius: 25,
            spreadRadius: 0,
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
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF6C5CE7).withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.description, color: Color(0xFF6C5CE7)),
              ),
              SizedBox(width: 12),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            item.description!,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: item.quantity > 0 ? () {
                    Get.find<InventoryController>().sellItem(item);
                  } : null,
                  icon: Icon(Icons.point_of_sale, size: 20),
                  label: Text(
                    'Sell Item',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF51CF66),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    disabledForegroundColor: Colors.grey[500],
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    shadowColor: Color(0xFF51CF66).withValues(alpha:0.3),
                  ),
                ),
              ),
              // SizedBox(width: 12),
              // ElevatedButton(
              //   onPressed: () {
              //     // Edit item logic
              //   },
              //   child: Icon(Icons.edit, size: 20),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Color(0xFF6C5CE7),
              //     foregroundColor: Colors.white,
              //     padding: EdgeInsets.all(18),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(16),
              //     ),
              //     elevation: 0,
              //   ),
              // ),
            ],
          ),
          if (item.quantity == 0) ...[
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Delete item logic
                },
                icon: Icon(Icons.delete_forever, size: 20),
                label: Text(
                  'Delete Item',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF6B6B),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStockBadge(int quantity) {
    Color badgeColor = _getStockStatusColor(quantity);
    String status = _getStockStatusText(quantity);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withValues(alpha:0.3),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStockStatusColor(int quantity) {
    if (quantity == 0) return Color(0xFFFF6B6B);
    if (quantity <= (item.lowStockQty ?? 20)) return Color(0xFFFF9500);
    return Color(0xFF51CF66);
  }

  String _getStockStatusText(int quantity) {
    if (quantity == 0) return 'Out of Stock';
    if (quantity <= (item.lowStockQty ?? 20)) return 'Low Stock';
    return 'In Stock';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}