import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/bill%20history%20controllers/bill_history_controller.dart';
import 'package:smartbecho/models/bill%20history/stock_history_item_response.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/utils/common_date_feild.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:smartbecho/utils/custom_dropdown.dart';

class StockHistoryPage extends GetView<BillHistoryController> {
  
  const StockHistoryPage({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            buildCustomAppBar("Stock History", isdark: true),
            
            // Loading indicator
            Obx(
              () => controller.isLoadingStock.value && controller.stockItems.isEmpty
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.grey[200],
                      color: Color(0xFF1E293B),
                    )
                  : SizedBox.shrink(),
            ),
            
            // Stats section
            _buildStatsSection(),
            
            // Search bar
            _buildSearchBar(),
            
            // Filter button
            _buildFilterButton(context),
            
            // Stock items grid with lazy loading
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 200 &&
                      !controller.isLoadingMoreStock.value &&
                      !controller.isLoadingStock.value) {
                    controller.loadMoreStockItems();
                  }
                  return false;
                },
                child: _buildStockItemsGrid(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addNewStock),
        backgroundColor: Color(0xFF1E293B),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Obx(() {
        if (controller.isLoadingStock.value && controller.stockItems.isEmpty) {
          return Container(
            height: 120,
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1E293B),
                strokeWidth: 2,
              ),
            ),
          );
        }

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Items',
                    controller.totalStockItems.value.toString(),
                    Icons.inventory_2,
                    Color(0xFF3B82F6),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Total Qty',
                    controller.totalQtyAdded.value.toString(),
                    Icons.add_box,
                    Color(0xFF10B981),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Companies',
                    controller.totalDistinctCompanies.value.toString(),
                    Icons.business,
                    Color(0xFF8B5CF6),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Categories',
                    controller.categoryOptions.length > 1 
                        ? (controller.categoryOptions.length - 1).toString()
                        : '0',
                    Icons.category,
                    Color(0xFFF59E0B),
                  ),
                ),
              ],
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
            color: Colors.grey.withValues(alpha:0.05),
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

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha:0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: (value) {
          // Debounce search
          Future.delayed(Duration(milliseconds: 500), () {
            if (controller.searchController.text == value) {
              controller.onSearchChanged(value);
            }
          });
        },
        decoration: InputDecoration(
          hintText: 'Search by model, company, or description...',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          suffixIcon: Obx(() => controller.searchKeyword.value.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    controller.searchController.clear();
                    controller.onSearchChanged('');
                  },
                  icon: Icon(Icons.clear, color: Colors.grey[400]),
                )
              : SizedBox.shrink()),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
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
                
                if (controller.selectedStockCompany.value != 'All') {
                  activeFilters.add(controller.selectedStockCompany.value);
                }
                
                if (controller.selectedCategory.value != 'All') {
                  activeFilters.add(controller.selectedCategory.value.replaceAll('_', ' '));
                }
                
                if (controller.stockTimePeriodType.value == 'Month/Year') {
                  activeFilters.add('${controller.getMonthName(controller.stockSelectedMonth.value)} ${controller.stockSelectedYear.value}');
                } else if (controller.stockTimePeriodType.value == 'Custom Date' && 
                           controller.stockStartDate.value != null && controller.stockEndDate.value != null) {
                  activeFilters.add('Custom Range');
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
              border: Border.all(color: Colors.grey.withValues(alpha:0.2)),
            ),
            child: IconButton(
              onPressed: () => controller.refreshStockItems(),
              icon: Obx(() => controller.isLoadingStock.value
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  'Filter & Sort Stock',
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
                    backgroundColor: Colors.grey.withValues(alpha:0.1),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            // Company and Category Row
            Row(
              children: [
                Expanded(
                  child: Obx(() => buildStyledDropdown(
                    labelText: 'Company',
                    hintText: 'Select Company',
                    value: controller.selectedStockCompany.value == 'All' ? null : controller.selectedStockCompany.value,
                    items: controller.stockCompanyOptions,
                    onChanged: controller.onStockCompanyChanged,
                  )),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Obx(() => buildStyledDropdown(
                    labelText: 'Category',
                    hintText: 'Select Category',
                    value: controller.selectedCategory.value == 'All' ? null : controller.selectedCategory.value,
                    items: controller.categoryOptions,
                    onChanged: controller.onCategoryChanged,
                  )),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            // Time Period Selection
            Obx(() => buildStyledDropdown(
              labelText: 'Time Period',
              hintText: 'Select Period',
              value: controller.stockTimePeriodType.value,
              items: controller.timePeriodOptions,
              onChanged: controller.onStockTimePeriodTypeChanged,
            )),
            
            SizedBox(height: 16),
            
            // Date Selection based on Time Period Type
            Obx(() {
              if (controller.stockTimePeriodType.value == 'Month/Year') {
                return _buildStockMonthYearSelection();
              } else {
                return _buildStockCustomDateSelection(context);
              }
            }),
            
            SizedBox(height: 16),
            
            // Sort Option
            Obx(() => buildStyledDropdown(
              labelText: 'Sort By',
              hintText: 'Select Sort Field',
              value: controller.stockSortBy.value,
              items: controller.stockSortOptions,
              onChanged: (value) => controller.onStockSortChanged(value ?? 'createdDate'),
              suffixIcon: Icon(
                controller.stockSortDir.value == 'asc' 
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
                    onPressed: controller.resetStockFilters,
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
            
            SizedBox(height: MediaQuery.of(Get.context!).viewInsets.bottom),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }



  Widget _buildStockMonthYearSelection() {
    return Row(
      children: [
        Expanded(
          child: Obx(() => buildStyledDropdown(
            labelText: 'Month',
            hintText: 'Select Month',
            value: controller.getMonthName(controller.stockSelectedMonth.value),
            items: List.generate(12, (index) => controller.getMonthName(index + 1)),
            onChanged: (value) {
              if (value != null) {
                final monthIndex = List.generate(12, (index) => controller.getMonthName(index + 1))
                    .indexOf(value) + 1;
                controller.onStockMonthChanged(monthIndex);
              }
            },
          )),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Obx(() => buildStyledDropdown(
            labelText: 'Year',
            hintText: 'Select Year',
            value: controller.stockSelectedYear.value.toString(),
            items: List.generate(6, (index) => (2020 + index).toString()).reversed.toList(),
            onChanged: (value) => controller.onStockYearChanged(int.tryParse(value ?? '')),
          )),
        ),
      ],
    );
  }

  Widget _buildStockCustomDateSelection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: buildDateField(
            labelText: 'Start Date',
            controller: controller.stockStartDateController,
            onTap: () => _selectStockDate(context, true),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: buildDateField(
            labelText: 'End Date',
            controller: controller.stockEndDateController,
            onTap: () => _selectStockDate(context, false),
          ),
        ),
      ],
    );
  }

 

  Future<void> _selectStockDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF1E293B),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isStartDate) {
        controller.onStockStartDateChanged(picked);
      } else {
        controller.onStockEndDateChanged(picked);
      }
    }
  }

 

  Widget _buildStockItemsGrid() {
    return Obx(() {
      if (controller.stockError.value.isNotEmpty && controller.stockItems.isEmpty) {
        return _buildErrorState();
      }

      if (controller.isLoadingStock.value && controller.stockItems.isEmpty) {
        return _buildLoadingState();
      }

      if (controller.stockItems.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: controller.refreshStockItems,
        color: Color(0xFF1E293B),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: controller.stockItems.length + (controller.isLoadingMoreStock.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.stockItems.length) {
                return _buildLoadingMoreIndicator();
              }

              final stockItem = controller.stockItems[index];
              return _buildStockItemCard(stockItem);
            },
          ),
        ),
      );
    });
  }

  Widget _buildStockItemCard(StockItem stockItem) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
            spreadRadius: 0,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: controller.getCategoryColor(stockItem.itemCategory).withValues(alpha:0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with category and company
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  controller.getCategoryColor(stockItem.itemCategory).withValues(alpha:0.1),
                  controller.getCategoryColor(stockItem.itemCategory).withValues(alpha:0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: controller.getCategoryColor(stockItem.itemCategory),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    controller.getCategoryIcon(stockItem.itemCategory),
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stockItem.categoryDisplayName,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: controller.getCategoryColor(stockItem.itemCategory),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        stockItem.company.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildQuantityBadge(stockItem),
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
                  // Model name
                  Text(
                    stockItem.model,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 8),

                  // Specifications
                  if (stockItem.ramRomDisplay.isNotEmpty) ...[
                    _buildSpecRow(Icons.memory, stockItem.ramRomDisplay),
                    SizedBox(height: 4),
                  ],
                  
                  _buildSpecRow(Icons.palette, stockItem.color),
                  SizedBox(height: 4),
                  
                  // Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
                      SizedBox(width: 4),
                      Text(
                        stockItem.formattedDate,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  Spacer(),

                  // Price and bill reference
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.currency_rupee, size: 12, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              'Price',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                            Spacer(),
                            Text(
                              stockItem.formattedPrice,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.receipt, size: 10, color: Colors.grey[500]),
                            SizedBox(width: 4),
                            Text(
                              'Bill #${stockItem.billMobileItem}',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[500],
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
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.grey[500]),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityBadge(StockItem stockItem) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: stockItem.qty > 0 ? Color(0xFF10B981) : Color(0xFFEF4444),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            stockItem.qty > 0 ? Icons.check_circle : Icons.warning,
            size: 8,
            color: Colors.white,
          ),
          SizedBox(width: 2),
          Text(
            'Qty: ${stockItem.qty}',
            style: TextStyle(
              fontSize: 8,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
            'Loading stock items...',
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
            'No stock items found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => controller.loadStockItems(refresh: true),
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
          Text(
            controller.stockError.value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => controller.loadStockItems(refresh: true),
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