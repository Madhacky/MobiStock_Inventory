import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/inventory%20management/inventory_item_model.dart';
import 'package:smartbecho/utils/custom_appbar.dart';

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
            _buildcustomAppBar(),
        
                  _buildProductHeader(),
                  _buildSpecificationCard(),
                  _buildPricingCard(),
                  _buildStockCard(),
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

  Widget _buildcustomAppBar() {
    return buildCustomAppBar(item.company, isdark: true);
  }

  Widget _buildProductHeader() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.model,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      item.company,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF6C5CE7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ID: ${item.id}',
                  style: TextStyle(
                    color: Color(0xFF6C5CE7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.palette, color: Color(0xFF6C5CE7), size: 20),
              SizedBox(width: 8),
              Text(
                'Color: ${item.color}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          if (item.createdDate != null) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Color(0xFF6C5CE7), size: 20),
                SizedBox(width: 8),
                Text(
                  'Added: ${_formatDate(item.createdDate!)}',
                  style: TextStyle(
                    fontSize: 14,
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

  Widget _buildSpecificationCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.phone_android, color: Color(0xFF6C5CE7)),
              SizedBox(width: 12),
              Text(
                'Specifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.currency_rupee, color: Color(0xFF51CF66)),
              SizedBox(width: 12),
              Text(
                'Pricing',
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
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF51CF66), Color(0xFF8CE896)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selling Price',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '₹${item.sellingPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.inventory, color: _getStockStatusColor(item.quantity)),
              SizedBox(width: 12),
              Text(
                'Stock Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _getStockStatusColor(item.quantity).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getStockStatusColor(item.quantity).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Available Quantity',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${item.quantity}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _getStockStatusColor(item.quantity),
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildStockBadge(item.quantity),
                    ],
                  ),
                ),
              ),
            ],
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
              // Expanded(
              //   child: ElevatedButton.icon(
              //     onPressed: () {
              //       // Edit item logic
              //     },
              //     icon: Icon(Icons.edit),
              //     label: Text('Edit Item'),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Color(0xFF6C5CE7),
              //       foregroundColor: Colors.white,
              //       padding: EdgeInsets.symmetric(vertical: 16),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //       elevation: 0,
              //     ),
              //   ),
              // ),
              // SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Sell item logic
                  },
                  icon: Icon(Icons.sell),
                  label: Text('Sell Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF51CF66),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          if (item.quantity == 0)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Delete item logic
                },
                icon: Icon(Icons.delete),
                label: Text('Delete Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF6B6B),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStockBadge(int quantity) {
    Color badgeColor = _getStockStatusColor(quantity);
    String status = _getStockStatusText(quantity);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          color: badgeColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStockStatusColor(int quantity) {
    if (quantity == 0) return Color(0xFFFF6B6B);
    if (quantity <= 20) return Color(0xFFFF9500);
    return Color(0xFF51CF66);
  }

  String _getStockStatusText(int quantity) {
    if (quantity == 0) return 'Out of Stock';
    if (quantity <= 20) return 'Low Stock';
    return 'In Stock';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}