import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobistock/controllers/inventory_management_controller.dart';
import 'package:mobistock/services/app_config.dart';
import 'package:mobistock/utils/app_styles.dart';
import 'package:mobistock/utils/custom_appbar.dart';
import 'package:mobistock/views/dashboard/widgets/error_cards.dart';
import 'package:mobistock/views/inventory%20management/inventory_shimmer.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class InventoryManagementScreen extends StatelessWidget {
  final InventoryController controller = Get.put(InventoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: buildFloatingActionButtons(),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildCustomAppBar("Inventory Management", isdark: true),
              _buildStatsCards(),
              _buildFiltersSection(),
              SizedBox(
                height: 500, // or MediaQuery height-based
                child:Obx(()=>controller.isInventoryDataLoading.value
                        ? buildPlutoGridShimmer()
                        : controller.hasInventoryDataError.value
                        ? buildErrorCard(
                          controller.inventoryDataerrorMessage,
                          AppConfig.screenWidth,
                          AppConfig.screenHeight,
                          AppConfig.isSmallScreen,
                        )
                        : _buildPlutoGrid(),)
                    
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
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
              'value': '186',
              'subtitle': 'Total Units Available',
              'icon': Icons.inventory_2,
              'color': Color(0xFFFF9500),
            },
            {
              'title': 'Total Companies',
              'value': '19',
              'subtitle': 'Total Brands in Store',
              'icon': Icons.business,
              'color': Color(0xFF00CEC9),
            },
            {
              'title': 'Low Stock Alert',
              'value': '40',
              'subtitle': 'Models Running Low',
              'icon': Icons.warning,
              'color': Color(0xFFFF6B6B),
            },
            {
              'title': 'Phones Sold',
              'value': '67',
              'subtitle': 'Total Phones Sold',
              'icon': Icons.trending_up,
              'color': Color(0xFF51CF66),
            },
          ];

          return Container(
            width: 180,
            margin: EdgeInsets.only(right: index == 3 ? 0 : 12),
            child: _buildStatCard(
              stats[index]['title'] as String,
              stats[index]['value'] as String,
              stats[index]['subtitle'] as String,
              stats[index]['icon'] as IconData,
              stats[index]['color'] as Color,
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Fix overflow
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                // Use Flexible instead of Expanded to prevent overflow
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
              SizedBox(width: 8), // Add spacing
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          // Filter dropdowns in a scrollable row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterDropdown(
                  'Select Company',
                  controller.selectedCompany,
                  controller.companies,
                ),
                SizedBox(width: 12),
                _buildFilterDropdown(
                  'Select Model',
                  controller.selectedModel,
                  controller.models,
                ),
                SizedBox(width: 12),
                _buildFilterDropdown(
                  'Stock Status',
                  controller.selectedStockAvailability,
                  controller.stockOptions,
                ),
                SizedBox(width: 12),
                _buildFilterDropdown(
                  'Select RAM',
                  controller.selectedRAM,
                  controller.ramOptions,
                ),
                SizedBox(width: 12),
                _buildFilterDropdown(
                  'Select ROM',
                  controller.selectedROM,
                  controller.romOptions,
                ),
                SizedBox(width: 12),
                _buildFilterDropdown(
                  'Select Color',
                  controller.selectedColor,
                  controller.colorOptions,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: controller.applyFilters,
                  icon: Icon(Icons.filter_list, size: 18),
                  label: Text('Apply Filters'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6C5CE7),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.clearFilters,
                  icon: Icon(Icons.clear, size: 18),
                  label: Text('Clear Filters'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF6C5CE7),
                    side: BorderSide(color: Color(0xFF6C5CE7)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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

  Widget _buildFilterDropdown(
    String hint,
    RxString selectedValue,
    RxList<String> options,
  ) {
    return Obx(() {
      // Remove duplicates from options and ensure uniqueness
      final uniqueOptions = options.toSet().toList();

      // Check if selected value exists in options
      final validSelectedValue =
          uniqueOptions.contains(selectedValue.value) &&
                  selectedValue.value != hint &&
                  !selectedValue.value.startsWith('Select')
              ? selectedValue.value
              : null;

      return Container(
        width: 140,
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF6C5CE7).withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: validSelectedValue,
            hint: Text(
              hint,
              style: TextStyle(fontSize: 12, color: Color(0xFF6C5CE7)),
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
                selectedValue.value = newValue;
              }
            },
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF6C5CE7),
              size: 18,
            ),
            isExpanded: true,
          ),
        ),
      );
    });
  }

  Widget buildFloatingActionButtons() {
    return SpeedDial(
      icon: Icons.menu,
      activeIcon: Icons.close,
      backgroundColor: Color(0xFF6C5CE7),
      foregroundColor: Colors.white,
      children: [
        SpeedDialChild(
          child: Icon(Icons.add),
          label: 'Add New Stock',
          onTap: controller.addNewStock,
          backgroundColor: Color(0xFF6C5CE7),
        ),
        SpeedDialChild(
          child: Icon(Icons.upload),
          label: 'Bulk Upload',
          onTap: controller.bulkUpload,
          backgroundColor: Color(0xFF00CEC9),
        ),
        SpeedDialChild(
          child: Icon(Icons.download),
          label: 'Export',
          onTap: controller.exportData,
          backgroundColor: Colors.grey[200],
          labelStyle: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildPlutoGrid() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return Container(
            height: 350,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF6C5CE7),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading inventory data...',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: PlutoGrid(
            columns: controller.columns,
            rows: controller.rows,
            onLoaded: controller.onLoaded,
            configuration: PlutoGridConfiguration(
              style: PlutoGridStyleConfig(
                gridBackgroundColor: Colors.white,
                rowColor: Colors.white,
                oddRowColor: Colors.grey[25],
                activatedColor: Color(0xFF6C5CE7).withOpacity(0.1),
                checkedColor: Color(0xFF6C5CE7).withOpacity(0.2),
                columnTextStyle: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                cellTextStyle: TextStyle(color: Colors.black87, fontSize: 12),
                columnHeight: 48,
                rowHeight: 52,
                defaultColumnTitlePadding: EdgeInsets.symmetric(horizontal: 16),
                defaultCellPadding: EdgeInsets.symmetric(horizontal: 16),
                gridBorderColor: Colors.grey[200]!,
                borderColor: Colors.grey[200]!,
                activatedBorderColor: Color(0xFF6C5CE7),
                inactivatedBorderColor: Colors.grey[300]!,
                columnFilterHeight: 40,
              ),
              columnFilter: PlutoGridColumnFilterConfig(
                filters: const [...FilterHelper.defaultFilters],
                resolveDefaultColumnFilter: (column, resolver) {
                  if (column.field == 'id') {
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  } else if (column.field == 'sellingPrice') {
                    return resolver<PlutoFilterTypeGreaterThan>()
                        as PlutoFilterType;
                  } else if (column.field == 'quantity') {
                    return resolver<PlutoFilterTypeGreaterThan>()
                        as PlutoFilterType;
                  }
                  return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                },
              ),
            ),
            createHeader: (stateManager) {
              return Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFF6C5CE7).withOpacity(0.05),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.inventory_2, color: Color(0xFF6C5CE7), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Inventory Data',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF6C5CE7).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Showing ${stateManager.refRows.length} entries',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6C5CE7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            // Add this to your PlutoGrid widget
            createFooter: (stateManager) {
              return Container(
                height: 120,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Check if we have enough space for full layout
                    bool isCompact = constraints.maxWidth < 600;

                    if (isCompact) {
                      // Compact layout for smaller screens
                      return Column(
                        children: [
                          // First row: Items per page
                          Row(
                            children: [
                              Text(
                                'Items per page:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(width: 8),
                              Obx(
                                () => Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      value: controller.itemsPerPage.value,
                                      items:
                                          [10, 25, 50, 100].map((int value) {
                                            return DropdownMenuItem<int>(
                                              value: value,
                                              child: Text(
                                                value.toString(),
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            );
                                          }).toList(),
                                      onChanged: (int? newValue) {
                                        if (newValue != null) {
                                          controller.onPageSizeChanged(
                                            newValue,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              // Show only current page info in compact mode
                              Obx(() {
                                if (controller.totalItems == 0) {
                                  return Text(
                                    'No items',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  );
                                }
                                return Text(
                                  'Page ${controller.currentPage.value + 1} of ${controller.totalPages}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                );
                              }),
                            ],
                          ),
                          SizedBox(height: 4),
                          // Second row: Navigation controls
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Previous button
                                IconButton(
                                  icon: Icon(Icons.chevron_left, size: 18),
                                  onPressed:
                                      controller.currentPage.value > 0
                                          ? controller.previousPage
                                          : null,
                                  color:
                                      controller.currentPage.value > 0
                                          ? Colors.grey[700]
                                          : Colors.grey[400],
                                  constraints: BoxConstraints(
                                    minWidth: 28,
                                    minHeight: 28,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),

                                // Show fewer page numbers in compact mode
                                ...List.generate(
                                  (controller.totalPages).clamp(0, 3),
                                  (index) {
                                    int pageNum =
                                        controller.currentPage.value == 0
                                            ? index
                                            : (controller.currentPage.value -
                                                    1 +
                                                    index)
                                                .clamp(
                                                  0,
                                                  controller.totalPages - 1,
                                                );

                                    if (pageNum >= controller.totalPages)
                                      return SizedBox.shrink();

                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 1,
                                      ),
                                      child: TextButton(
                                        onPressed:
                                            () => controller.goToPage(pageNum),
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              pageNum ==
                                                      controller
                                                          .currentPage
                                                          .value
                                                  ? Color(0xFF6C5CE7)
                                                  : Colors.transparent,
                                          minimumSize: Size(28, 28),
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          '${pageNum + 1}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color:
                                                pageNum ==
                                                        controller
                                                            .currentPage
                                                            .value
                                                    ? Colors.white
                                                    : Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // Next button
                                IconButton(
                                  icon: Icon(Icons.chevron_right, size: 18),
                                  onPressed:
                                      controller.currentPage.value <
                                              controller.totalPages - 1
                                          ? controller.nextPage
                                          : null,
                                  color:
                                      controller.currentPage.value <
                                              controller.totalPages - 1
                                          ? Colors.grey[700]
                                          : Colors.grey[400],
                                  constraints: BoxConstraints(
                                    minWidth: 28,
                                    minHeight: 28,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    // Full layout for larger screens
                    return Row(
                      children: [
                        // Items per page selector
                        Text(
                          'Items:',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 8),
                        Obx(
                          () => Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: controller.itemsPerPage.value,
                                items:
                                    [10, 25, 50, 100].map((int value) {
                                      return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(
                                          value.toString(),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (int? newValue) {
                                  if (newValue != null) {
                                    controller.onPageSizeChanged(newValue);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),

                        Spacer(),

                        // Pagination info and controls
                        Obx(() {
                          if (controller.totalItems == 0) {
                            return Text(
                              'No items to display',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            );
                          }

                          int startItem =
                              (controller.currentPage.value *
                                  controller.itemsPerPage.value) +
                              1;
                          int endItem = ((controller.currentPage.value + 1) *
                                  controller.itemsPerPage.value)
                              .clamp(0, controller.totalItems);

                          return Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Showing $startItem-$endItem of ${controller.totalItems} entries',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 16),

                                // Previous button
                                IconButton(
                                  icon: Icon(Icons.chevron_left, size: 20),
                                  onPressed:
                                      controller.currentPage.value > 0
                                          ? controller.previousPage
                                          : null,
                                  color:
                                      controller.currentPage.value > 0
                                          ? Colors.grey[700]
                                          : Colors.grey[400],
                                  constraints: BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),

                                // Page numbers (limit based on available space)
                                ...List.generate(
                                  (controller.totalPages).clamp(
                                    0,
                                    constraints.maxWidth > 800 ? 5 : 3,
                                  ),
                                  (index) {
                                    int pageNum =
                                        controller.currentPage.value < 2
                                            ? index
                                            : controller.currentPage.value -
                                                2 +
                                                index;

                                    if (pageNum >= controller.totalPages)
                                      return SizedBox.shrink();

                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      child: TextButton(
                                        onPressed:
                                            () => controller.goToPage(pageNum),
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              pageNum ==
                                                      controller
                                                          .currentPage
                                                          .value
                                                  ? Color(0xFF6C5CE7)
                                                  : Colors.transparent,
                                          minimumSize: Size(32, 32),
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          '${pageNum + 1}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                pageNum ==
                                                        controller
                                                            .currentPage
                                                            .value
                                                    ? Colors.white
                                                    : Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // Next button
                                IconButton(
                                  icon: Icon(Icons.chevron_right, size: 20),
                                  onPressed:
                                      controller.currentPage.value <
                                              controller.totalPages - 1
                                          ? controller.nextPage
                                          : null,
                                  color:
                                      controller.currentPage.value <
                                              controller.totalPages - 1
                                          ? Colors.grey[700]
                                          : Colors.grey[400],
                                  constraints: BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
