import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/inventory%20controllers/inventory_management_controller.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/utils/common_search_field.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:smartbecho/views/dashboard/widgets/error_cards.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:smartbecho/views/inventory/widgets/invenrtory_shimmers.dart';

class InventoryManagementScreen extends StatelessWidget {
  final InventoryController controller = Get.find<InventoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: AppTheme.grey50,
=======
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
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
                      margin: EdgeInsets.only(right: index == 4 ? 0 : 12),
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
            colors: [AppTheme.backgroundLight, AppTheme.backgroundLight],
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
                    style: AppStyles.custom(
                      size: 12,
                      color: AppTheme.grey600,
                      weight: FontWeight.w500,
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
                  child: Icon(icon, color: AppTheme.backgroundLight, size: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: AppStyles.custom(
                size: 22,
                weight: FontWeight.bold,
                color: AppTheme.black87,
              ),
            ),
            SizedBox(height: 2),
            Flexible(
              child: Text(
                subtitle,
                style: AppStyles.custom(
                  size: 9,
                  color: AppTheme.grey500,
                  weight: FontWeight.w400,
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
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity08,
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Compact Header with Search and Toggle
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Header Row
                Row(
                  children: [
                    Icon(Icons.filter_list, color: Color(0xFF6C5CE7), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Filters',
                      style: AppStyles.custom(
                        size: 16,
                        weight: FontWeight.bold,
                        color: AppTheme.black87,
                      ),
                    ),
                    Spacer(),
                    // Active filters count
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
                              style: AppStyles.custom(
                                color: AppTheme.backgroundLight,
                                size: 12,
                                weight: FontWeight.bold,
                              ),
                            ),
                          )
                          : SizedBox.shrink();
                    }),
                    SizedBox(width: 8),
                    // Toggle button
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
                // Compact Search Bar
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

          // Collapsible Filters Section
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
                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
<<<<<<< HEAD
                                  child: ElevatedButton.icon(
                                    onPressed: controller.applyFilters,
                                    icon: Icon(Icons.search, size: 16),
                                    label: Text('Apply'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF6C5CE7),
                                      foregroundColor: AppTheme.backgroundLight,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
=======
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
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
          color: AppTheme.grey50,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: validSelectedValue,
            hint: Text(
              hint,
              style: AppStyles.custom(
                size: 12,
                color: Color(0xFF6C5CE7),
                weight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            items:
                uniqueOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: AppStyles.custom(size: 12),
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

  // Helper method to count active filters
  int _getActiveFiltersCount() {
    int count = 0;
    if (controller.searchQuery.value.isNotEmpty) count++;
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

  // Helper method to determine grid count based on screen size
  int _getGridCrossAxisCount() {
    if (AppConfig.screenWidth < 600) {
      return 2; // Phone - 2 columns
    } else if (AppConfig.screenWidth < 900) {
      return 3; // Small tablet - 3 columns
    } else {
      return 4; // Large tablet/desktop - 4 columns
    }
  }

  // Helper method to determine aspect ratio based on screen size
  double _getGridAspectRatio() {
    if (AppConfig.screenWidth < 600) {
      return 0.7; // Phone - taller cards
    } else {
      return 0.75; // Tablet - slightly different ratio
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
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity08,
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.grey300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
<<<<<<< HEAD
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppTheme.grey300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 150,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppTheme.grey300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppTheme.grey300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
=======
          SizedBox(height: 12),

          // Title placeholder
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
          Container(
            width: double.infinity,
            height: 16,
            decoration: BoxDecoration(
              color: AppTheme.grey300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 8),

          // Subtitle placeholder
          Container(
            width: 100,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          Spacer(),

          // Bottom row placeholder
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
          // Items count header
          _buildInventoryHeader(),

          // Scrollable inventory grid with lazy loading
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
                  // Show loading indicators at the end if there's more data
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
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.greyOpacity05,
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
                  style: AppStyles.custom(
                    size: 18,
                    weight: FontWeight.bold,
                    color: AppTheme.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
<<<<<<< HEAD
                  'Showing ${controller.inventoryItems.length} of ${controller.totalItems.value} items',
                  style: AppStyles.custom(size: 12, color: AppTheme.grey600),
=======
                  'Showing ${controller.inventoryItems.length} items',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
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
<<<<<<< HEAD
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF6C5CE7).withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<int>(
          value: controller.itemsPerPage.value,
          underline: SizedBox.shrink(),
          items:
              [10, 20, 50, 100].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value/page', style: AppStyles.custom(size: 12)),
                );
              }).toList(),
          onChanged: (int? newValue) {
            if (newValue != null) {
              controller.changeItemsPerPage(newValue);
            }
          },
        ),
      ),
=======
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
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(40),
<<<<<<< HEAD
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: AppTheme.grey400),
          SizedBox(height: 16),
          Text(
            'No inventory items found',
            style: AppStyles.custom(
              size: 18,
              weight: FontWeight.w600,
              color: AppTheme.grey600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your filters or add new items',
            style: AppStyles.custom(size: 14, color: AppTheme.grey500),
          ),
        ],
=======
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
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
      ),
    );
  }

  Widget _buildInventoryCard(item, int index) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity08,
            // color: Color(0x149E9E9E),
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
          // Top section with icon and stock badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Phone icon with gradient
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
                child: Icon(Icons.phone_android, color: AppTheme.backgroundLight, size: 20),
              ),

              _buildStockBadge(item.quantity),
            ],
          ),

          SizedBox(height: 12),

