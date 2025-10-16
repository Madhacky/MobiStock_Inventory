// views/online_products/product_details_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/bill%20history%20controllers/online_product_added_controller.dart';
import 'package:smartbecho/models/bill%20history/online_added_product_model.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnlineProductsController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: controller.getCategoryColor(product.itemCategory),
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.3),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      controller.getCategoryColor(product.itemCategory),
                      controller.getCategoryColor(product.itemCategory).withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Product Image
                    Center(
                      child: product.logo.isNotEmpty
                          ? Image.network(
                              product.logo,
                              height: 200,
                              width: 200,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  controller.getCategoryIcon(product.itemCategory),
                                  size: 120,
                                  color: Colors.white.withValues(alpha: 0.3),
                                );
                              },
                            )
                          : Icon(
                              controller.getCategoryIcon(product.itemCategory),
                              size: 120,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                    ),
                    // Category Badge
                    Positioned(
                      top: 100,
                      left: 16,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              controller.getCategoryIcon(product.itemCategory),
                              size: 14,
                              color: controller.getCategoryColor(product.itemCategory),
                            ),
                            SizedBox(width: 6),
                            Text(
                              product.categoryDisplayName,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: controller.getCategoryColor(product.itemCategory),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Stock Badge
                    Positioned(
                      top: 100,
                      right: 16,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: product.qty > 0 ? Color(0xFF10B981) : Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              product.qty > 0 ? Icons.check_circle : Icons.warning,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              product.qty > 0 ? 'In Stock' : 'Out of Stock',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Header
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Company Name
                        Text(
                          product.company.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: controller.getCategoryColor(product.itemCategory),
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 8),
                        
                        // Model Name
                        Text(
                          product.model,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Price
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFF10B981).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFF10B981).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Selling Price',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                product.formattedPrice,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12),

                  // Specifications Section
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: Color(0xFF1E293B),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Specifications',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        
                        if (product.ram.isNotEmpty)
                          _buildDetailRow('RAM', product.ram, Icons.memory),
                        
                        if (product.rom.isNotEmpty)
                          _buildDetailRow('Storage', product.rom, Icons.storage),
                        
                        _buildDetailRow('Color', product.color, Icons.palette),
                        
                        _buildDetailRow('Quantity', '${product.qty}', Icons.inventory_2),
                        
                        if (product.imei != null && product.imei!.isNotEmpty)
                          _buildDetailRow('IMEI', product.imei!, Icons.qr_code, copyable: true),
                      ],
                    ),
                  ),

                  SizedBox(height: 12),

                  // Purchase Information
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 20,
                              color: Color(0xFF1E293B),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Purchase Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        
                        _buildDetailRow('Purchased From', product.purchasedFrom, Icons.person),
                        
                        if (product.purchaseContact != null && product.purchaseContact!.isNotEmpty)
                          _buildDetailRow('Contact', product.purchaseContact!, Icons.phone, copyable: true),
                        
                        _buildDetailRow('Purchase Date', product.formattedDate, Icons.calendar_today),
                        
                        _buildDetailRow('Created Date', product.formattedDate, Icons.event),
                        
                        if (product.purchaseNotes.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(height: 24),
                              Row(
                                children: [
                                  Icon(Icons.note, size: 16, color: Colors.grey[600]),
                                  SizedBox(width: 8),
                                  Text(
                                    'Purchase Notes',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  product.purchaseNotes,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[800],
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  // Product ID and Shop ID
                  if (product.shopId.isNotEmpty || product.id > 0)
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.badge_outlined,
                                size: 20,
                                color: Color(0xFF1E293B),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'System Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          
                          _buildDetailRow('Product ID', '#${product.id}', Icons.tag, copyable: true),
                          
                          if (product.shopId.isNotEmpty)
                            _buildDetailRow('Shop ID', product.shopId, Icons.store, copyable: true),
                        ],
                      ),
                    ),

                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, {bool copyable = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: Colors.grey[600],
            ),
          ),
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
                    color: Color(0xFF1E293B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (copyable)
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                Get.snackbar(
                  'Copied',
                  '$label copied to clipboard',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: Duration(seconds: 2),
                  backgroundColor: Color(0xFF10B981),
                  colorText: Colors.white,
                  margin: EdgeInsets.all(8),
                );
              },
              icon: Icon(Icons.copy, size: 16),
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey[100],
                foregroundColor: Colors.grey[600],
                padding: EdgeInsets.all(8),
              ),
              tooltip: 'Copy $label',
            ),
        ],
      ),
    );
  }
}