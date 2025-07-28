import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/inventory%20controllers/inventory_management_controller.dart';
import 'package:smartbecho/models/inventory%20management/inventory_item_model.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/utils/common_search_field.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:smartbecho/views/dashboard/widgets/error_cards.dart';
import 'package:smartbecho/views/inventory/components/product_detail_page.dart';
import 'package:smartbecho/views/inventory/widgets/inventory_shimmer.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:smartbecho/views/inventory/widgets/invenrtory_shimmers.dart';

class InventoryManagementScreen extends StatelessWidget {
  final InventoryController controller = Get.find<InventoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      floatingActionButton: buildFloatingActionButtons(),
      body: SafeArea(
        child: Column(
          children: [
            buildCustomAppBar("Inventory Management", isdark: true),
            _buildStatsCards(context),
            _buildFiltersSection(),
            Expanded(child: _buildInventoryContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    return Obx(
      () =>
          controller.isSummaryCardsLoading.value
              ? buildShimmerStatList(context)
              : controller.hasSummaryCardsError.value
              ? buildErrorCard(
                controller.summaryCardsErrorMessage,
                AppConfig.screenWidth,
                AppConfig.screenHeight,
                AppConfig.isSmallScreen,
              )
              : Container(
                height: 120,
                margin: EdgeInsets.symmetric(vertical: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final stats = [
                      {
                        'title': 'Total Stock',
                        'value': controller.totalStockAvailable.toString(),
                        'subtitle': 'Total Units Available',
                        'icon': Icons.inventory_2,
                        'color': Color(0xFFFF9500),
                        'gradient': [Color(0xFFFF9500), Color(0xFFFFB347)],
                      },
                      {
                        'title': 'Total Companies',
                        'value': controller.totalCompaniesAvailable.toString(),
                        'subtitle': 'Total Brands in Store',
                        'icon': Icons.business,
                        'color': Color(0xFF00CEC9),
                        'gradient': [Color(0xFF00CEC9), Color(0xFF55E6DE)],
                      },
                      {
                        'title': 'Low Stock Alert',
                        'value': controller.lowStockAlert.toString(),
                        'subtitle': 'Low Stocks',
                        'icon': Icons.sell,
                        'color': Color(0xFFFF6B6B),
                        'gradient': [Color(0xFFFF6B6B), Color(0xFFFF9A9A)],
                      },
                      {
                        'title': 'Monthly Phone Sold',
                        'value': controller.monthlyPhoneSold,
                        'subtitle': 'Total Monthly finance',
                        'icon': Icons.trending_up,
                        'color': Color(0xFF51CF66),
                        'gradient': [Color(0xFF51CF66), Color(0xFF8CE896)],
                      },
                    ];

                    return Container(
                      width: 180,
                      margin: EdgeInsets.only(right: index == 3 ? 0 : 12),
                      child: _buildStatCard(
                        stats[index]['title'] as String,
                        stats[index]['value'].toString(),
                        stats[index]['subtitle'] as String,
                        stats[index]['icon'] as IconData,
                        stats[index]['color'] as Color,
                        stats[index]['gradient'] as List<Color>,
                      ),
                    );
                  },
                ),
              ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    List<Color> gradient,
  ) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.salesStockDashboard),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 2),
            Flexible(
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildFiltersSection() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.08),
          spreadRadius: 0,
          blurRadius: 20,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.filter_list, color: Color(0xFF6C5CE7), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Spacer(),
                  Obx(() {
                    int activeFilters = _getActiveFiltersCount();
                    return activeFilters > 0
                        ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF6C5CE7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$activeFilters',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        : SizedBox.shrink();
                  }),
                  SizedBox(width: 8),
                  Obx(
                    () => IconButton(
                      onPressed: () => controller.isFiltersExpanded.toggle(),
                      icon: Icon(
                        controller.isFiltersExpanded.value
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Color(0xFF6C5CE7),
                      ),
                    ),
                  ),
                ],
              ),
              CustomSearchWidget(
                hintText: 'Search by company name...',
                initialValue: controller.searchQuery.value,
                onChanged: (value) => controller.searchQuery.value = value,
                onClear: () => controller.searchQuery.value = '',
                primaryColor: Color(0xFF6C5CE7),
              ),
            ],
          ),
        ),
        Obx(
          () => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: controller.isFiltersExpanded.value ? null : 0,
            child:
                controller.isFiltersExpanded.value
                    ? Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: [
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            childAspectRatio: 3.5,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              _buildCompactFilterDropdown(
                                'Category',
                                controller.selectedCategory,
                                controller.categoryFilterOptions,
                                onChanged: controller.onCategoryFilterChanged,
                              ),
                              _buildCompactFilterDropdown(
                                'Model',
                                controller.selectedModel,
                                controller.filterModels,
                                onChanged: controller.onModelFilterChanged,
                              ),
                              _buildCompactFilterDropdown(
                                'RAM',
                                controller.selectedRAM,
                                controller.ramFilterOptions,
                                onChanged: controller.onRAMFilterChanged,
                              ),
                              _buildCompactFilterDropdown(
                                'Storage',
                                controller.selectedROM,
                                controller.romFilterOptions,
                                onChanged: controller.onROMFilterChanged,
                              ),
                              _buildCompactFilterDropdown(
                                'Color',
                                controller.selectedColor,
                                controller.colorFilterOptions,
                                onChanged: controller.onColorFilterChanged,
                              ),
                              _buildCompactFilterDropdown(
                                'Stock',
                                controller.selectedStockAvailability,
                                controller.stockOptions,
                                onChanged: controller.onStockFilterChanged,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: controller.clearFilters,
                                  icon: Icon(Icons.refresh, size: 16),
                                  label: Text('Clear Filters'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Color(0xFF6C5CE7),
                                    side: BorderSide(
                                      color: Color(
                                        0xFF6C5CE7,
                                      ).withOpacity(0.3),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                    : SizedBox.shrink(),
          ),
        ),
      ],
    ),
  );
}