<<<<<<< HEAD
          // Phone model and company
          Text(
            item.model,
            style: AppStyles.custom(
              size: 14,
              weight: FontWeight.bold,
              color: AppTheme.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 4),

          Text(
            item.company,
            style: AppStyles.custom(
              size: 12,
              color: AppTheme.grey600,
              weight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 8),

          // Specs row
          Row(
            children: [
              Icon(Icons.memory, size: 10, color: AppTheme.grey500),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  "${item.ram}/${item.rom}",
                  style: AppStyles.custom(size: 10, color: AppTheme.grey500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 4),

          Row(
            children: [
              Icon(Icons.palette, size: 10, color: AppTheme.grey500),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.color,
                  style: AppStyles.custom(size: 10, color: AppTheme.grey500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          Spacer(),

          // Bottom section with price and stock
=======
          // Item details
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Model name
              Text(
<<<<<<< HEAD
                '₹${item.sellingPrice?.toStringAsFixed(0) ?? 'N/A'}',
                style: AppStyles.custom(
                  size: 14,
                  weight: FontWeight.bold,
                  color: Color(0xFF51CF66),
=======
                item.model,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 4),

              // Company
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

              // Specs
              Row(
                children: [
                  Icon(Icons.memory, size: 10, color: Colors.grey[500]),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "${item.ram}/${item.rom}",
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4),

              Row(
                children: [
<<<<<<< HEAD
                  Icon(Icons.inventory, size: 12, color: AppTheme.grey600),
=======
                  Icon(Icons.palette, size: 10, color: Colors.grey[500]),
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
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

          // Bottom section with price and actions
          Column(
            children: [
              // Price and stock
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${item.sellingPrice?.toStringAsFixed(0) ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF51CF66),
                    ),
                  ),
                  Text(
                    'Stock: ${item.quantity}',
                    style: AppStyles.custom(
                      size: 10,
                      color: AppTheme.grey600,
                      weight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

              // Action buttons
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
    );
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
<<<<<<< HEAD
        style: AppStyles.custom(
          size: 11,
=======
        style: TextStyle(
          fontSize: 8,
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
          color: badgeColor,
          weight: FontWeight.w600,
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

<<<<<<< HEAD
  Widget _buildPaginationControls() {
    return Obx(() {
      if (controller.totalPages.value <= 1) return SizedBox.shrink();

      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.greyOpacity05,
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed:
                  controller.currentPage.value > 0
                      ? controller.previousPage
                      : null,
              icon: Icon(Icons.chevron_left, size: 18),
              label: Text('Previous'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    controller.currentPage.value > 0
                        ? Color(0xFF6C5CE7)
                        : AppTheme.grey300,
                foregroundColor:
                    controller.currentPage.value > 0
                        ? AppTheme.backgroundLight
                        : AppTheme.grey600,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  'Page ${controller.currentPage.value + 1} of ${controller.totalPages.value}',
                  style: AppStyles.custom(
                    size: 14,
                    weight: FontWeight.w600,
                    color: AppTheme.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${controller.totalItems.value} total items',
                  style: AppStyles.custom(size: 12, color: AppTheme.grey600),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed:
                  controller.currentPage.value < controller.totalPages.value - 1
                      ? controller.nextPage
                      : null,
              icon: Icon(Icons.chevron_right, size: 18),
              label: Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    controller.currentPage.value <
                            controller.totalPages.value - 1
                        ? Color(0xFF6C5CE7)
                        : AppTheme.grey300,
                foregroundColor:
                    controller.currentPage.value <
                            controller.totalPages.value - 1
                        ? AppTheme.backgroundLight
                        : AppTheme.grey600,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

=======
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
  Widget buildFloatingActionButtons() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: Color(0xFF6C5CE7),
      foregroundColor: AppTheme.backgroundLight,
      elevation: 8,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.add, color: AppTheme.backgroundLight),
          backgroundColor: Color(0xFF51CF66),
<<<<<<< HEAD
          label: 'Add New Item',
          labelStyle: AppStyles.custom(size: 14, weight: FontWeight.w500),
=======
          label: 'Add New Mobile',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
          onTap: controller.addNewItem,
        ),
        SpeedDialChild(
          child: Icon(Icons.upload_file, color: AppTheme.backgroundLight),
          backgroundColor: Color(0xFF00CEC9),
          label: 'Bulk Upload',
          labelStyle: AppStyles.custom(size: 14, weight: FontWeight.w500),
          onTap: controller.bulkUpload,
        ),
        SpeedDialChild(
          child: Icon(Icons.download, color: AppTheme.backgroundLight),
          backgroundColor: Color(0xFFFF9500),
          label: 'Export Data',
          labelStyle: AppStyles.custom(size: 14, weight: FontWeight.w500),
          onTap: controller.exportData,
        ),
        SpeedDialChild(
<<<<<<< HEAD
          child: Icon(Icons.tune, color: AppTheme.backgroundLight),
          backgroundColor: Color(0xFF6C5CE7),
          label: 'Advanced Filters',
          labelStyle: AppStyles.custom(size: 14, weight: FontWeight.w500),
          onTap: controller.showAdvancedFilters,
=======
          child: Icon(Icons.inventory_rounded, color: Colors.white),
          backgroundColor: Color(0xFF6C5CE7),
          label: 'Add New Stock',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          onTap: controller.addNewStocks,
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
        ),
      ],
    );
  }
}
