// pages/company_stock_details_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/inventory%20management/stock_item_model.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/utils/common_search_field.dart';
import 'package:smartbecho/utils/custom_back_button.dart';

import '../../../controllers/inventory controllers/company_stock_detail_controller.dart';

class CompanyStockDetailsPage extends StatelessWidget {
  final List<StockItem>? stockItems; // Optional - can be passed or fetched

  const CompanyStockDetailsPage({Key? key, this.stockItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.find<CompanyStockDetailsController>();
    final String companyName = Get.parameters['companyName'] ?? "";

    // Initialize with data if provided, otherwise fetch from API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (stockItems != null) {
        controller.initializeWithCompany(companyName, stockItems!);
      } else {
        controller.fetchStockItems(companyName);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(controller),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            _buildSearchAndFilterSection(controller),
            _buildStockSummaryCards(controller),
            _buildOptimizedStockItemsList(controller),
          ],
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(CompanyStockDetailsController controller) {
    return AppBar(
      backgroundColor: AppTheme.backgroundLight,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: customBackButton(isdark: true),
      ),
      automaticallyImplyLeading: false,
      title: Obx(
        () => Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: controller.getCompanyColor(controller.companyName.value),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.phone_android,
                color: AppTheme.backgroundLight,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.companyName.value.toUpperCase(),
                    style: AppStyles.custom(
                      color: const Color(0xFF1A1A1A),
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${controller.filteredItems.length} models',
                    style:  AppStyles.custom(
                      color: Color(0xFF6B7280),
                      size: 12,
                      weight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Obx(
          () => Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: controller.totalStockColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${controller.totalStock} units',
              style: AppStyles.custom(
                color: controller.totalStockColor,
                size: 12,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterSection(
    CompanyStockDetailsController controller,
  ) {
    return Container(
      color: AppTheme.backgroundLight,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar with debouncing
          CustomSearchWidget(
            hintText: 'Search models...',
            controller: controller.searchController,
            onChanged:
                (value) => controller.updateSearchQueryWithDebounce(value),
            primaryColor: Color(0xFF9CA3AF),
            backgroundColor: AppTheme.greyOpacity05,
            borderRadius: 12,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintStyle: AppStyles.custom(color: Color(0xFF9CA3AF), size: 14),
            prefixIcon: Icons.search,
          ),
          const SizedBox(height: 12),

          // Filter and Sort Row
          Row(
            children: [
              // Filter Dropdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.greyOpacity01),
                  ),
                  child: Obx(
                    () => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedFilter.value,
                        isExpanded: true,
                        icon: const Icon(Icons.filter_list, size: 18),
                        style: AppStyles.custom(
                          color: Color(0xFF374151),
                          size: 13,
                          weight: FontWeight.w500,
                        ),
                        items:
                            controller.filterOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  children: [
                                    controller.getFilterIcon(value),
                                    const SizedBox(width: 8),
                                    Text(value),
                                  ],
                                ),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.updateFilter(newValue);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Sort Dropdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.greyOpacity01),
                  ),
                  child: Obx(
                    () => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedSort.value,
                        isExpanded: true,
                        icon: const Icon(Icons.sort, size: 18),
                        style:  AppStyles.custom(
                          color: Color(0xFF374151),
                          size: 13,
                          weight: FontWeight.w500,
                        ),
                        items:
                            controller.sortOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.updateSort(newValue);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockSummaryCards(CompanyStockDetailsController controller) {
    return Container(
      color: AppTheme.backgroundLight,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Stock',
                '${controller.totalStock}',
                'units',
                const Color(0xFF3B82F6),
                Icons.inventory,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Low Stock',
                '${controller.lowStockCount}',
                'models',
                const Color(0xFFF59E0B),
                Icons.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Out of Stock',
                '${controller.outOfStockCount}',
                'models',
                const Color(0xFFEF4444),
                Icons.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    String unit,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppStyles.custom(
              color: color,
              size: 16,
              weight: FontWeight.w700,
            ),
          ),
          Text(
            unit,
            style: AppStyles.custom(
              color: color,
              size: 10,
              weight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style:  AppStyles.custom(
              color: Color(0xFF6B7280),
              size: 10,
              weight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Optimized list with lazy loading and virtualization
  Widget _buildOptimizedStockItemsList(
    CompanyStockDetailsController controller,
  ) {
    return Expanded(
      child: Obx(() {
        final displayedItems = controller.displayedItems;
        final hasMore = controller.hasMoreItems.value;

        if (displayedItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color:AppTheme.grey400),
                const SizedBox(height: 16),
                Text(
                  'No items found',
                  style: AppStyles.custom(
                    size: 16,
                    color:AppTheme.grey600,
                    weight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your search or filters',
                  style: AppStyles.custom(size: 14, color:AppTheme.grey500),
                ),
              ],
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            // Load more when near bottom
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200) {
              controller.loadMoreItems();
            }
            return false;
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            // Use cacheExtent for better scrolling performance
            cacheExtent: 1000,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount:
                hasMore ? displayedItems.length + 2 : displayedItems.length,
            itemBuilder: (context, index) {
              // Show loading indicators at bottom
              if (index >= displayedItems.length) {
                return _buildLoadingCard();
              }

              final item = displayedItems[index];
              return _buildOptimizedStockItemCard(item, controller);
            },
          ),
        );
      }),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity08,
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
        border: Border.all(color: AppTheme.greyOpacity01, width: 1),
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                   AppTheme.grey400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Optimized card widget with RepaintBoundary for better performance
  Widget _buildOptimizedStockItemCard(
    StockItem item,
    CompanyStockDetailsController controller,
  ) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.greyOpacity08,
              blurRadius: 20,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
          border: Border.all(color: AppTheme.greyOpacity01, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section with product icon and price
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: controller
                        .getCompanyColor(item.company)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: controller
                          .getCompanyColor(item.company)
                          .withOpacity(0.2),
                    ),
                  ),
                  child: Icon(
                    Icons.phone_android,
                    color: controller.getCompanyColor(item.company),
                    size: 20,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.formattedPrice,
                      style: AppStyles.custom(
                        color: Color(0xFF1A1A1A),
                        size: 14,
                        weight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: controller
                            .getStockStatusColor(item)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${item.qty}',
                        style: AppStyles.custom(
                          color: controller.getStockStatusColor(item),
                          size: 10,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Product details
            Text(
              item.model,
              style:  AppStyles.custom(
                color: Color(0xFF1A1A1A),
                size: 14,
                weight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),

            Text(
              item.ramRomDisplay,
              style:  AppStyles.custom(
                color: Color(0xFF6B7280),
                size: 11,
                weight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 6),

            // Color variant
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: controller.getColorForVariant(item.color),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.color,
                style:  AppStyles.custom(
                  color: AppTheme.backgroundLight,
                  size: 9,
                  weight: FontWeight.w600,
                ),
              ),
            ),

            const Spacer(),

            // Stock status section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: controller.getStockStatusColor(item).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: controller.getStockStatusColor(item).withOpacity(0.1),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        controller.getStockStatusIcon(item),
                        color: controller.getStockStatusColor(item),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.stockStatus,
                          style: AppStyles.custom(
                            color: controller.getStockStatusColor(item),
                            size: 10,
                            weight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 28,
                          child: ElevatedButton(
                            onPressed: () => controller.updateStock(item),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF3B82F6,
                              ).withOpacity(0.1),
                              foregroundColor: const Color(0xFF3B82F6),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.edit, size: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: SizedBox(
                          height: 28,
                          child: ElevatedButton(
                            onPressed: () => controller.sellItem(item),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF10B981,
                              ).withOpacity(0.1),
                              foregroundColor: const Color(0xFF10B981),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.shopping_cart, size: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: SizedBox(
                          height: 28,
                          child: ElevatedButton(
                            onPressed: () => controller.viewDetails(item),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF6B7280,
                              ).withOpacity(0.1),
                              foregroundColor: const Color(0xFF6B7280),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.visibility, size: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
