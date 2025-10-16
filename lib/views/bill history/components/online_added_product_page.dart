// views/online_products/online_products_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/bill%20history%20controllers/online_product_added_controller.dart';
import 'package:smartbecho/models/bill%20history/online_added_product_model.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:smartbecho/utils/custom_dropdown.dart';
import 'package:smartbecho/views/bill%20history/components/online_added_product_details_page.dart';

class OnlineProductsPage extends GetView<OnlineProductsController> {
  const OnlineProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            buildCustomAppBar("Online Added Products", isdark: true),
            
            // Loading indicator
            Obx(
              () => controller.isLoading.value && controller.products.isEmpty
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.grey[200],
                      color: Color(0xFF1E293B),
                    )
                  : SizedBox.shrink(),
            ),
            
            // Stats section
            _buildStatsSection(),
            
            // Filter button
            _buildFilterButton(context),
            
            // Products grid with lazy loading
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 200 &&
                      !controller.isLoadingMore.value &&
                      !controller.isLoading.value) {
                    controller.loadMoreProducts();
                  }
                  return false;
                },
                child: _buildProductsGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return Container(
            height: 80,
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1E293B),
                strokeWidth: 2,
              ),
            ),
          );
        }

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Products',
                controller.totalElements.value.toString(),
                Icons.inventory_2,
                Color(0xFF3B82F6),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Categories',
                controller.categoryOptions.length > 1 
                    ? (controller.categoryOptions.length - 1).toString()
                    : '1',
                Icons.category,
                Color(0xFF10B981),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Brands',
                controller.brandOptions.length > 1 
                    ? (controller.brandOptions.length - 1).toString()
                    : '0',
                Icons.business,
                Color(0xFF8B5CF6),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showFilterBottomSheet(context),
              icon: Icon(Icons.filter_list, size: 18),
              label: Obx(() {
                String filterText = 'Filter & Sort';
                List<String> activeFilters = [];
                
                if (controller.selectedBrand.value != 'All') {
                  activeFilters.add(controller.selectedBrand.value);
                }
                
                if (controller.selectedCategory.value != 'All') {
                  activeFilters.add(controller.selectedCategory.value);
                }
                
                if (activeFilters.isNotEmpty) {
                  filterText = activeFilters.join(' • ');
                }
                
                return Text(
                  filterText,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                );
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E293B),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: IconButton(
              onPressed: () => controller.refreshProducts(),
              icon: Obx(() => controller.isLoading.value
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF1E293B),
                      ),
                    )
                  : Icon(Icons.refresh, color: Color(0xFF1E293B))),
              tooltip: 'Refresh',
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'Filter & Sort Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Category and Brand Row
              Row(
                children: [
                  Expanded(
                    child: Obx(() => buildStyledDropdown(
                      labelText: 'Category',
                      hintText: 'Select Category',
                      value: controller.selectedCategory.value == 'All' 
                          ? null 
                          : controller.selectedCategory.value,
                      items: controller.categoryOptions,
                      onChanged: controller.onCategoryChanged,
                    )),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => buildStyledDropdown(
                      labelText: 'Brand',
                      hintText: 'Select Brand',
                      value: controller.selectedBrand.value == 'All' 
                          ? null 
                          : controller.selectedBrand.value,
                      items: controller.brandOptions,
                      onChanged: controller.onBrandChanged,
                    )),
                  ),
                ],
              ),
              
              SizedBox(height: 16),
              
              // Model dropdown
              Obx(() => buildStyledDropdown(
                labelText: 'Model',
                hintText: 'Select Model',
                value: controller.selectedModel.value == 'All' 
                    ? null 
                    : controller.selectedModel.value,
                items: controller.modelOptions,
                onChanged: controller.onModelChanged,
              )),
              
              SizedBox(height: 16),
              
              // RAM and ROM Row
              Row(
                children: [
                  Expanded(
                    child: Obx(() => buildStyledDropdown(
                      labelText: 'RAM',
                      hintText: 'Select RAM',
                      value: controller.selectedRam.value == 'All' 
                          ? null 
                          : controller.selectedRam.value,
                      items: controller.ramOptions,
                      onChanged: controller.onRamChanged,
                    )),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => buildStyledDropdown(
                      labelText: 'ROM',
                      hintText: 'Select ROM',
                      value: controller.selectedRom.value == 'All' 
                          ? null 
                          : controller.selectedRom.value,
                      items: controller.romOptions,
                      onChanged: controller.onRomChanged,
                    )),
                  ),
                ],
              ),
              
              SizedBox(height: 16),
              
              // Color dropdown
              Obx(() => buildStyledDropdown(
                labelText: 'Color',
                hintText: 'Select Color',
                value: controller.selectedColor.value == 'All' 
                    ? null 
                    : controller.selectedColor.value,
                items: controller.colorOptions,
                onChanged: controller.onColorChanged,
              )),
              
              SizedBox(height: 16),
              
              // Sort Option
              Obx(() => buildStyledDropdown(
                labelText: 'Sort By',
                hintText: 'Select Sort Field',
                value: controller.sortBy.value,
                items: controller.sortOptions,
                onChanged: (value) => controller.onSortChanged(value ?? 'createdDate'),
                suffixIcon: Icon(
                  controller.sortOrder.value == 'asc' 
                      ? Icons.arrow_upward 
                      : Icons.arrow_downward,
                  size: 16,
                  color: Color(0xFF1E293B),
                ),
              )),
              
              SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.resetFilters,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF1E293B),
                        side: BorderSide(color: Color(0xFF1E293B)),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Reset'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1E293B),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Apply'),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildProductsGrid() {
    return Obx(() {
      if (controller.error.value.isNotEmpty && controller.products.isEmpty) {
        return _buildErrorState();
      }

      if (controller.isLoading.value && controller.products.isEmpty) {
        return _buildLoadingState();
      }

      if (controller.products.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: controller.refreshProducts,
        color: Color(0xFF1E293B),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemCount: controller.products.length + 
                (controller.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.products.length) {
                return _buildLoadingMoreIndicator();
              }

              final product = controller.products[index];
              return _buildProductCard(product);
            },
          ),
        ),
      );
    });
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ProductDetailsPage(product: product),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 300),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              spreadRadius: 0,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: controller.getCategoryColor(product.itemCategory)
                .withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    controller.getCategoryColor(product.itemCategory)
                        .withValues(alpha: 0.1),
                    controller.getCategoryColor(product.itemCategory)
                        .withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  // Product logo/image
                  Center(
                    child: product.logo.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.logo,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  controller.getCategoryIcon(product.itemCategory),
                                  size: 60,
                                  color: controller.getCategoryColor(product.itemCategory),
                                );
                              },
                            ),
                          )
                        : Icon(
                            controller.getCategoryIcon(product.itemCategory),
                            size: 60,
                            color: controller.getCategoryColor(product.itemCategory),
                          ),
                  ),
                  // Category badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: controller.getCategoryColor(product.itemCategory),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            controller.getCategoryIcon(product.itemCategory),
                            size: 10,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            product.categoryDisplayName,
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Quantity badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: product.qty > 0 ? Color(0xFF10B981) : Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Qty: ${product.qty}',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company name
                    Text(
                      product.company.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),

                    // Model name
                    Text(
                      product.model,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 8),

                    // Specifications
                    if (product.ramRomDisplay.isNotEmpty) ...[
                      _buildSpecRow(Icons.memory, product.ramRomDisplay),
                      SizedBox(height: 4),
                    ],
                    
                    _buildSpecRow(Icons.palette, product.color),

                    Spacer(),

                    // Price
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF10B981).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            product.formattedPrice,
                            style: TextStyle(
                              fontSize: 14,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 11, color: Colors.grey[500]),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFF1E293B),
            strokeWidth: 2,
          ),
          SizedBox(height: 16),
          Text(
            'Loading products...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => controller.loadProducts(refresh: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E293B),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.error.value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => controller.loadProducts(refresh: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E293B),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF1E293B),
          strokeWidth: 2,
        ),
      ),
    );
  }
}