Widget _buildCompactFilterDropdown(
  String hint,
  RxString selectedValue,
  RxList<String> options, {
  required Function(String) onChanged,
}) {
  return Obx(() {
    final uniqueOptions = ['All', ...options.toSet().toList()];
    final validSelectedValue =
        uniqueOptions.contains(selectedValue.value) &&
                selectedValue.value != hint &&
                !selectedValue.value.startsWith('Select')
            ? selectedValue.value
            : null;

    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF6C5CE7).withOpacity(0.2)),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: validSelectedValue,
          hint: Text(
            hint,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF6C5CE7),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          items:
              uniqueOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF6C5CE7),
            size: 16,
          ),
          isExpanded: true,
        ),
      ),
    );
  });
}

int _getActiveFiltersCount() {
  int count = 0;
  if (controller.searchQuery.value.isNotEmpty) count++;
  if (controller.selectedCategory.value != 'All' &&
      !controller.selectedCategory.value.startsWith('Select'))
    count++;
  if (controller.selectedModel.value != 'All' &&
      !controller.selectedModel.value.startsWith('Select'))
    count++;
  if (controller.selectedStockAvailability.value != 'All' &&
      !controller.selectedStockAvailability.value.startsWith('Select'))
    count++;
  if (controller.selectedRAM.value != 'All' &&
      !controller.selectedRAM.value.startsWith('Select'))
    count++;
  if (controller.selectedROM.value != 'All' &&
      !controller.selectedROM.value.startsWith('Select'))
    count++;
  if (controller.selectedColor.value != 'All' &&
      !controller.selectedColor.value.startsWith('Select'))
    count++;
  return count;
}

  Widget _buildInventoryContent() {
    return Obx(
      () =>
          controller.isInventoryDataLoading.value
              ? _buildShimmerCards()
              : controller.hasInventoryDataError.value
              ? buildErrorCard(
                controller.inventoryDataerrorMessage,
                AppConfig.screenWidth,
                AppConfig.screenHeight,
                AppConfig.isSmallScreen,
              )
              : _buildInventoryGrid(),
    );
  }

  int _getGridCrossAxisCount() {
    if (AppConfig.screenWidth < 600) {
      return 2;
    } else if (AppConfig.screenWidth < 900) {
      return 3;
    } else {
      return 4;
    }
  }

  double _getGridAspectRatio() {
    if (AppConfig.screenWidth < 600) {
      return 0.7;
    } else {
      return 0.75;
    }
  }

  Widget _buildShimmerCards() {
    return Container(
      margin: EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getGridCrossAxisCount(),
          childAspectRatio: _getGridAspectRatio(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => _buildShimmerCard(),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: 100,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryGrid() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInventoryHeader(),
          Expanded(
            child: Obx(() {
              if (controller.inventoryItems.isEmpty) {
                return _buildEmptyState();
              }

              return GridView.builder(
                controller: controller.scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getGridCrossAxisCount(),
                  childAspectRatio: _getGridAspectRatio(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount:
                    controller.inventoryItems.length +
                    (controller.hasMoreData.value
                        ? _getGridCrossAxisCount()
                        : 0),
                itemBuilder: (context, index) {
                  if (index >= controller.inventoryItems.length) {
                    return _buildLoadingMoreCard();
                  }

                  final item = controller.inventoryItems[index];
                  return _buildInventoryCard(item, index);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryHeader() {
    return Obx(
      () => Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inventory Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Showing ${controller.inventoryItems.length} items',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            IconButton(
              onPressed: controller.refreshData,
              icon: Icon(Icons.refresh, color: Color(0xFF6C5CE7)),
              tooltip: 'Refresh',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingMoreCard() {
    return Obx(
      () =>
          controller.isLoadingMore.value
              ? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      spreadRadius: 0,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF6C5CE7),
                    strokeWidth: 2,
                  ),
                ),
              )
              : SizedBox.shrink(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(40),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No inventory items found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try adjusting your filters or add new items',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Updated inventory card with proper InventoryItem model usage
  Widget _buildInventoryCard(InventoryItem item, int index) {
    return InkWell(
      onTap: () => _navigateToDetailedView(item),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: _getStockStatusColor(item.quantity).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Company logo or phone icon
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFF9C88FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      item.logo.isNotEmpty
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item.logo,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Icon(
                                    Icons.phone_android,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                            ),
                          )
                          : Icon(
                            Icons.phone_android,
                            color: Colors.white,
                            size: 20,
                          ),
                ),
                _buildStockBadge(item.quantity),
              ],
            ),
            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.model,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  item.company,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.memory, size: 10, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${item.ram}GB/${item.rom}GB",
                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.palette, size: 10, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.color,
                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${item.sellingPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF51CF66),
                      ),
                    ),
                    Text(
                      'Stock: ${item.quantity}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () => controller.editItem(item),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6C5CE7).withOpacity(0.1),
                            foregroundColor: Color(0xFF6C5CE7),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Icon(Icons.sell, size: 14),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 32,
                        child: ElevatedButton(
                          onPressed:
                              item.quantity == 0
                                  ? () => controller.deleteItem(
                                    item.id.toString(),
                                    index,
                                  )
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF6B6B).withOpacity(0.1),
                            foregroundColor: Color(0xFFFF6B6B),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Icon(Icons.delete, size: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Navigate to detailed view
  void _navigateToDetailedView(InventoryItem item) {
    Get.to(() => InventoryDetailScreen(item: item));
  }

  Widget _buildStockBadge(int quantity) {
    Color badgeColor = _getStockStatusColor(quantity);
    String status = _getStockStatusText(quantity);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 8,
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

  Widget buildFloatingActionButtons() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: Color(0xFF6C5CE7),
      foregroundColor: Colors.white,
      elevation: 8,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Color(0xFF51CF66),
          label: 'Add New Mobile',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          onTap: controller.addNewItem,
        ),
        SpeedDialChild(
          child: Icon(Icons.upload_file, color: Colors.white),
          backgroundColor: Color(0xFF00CEC9),
          label: 'Bulk Upload',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          onTap: controller.bulkUpload,
        ),
        SpeedDialChild(
          child: Icon(Icons.download, color: Colors.white),
          backgroundColor: Color(0xFFFF9500),
          label: 'Export Data',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          onTap: controller.exportData,
        ),
        SpeedDialChild(
          child: Icon(Icons.inventory_rounded, color: Colors.white),
          backgroundColor: Color(0xFF6C5CE7),
          label: 'Add New Stock',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          onTap: controller.addNewStocks,
        ),
      ],
    );
  }
}
