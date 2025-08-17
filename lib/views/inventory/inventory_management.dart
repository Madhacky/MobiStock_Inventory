import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/inventory%20controllers/inventory_management_controller.dart';
import 'package:smartbecho/models/inventory%20management/inventory_item_model.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/utils/app_colors.dart';
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
      floatingActionButton: buildAlternativeFloatingActionButtons(),
      body: SafeArea(
        child: NestedScrollView(
          controller: controller.scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              // App Bar
              buildStyledSliverAppBar(
                title: 'Inventory Management',
                isDark: false,
                onRefresh: controller.refreshData,
              ),

              // Stats Cards
              SliverToBoxAdapter(child: _buildStatsCards(context)),

              // Filters Section
              SliverToBoxAdapter(child: _buildFiltersSection()),

              // Sticky Inventory Header
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyHeaderDelegate(
                  minHeight: 80,
                  maxHeight: 80,
                  child: Container(
                    color: Colors.grey[50],
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: _buildInventoryHeader(),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: _buildInventoryGridOnly(),
          ),
        ),
      ),
    );
  }

  Widget _buildInventoryGridOnly() {
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
              : _buildInventoryGridContent(),
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
                        'value': controller.monthlyPhoneSold.toString(),
                        
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

  Widget _buildInventoryContent() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildInventoryHeader(),
          SizedBox(height: 8),
          Expanded(child: _buildInventoryGrid()),
        ],
      ),
    );
  }

  Widget _buildInventoryGrid() {
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
              : _buildInventoryGridContent(),
    );
  }

  Widget _buildInventoryGridContent() {
    return Obx(() {
      if (controller.inventoryItems.isEmpty &&
          !controller.isInventoryDataLoading.value) {
        return _buildEmptyState();
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - 100) {
            if (!controller.isLoadingMore.value &&
                controller.hasMoreData.value &&
                controller.searchQuery.value.trim().isEmpty &&
                !controller.isInventoryDataLoading.value) {
              controller.loadMoreData();
            }
          }
          return false;
        },
        child: GridView.builder(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getGridCrossAxisCount(),
            childAspectRatio: _getGridAspectRatio(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _getGridItemCount(),
          itemBuilder: (context, index) {
            if (index < controller.inventoryItems.length) {
              final item = controller.inventoryItems[index];
              return _buildInventoryCard(item, index);
            }
            return _buildLoadingMoreCard();
          },
        ),
      );
    });
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
      onTap: () => Get.toNamed(AppRoutes.salesStockDashboard ),
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
              color: color.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
          border: Border.all(color: color.withValues(alpha: 0.1)),
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
            color: Colors.grey.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Container(
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
                  int activeFilters = controller.getActiveFiltersCount();
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
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomSearchWidget(
                    hintText: 'Search items...',
                    initialValue: controller.searchQuery.value,
                    onChanged: (value) => controller.searchQuery.value = value,
                    onClear: () => controller.searchQuery.value = '',
                    primaryColor: Color(0xFF6C5CE7),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => _showFilterBottomSheet(),
                    icon: Obx(
                      () =>
                          controller.isFiltersLoading.value
                              ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Icon(Icons.tune, size: 18),
                    ),
                    label: Text('Filters'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6C5CE7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
              ],
            ),
            // Show active filters summary
            Obx(() {
              int activeFilters = _getActiveFiltersCount();
              if (activeFilters > 0) {
                return Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Filters:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (controller.selectedCompany.value.isNotEmpty)
                            _buildActiveFilterChip(
                              'Company: ${controller.selectedCompany.value}',
                            ),
                          if (controller.selectedCategory.value.isNotEmpty)
                            _buildActiveFilterChip(
                              'Category: ${controller.selectedCategory.value}',
                            ),
                          if (controller.selectedModel.value.isNotEmpty)
                            _buildActiveFilterChip(
                              'Model: ${controller.selectedModel.value}',
                            ),
                          if (controller.selectedRAM.value.isNotEmpty)
                            _buildActiveFilterChip(
                              'RAM: ${controller.selectedRAM.value}',
                            ),
                          if (controller.selectedROM.value.isNotEmpty)
                            _buildActiveFilterChip(
                              'Storage: ${controller.selectedROM.value}',
                            ),
                          if (controller.selectedColor.value.isNotEmpty)
                            _buildActiveFilterChip(
                              'Color: ${controller.selectedColor.value}',
                            ),
                          if (controller
                              .selectedStockAvailability
                              .value
                              .isNotEmpty)
                            _buildActiveFilterChip(
                              'Stock: ${controller.selectedStockAvailability.value}',
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryHeader() {
    return Obx(
      () => Container(
        margin: EdgeInsets.only(bottom: 6),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Inventory Items',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (_getActiveFiltersCount() > 0) ...[
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF6C5CE7).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Filtered',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF6C5CE7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Showing ${controller.inventoryItems.length}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      if (controller.totalItems.value >
                          controller.inventoryItems.length)
                        Text(
                          ' of ${controller.totalItems.value} items',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      if (controller.hasMoreData.value &&
                          _getActiveFiltersCount() == 0)
                        Text(
                          ' • Scroll for more',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6C5CE7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                if (controller.isLoadingMore.value)
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF6C5CE7),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
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

  int _getGridItemCount() {
    int itemCount = controller.inventoryItems.length;
    if (controller.hasMoreData.value || controller.isLoadingMore.value) {
      itemCount += _getGridCrossAxisCount();
    }
    return itemCount;
  }

  Widget _buildLoadingMoreCard() {
    return Obx(() {
      if (controller.isLoadingMore.value || controller.hasMoreData.value) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.08),
                spreadRadius: 0,
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child:
              controller.isLoadingMore.value
                  ? Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF6C5CE7),
                      strokeWidth: 2,
                    ),
                  )
                  : Container(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'Scroll to load more',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ),
                  ),
        );
      }
      return SizedBox.shrink();
    });
  }

  Widget _buildShimmerCards() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getGridCrossAxisCount(),
        childAspectRatio: _getGridAspectRatio(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => _buildShimmerCard(),
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
            color: Colors.grey.withValues(alpha: 0.08),
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
              color: Colors.grey.withValues(alpha: 0.08),
              spreadRadius: 0,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: _getStockStatusColor(item.quantity).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                          onPressed: () => controller.sellItem(item),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(
                              0xFF6C5CE7,
                            ).withValues(alpha: 0.1),
                            foregroundColor: Color(0xFF6C5CE7),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Icon(Icons.shopping_cart_rounded, size: 14),
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
                            backgroundColor: Color(
                              0xFFFF6B6B,
                            ).withValues(alpha: 0.1),
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

  void _navigateToDetailedView(InventoryItem item) {
    Get.to(() => InventoryDetailScreen(item: item));
  }

  Widget _buildStockBadge(int quantity) {
    Color badgeColor = _getStockStatusColor(quantity);
    String status = _getStockStatusText(quantity);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
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

  int _getActiveFiltersCount() {
    int count = 0;
    if (controller.searchQuery.value.isNotEmpty) count++;
    if (controller.selectedCompany.value.isNotEmpty) count++;
    if (controller.selectedCategory.value.isNotEmpty) count++;
    if (controller.selectedModel.value.isNotEmpty) count++;
    if (controller.selectedStockAvailability.value.isNotEmpty) count++;
    if (controller.selectedRAM.value.isNotEmpty) count++;
    if (controller.selectedROM.value.isNotEmpty) count++;
    if (controller.selectedColor.value.isNotEmpty) count++;
    return count;
  }

  Widget _buildActiveFilterChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFF6C5CE7).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFF6C5CE7).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: Color(0xFF6C5CE7),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Bottom sheet header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.tune, color: Color(0xFF6C5CE7), size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Filter Options',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Spacer(),
                  Obx(() {
                    int activeFilters = controller.getActiveFiltersCount();
                    return activeFilters > 0
                        ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF6C5CE7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$activeFilters Active',
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
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Filter content
            Expanded(
              child: Obx(() {
                if (controller.isFiltersLoading.value) {
                  return Container(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF6C5CE7)),
                        SizedBox(height: 16),
                        Text(
                          'Loading filters...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.hasFiltersError.value) {
                  return Container(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 48),
                        SizedBox(height: 16),
                        Text(
                          'Error Loading Filters',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          controller.filtersErrorMessage.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: controller.fetchFiltersData,
                          icon: Icon(Icons.refresh),
                          label: Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6C5CE7),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info text about cascading filters
                      Container(
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Color(0xFF6C5CE7).withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF6C5CE7).withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Color(0xFF6C5CE7),
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Select Company/Category first, then Model, then specifications',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6C5CE7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Filter Section 1: Company and Category
                      Text(
                        'Basic Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDynamicFilterDropdown(
                              'Company',
                              controller.selectedCompany,
                              controller.availableCompanies,
                              onChanged: controller.onCompanyFilterChanged,
                              filterType: 'company',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildDynamicFilterDropdown(
                              'Category',
                              controller.selectedCategory,
                              controller.availableCategories,
                              onChanged: controller.onCategoryFilterChanged,
                              filterType: 'category',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Filter Section 2: Model
                      Text(
                        'Model Selection',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildDynamicFilterDropdown(
                        'Model',
                        controller.selectedModel,
                        controller.availableModels,
                        onChanged: controller.onModelFilterChanged,
                        filterType: 'model',
                      ),
                      SizedBox(height: 20),

                      // Filter Section 3: Specifications
                      Text(
                        'Specifications',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDynamicFilterDropdown(
                              'RAM',
                              controller.selectedRAM,
                              controller.availableRAMs,
                              onChanged: controller.onRAMFilterChanged,
                              filterType: 'ram',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildDynamicFilterDropdown(
                              'Storage',
                              controller.selectedROM,
                              controller.availableROMs,
                              onChanged: controller.onROMFilterChanged,
                              filterType: 'rom',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      _buildDynamicFilterDropdown(
                        'Color',
                        controller.selectedColor,
                        controller.availableColors,
                        onChanged: controller.onColorFilterChanged,
                        filterType: 'color',
                      ),
                      SizedBox(height: 20),

                      // Show current filter path
                      Obx(() {
                        List<String> filterPath = [];
                        if (controller.selectedCompany.value.isNotEmpty) {
                          filterPath.add(controller.selectedCompany.value);
                        }
                        if (controller.selectedCategory.value.isNotEmpty) {
                          filterPath.add(controller.selectedCategory.value);
                        }
                        if (controller.selectedModel.value.isNotEmpty) {
                          filterPath.add(controller.selectedModel.value);
                        }

                        if (filterPath.isNotEmpty) {
                          return Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.filter_alt_outlined,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Current Filter Path:',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  filterPath.join(' → '),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6C5CE7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      }),
                      SizedBox(height: 100), // Extra space for bottom buttons
                    ],
                  ),
                );
              }),
            ),
            // Bottom action buttons
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        controller.clearFilters();
                        Get.back();
                      },
                      icon: Icon(Icons.refresh, size: 18),
                      label: Text('Clear All'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF6C5CE7),
                        side: BorderSide(
                          color: Color(0xFF6C5CE7).withValues(alpha: 0.3),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.applyFilters();
                        Get.back();
                      },
                      icon: Icon(Icons.search, size: 18),
                      label: Text('Apply Filters'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6C5CE7),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildDynamicFilterDropdown(
    String hint,
    RxString selectedValue,
    RxList<String> options, {
    required Function(String) onChanged,
    String filterType = '',
  }) {
    return Obx(() {
      bool isEnabled = controller.isFilterEnabled(filterType);
      bool isLoading = controller.isFilterLoading(filterType);

      // Create options list with 'All' as first option
      final List<String> dropdownOptions = ['All', ...options.toSet().toList()];

      // Determine if current selected value is valid
      final String? validSelectedValue =
          dropdownOptions.contains(selectedValue.value) &&
                  selectedValue.value.isNotEmpty &&
                  selectedValue.value != 'All'
              ? selectedValue.value
              : null;

      return Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                !isEnabled
                    ? Colors.grey.withValues(alpha: 0.3)
                    : selectedValue.value.isNotEmpty &&
                        selectedValue.value != 'All'
                    ? Color(0xFF6C5CE7)
                    : Color(0xFF6C5CE7).withValues(alpha: 0.2),
            width:
                selectedValue.value.isNotEmpty && selectedValue.value != 'All'
                    ? 1.5
                    : 1,
          ),
          borderRadius: BorderRadius.circular(10),
          color:
              !isEnabled
                  ? Colors.grey[100]
                  : selectedValue.value.isNotEmpty &&
                      selectedValue.value != 'All'
                  ? Color(0xFF6C5CE7).withValues(alpha: 0.05)
                  : Colors.grey[50],
        ),
        child:
            isLoading
                ? Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF6C5CE7),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Loading $hint...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6C5CE7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
                : DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: validSelectedValue,
                    hint: Row(
                      children: [
                        Expanded(
                          child: Text(
                            !isEnabled
                                ? '$hint (Select ${_getRequiredFilter(filterType)} first)'
                                : hint,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  !isEnabled
                                      ? Colors.grey[400]
                                      : Color(0xFF6C5CE7),
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items:
                        !isEnabled || isLoading
                            ? []
                            : dropdownOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value == 'All' ? null : value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        value == 'All'
                                            ? Colors.grey[600]
                                            : Colors.black87,
                                    fontWeight:
                                        value == 'All'
                                            ? FontWeight.normal
                                            : FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                    onChanged:
                        !isEnabled || isLoading
                            ? null
                            : (String? newValue) {
                              if (newValue == null) {
                                // 'All' was selected, clear the filter
                                onChanged('');
                              } else {
                                onChanged(newValue);
                              }
                            },
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (selectedValue.value.isNotEmpty &&
                            selectedValue.value != 'All' &&
                            isEnabled)
                          GestureDetector(
                            onTap: () => onChanged(''),
                            child: Container(
                              padding: EdgeInsets.all(2),
                              child: Icon(
                                Icons.clear,
                                color: Color(0xFF6C5CE7),
                                size: 14,
                              ),
                            ),
                          ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color:
                              !isEnabled ? Colors.grey[400] : Color(0xFF6C5CE7),
                          size: 16,
                        ),
                      ],
                    ),
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
      );
    });
  }

  String _getRequiredFilter(String filterType) {
    switch (filterType) {
      case 'model':
        return 'Company or Category';
      case 'ram':
      case 'rom':
      case 'color':
        return 'Model';
      default:
        return '';
    }
  }

 Widget buildAlternativeFloatingActionButtons() {
  return Obx(() => Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      // Scroll to Top Button (shows when scrolled down)
      if (controller.showScrollToTop.value)
        Container(
          margin: EdgeInsets.only(bottom: 16),
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF6C5CE7),
            elevation: 4,
            onPressed: controller.scrollToTop,
            heroTag: "scrollToTop",
            child: Icon(
              Icons.keyboard_arrow_up,
              size: 28,
            ),
          ),
        ),
      
      // Main Speed Dial
      SpeedDial(
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
          // SpeedDialChild(
          //   child: Icon(Icons.upload_file, color: Colors.white),
          //   backgroundColor: Color(0xFF00CEC9),
          //   label: 'Bulk Upload',
          //   labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          //   onTap: controller.bulkUpload,
          // ),
          SpeedDialChild(
            child: Icon(Icons.download, color: Colors.white),
            backgroundColor: Color(0xFFFF9500),
            label: 'Export Data',
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            onTap: null,
            //controller.exportData,
          ),
          SpeedDialChild(
            child: Icon(Icons.inventory_rounded, color: Colors.white),
            backgroundColor: Color(0xFF6C5CE7),
            label: 'Add New Stock',
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            onTap: controller.addNewStocks,
          ),
        ],
      ),
    ],
  ));
}

  Widget buildCustomAppBar(String title, {bool isdark = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: controller.refreshData,
            icon: Icon(Icons.refresh, color: Color(0xFF6C5CE7)),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }
}

// Custom delegate for sticky header
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  _StickyHeaderDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
