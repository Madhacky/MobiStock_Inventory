import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/customer%20controllers/customer_card_view_controller.dart';
import 'package:smartbecho/models/customer%20management/customer_data_model.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/utils/custom_appbar.dart';

class CustomerDetailsPage extends StatelessWidget {
  final CustomerCardsController controller = Get.put(
    CustomerCardsController(),
    permanent: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey50,
      body: SafeArea(
        child: Column(
          children: [
            buildCustomAppBar("Customer Details", isdark: true),
            // Show loading indicator when initially loading
            Obx(
              () =>
                  controller.isLoading.value && controller.apiCustomers.isEmpty
                      ? LinearProgressIndicator(
                        backgroundColor: AppTheme.grey200,
                        color: Color(0xFF6C5CE7),
                      )
                      : SizedBox(),
            ),
            _buildCompactSearchAndFilters(),
            NotificationListener(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent &&
                    !controller.isLoadingMore.value &&
                    !controller.isLoading.value) {
                  controller.loadMoreCustomers();
                }
                return false;
              },
              child: Expanded(
                child: CustomScrollView(
                  slivers: [
                    // Stats as a sliver that can scroll with content
                    SliverToBoxAdapter(child: _buildCompactStatsRow()),
                    // Customer cards
                    _buildCustomerCardsSlivers(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactSearchAndFilters() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity05,
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
          
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(2),
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.grey50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.greyOpacity02),
                  ),
                  child: TextField(
                    
                    onChanged: controller.onSearchChanged,
                    decoration: InputDecoration(
                      
                      hintText: 'Search customers...',
                      hintStyle: AppStyles.black_14_400,
prefixIcon: Icon(Icons.search),
                      suffixIcon: Obx(
                        () =>
                            controller.searchQuery.value.isNotEmpty
                                ? IconButton(
                                  onPressed:
                                      () => controller.onSearchChanged(''),
                                  icon: Icon(
                                    Icons.clear,
                                    size: 16,
                                    color: AppTheme.grey400,
                                  ),
                                )
                                : SizedBox(),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              // Compact filter toggle
              Obx(
                () => IconButton(
                  onPressed: () => controller.toggleFiltersExpanded(),
                  icon: Icon(
                    controller.isFiltersExpanded.value
                        ? Icons.expand_less
                        : Icons.tune,
                    color: Color(0xFF6C5CE7),
                    size: 20,
                  ),
                  tooltip: 'Filters',
                ),
              ),
              IconButton(
                onPressed: () => controller.refreshCustomers(),
                icon: Icon(Icons.refresh, size: 18, color: Color(0xFF6C5CE7)),
                tooltip: 'Refresh',
              ),
            ],
          ),

          // Expandable filters section
          Obx(
            () => AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: controller.isFiltersExpanded.value ? null : 0,
              child:
                  controller.isFiltersExpanded.value
                      ? Column(
                        children: [
                          SizedBox(height: 12),
                          // Filter chips in a more compact layout
                          Row(
                            children: [
                              Expanded(
                                child: Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    _buildCompactFilterChip('All'),
                                    _buildCompactFilterChip('New'),
                                    _buildCompactFilterChip('Regular'),
                                    _buildCompactFilterChip('Repeated'),
                                    _buildCompactFilterChip('VIP'),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              // Compact sort dropdown
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.grey100,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppTheme.greyOpacity03,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.sort,
                                      size: 14,
                                      color: AppTheme.grey600,
                                    ),
                                    SizedBox(width: 4),
                                    Obx(
                                      () => DropdownButton<String>(
                                        value: controller.sortBy.value,
                                        onChanged:
                                            (value) => controller.onSortChanged(
                                              value!,
                                            ),
                                        underline: SizedBox(),
                                        style: AppStyles.custom(
                                          size: 11,
                                          color: AppTheme.grey700,
                                        ),
                                        items:
                                            [
                                                  'Name',
                                                  'Total Purchase',
                                                  'Total Dues',
                                                  'Location',
                                                ]
                                                .map(
                                                  (sort) => DropdownMenuItem(
                                                    value: sort,
                                                    child: Text(sort),
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Clear filters button
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () => controller.resetFilters(),
                              icon: Icon(Icons.clear_all, size: 14),
                              label: Text(
                                'Clear All',
                                style: AppStyles.custom(size: 11),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.grey600,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                minimumSize: Size(0, 0),
                              ),
                            ),
                          ),
                        ],
                      )
                      : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactFilterChip(String filter) {
    return Obx(
      () => FilterChip(
        label: Text(
          filter,
          style: AppStyles.custom(
            size: 11,
            weight: FontWeight.w500,
            color:
                controller.selectedFilter.value == filter
                    ? AppTheme.backgroundLight
                    : AppTheme.grey700,
          ),
        ),
        selected: controller.selectedFilter.value == filter,
        onSelected: (selected) => controller.onFilterChanged(filter),
        selectedColor: Color(0xFF6C5CE7),
        backgroundColor: AppTheme.grey100,
        checkmarkColor: AppTheme.backgroundLight,
        side: BorderSide.none,
        elevation: 0,
        pressElevation: 1,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      ),
    );
  }

  Widget _buildCompactStatsRow() {
    return Container(
      height: 60, // Reduced height
      margin: EdgeInsets.fromLTRB(16, 4, 16, 8), // Reduced margins
      child: Obx(
        () => Row(
          children: [
            _buildCompactStatItem(
              'All',
              controller.getCustomerCountByType('All'),
              Color(0xFF6C5CE7),
            ),
            _buildCompactStatItem(
              'New',
              controller.getCustomerCountByType('New'),
              Color(0xFF00CEC9),
            ),
            _buildCompactStatItem(
              'Regular',
              controller.getCustomerCountByType('Regular'),
              Color(0xFF6C5CE7),
            ),
            _buildCompactStatItem(
              'Repeated',
              controller.getCustomerCountByType('Repeated'),
              Color(0xFF51CF66),
            ),
            _buildCompactStatItem(
              'VIP',
              controller.getCustomerCountByType('VIP'),
              Color(0xFFFFD700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactStatItem(String label, int count, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 6), // Reduced margin
        padding: EdgeInsets.all(8), // Reduced padding
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(8), // Smaller radius
          boxShadow: [
            BoxShadow(
              color: AppTheme.greyOpacity05,
              blurRadius: 6,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count.toString(),
              style: AppStyles.custom(
                size: 14, // Reduced font size
                weight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: AppStyles.custom(
                size: 9, // Reduced font size
                color: AppTheme.grey600,
                weight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCardsSlivers() {
    return Obx(() {
      if (controller.hasError.value) {
        return SliverFillRemaining(child: _buildErrorState());
      }

      if (controller.isLoading.value && controller.apiCustomers.isEmpty) {
        return SliverFillRemaining(child: _buildLoadingState());
      }

      if (controller.filteredCustomers.isEmpty && !controller.isLoading.value) {
        return SliverFillRemaining(child: _buildEmptyState());
      }

      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.82, // Adjust this to control card height
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == controller.filteredCustomers.length) {
                return controller.isLoadingMore.value
                    ? Container(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF6C5CE7),
                          strokeWidth: 2,
                        ),
                      ),
                    )
                    : SizedBox.shrink();
              }

              final customer = controller.filteredCustomers[index];
              return _buildCompactCustomerCard(customer, index);
            },
            childCount:
                controller.filteredCustomers.length +
                (controller.isLoadingMore.value ? 1 : 0),
          ),
        ),
      );
    });
  }

  Widget _buildCompactCustomerCard(Customer customer, int index) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity06,
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: controller
              .getCustomerTypeColor(customer.customerType)
              .withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section with avatar and customer type badge
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      controller.getCustomerTypeColor(customer.customerType),
                      controller
                          .getCustomerTypeColor(customer.customerType)
                          .withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    customer.profilePhotoUrl.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Icon(
                            Icons.person,
                            size: 18,
                            color: AppTheme.backgroundLight,
                          ),
                        )
                        : Icon(
                          controller.getCustomerTypeIcon(customer.customerType),
                          color: AppTheme.backgroundLight,
                          size: 18,
                        ),
              ),
              Spacer(),
              _buildCompactCustomerTypeBadge(customer.customerType),
            ],
          ),

          SizedBox(height: 12),

          // Customer name
          Text(
            customer.name,
            style: AppStyles.custom(
              size: 14,
              weight: FontWeight.bold,
              color: AppTheme.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 6),

          // Phone number
          Row(
            children: [
              Icon(Icons.phone, size: 10, color: AppTheme.grey500),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  customer.primaryPhone,
                  style: AppStyles.custom(
                    size: 11,
                    color: AppTheme.grey600,
                    weight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 4),

          // Location
          Row(
            children: [
              Icon(Icons.location_on, size: 10, color: AppTheme.grey500),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  customer.location,
                  style: AppStyles.custom(size: 10, color: AppTheme.grey500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          Spacer(),

          // Purchase and Dues section
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: AppTheme.grey50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Purchase row
                Row(
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 10,
                      color: AppTheme.grey500,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Purchase',
                      style: AppStyles.custom(
                        size: 9,
                        color: AppTheme.grey500,
                        weight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      customer.formattedTotalPurchase,
                      style: AppStyles.custom(
                        size: 11,
                        weight: FontWeight.bold,
                        color: Color(0xFF51CF66),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4),

                // Dues row
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 10,
                      color: AppTheme.grey500,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Dues',
                      style: AppStyles.custom(
                        size: 9,
                        color: AppTheme.grey500,
                        weight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      customer.formattedTotalDues,
                      style: AppStyles.custom(
                        size: 11,
                        weight: FontWeight.bold,
                        color:
                            customer.totalDues > 0
                                ? Color(0xFFFF6B6B)
                                : AppTheme.grey600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  height: 28,
                  child: ElevatedButton(
                    onPressed:
                        () => controller.callCustomer(customer.primaryPhone),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF51CF66).withOpacity(0.1),
                      foregroundColor: Color(0xFF51CF66),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(Icons.call, size: 12),
                  ),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () => controller.editCustomer(customer),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6C5CE7).withOpacity(0.1),
                      foregroundColor: Color(0xFF6C5CE7),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(Icons.edit, size: 12),
                  ),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () => _showCustomerDetailDialog(customer),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6B6B).withOpacity(0.1),
                      foregroundColor: Color.fromARGB(255, 160, 152, 152),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(Icons.remove_red_eye, size: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

void _showCustomerDetailDialog(Customer customer) {
  showDialog(
    context: Get.context!,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: CustomerDetailDialog(customer: customer),
      );
    },
  );
}


  Widget _buildCompactCustomerTypeBadge(String type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: controller.getCustomerTypeColor(type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: controller.getCustomerTypeColor(type).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            controller.getCustomerTypeIcon(type),
            size: 8,
            color: controller.getCustomerTypeColor(type),
          ),
          SizedBox(width: 2),
          Text(
            type.length > 6 ? type.substring(0, 3) : type,
            style: AppStyles.custom(
              size: 8,
              weight: FontWeight.w600,
              color: controller.getCustomerTypeColor(type),
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
          CircularProgressIndicator(color: Color(0xFF6C5CE7)),
          SizedBox(height: 16),
          Text(
            'Loading customers...',
            style: AppStyles.custom(size: 16, color: AppTheme.grey600),
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
          Icon(Icons.error_outline, size: 64, color: AppTheme.red300),
          SizedBox(height: 16),
          Text(
            'Error loading customers',
            style: AppStyles.custom(
              size: 18,
              weight: FontWeight.w600,
              color: AppTheme.red600,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessage.value,
              style: AppStyles.custom(size: 14, color: AppTheme.grey600),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.refreshCustomers(),
            child: Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6C5CE7),
              foregroundColor: AppTheme.backgroundLight,
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
          Icon(Icons.people_outline, size: 64, color: AppTheme.grey400),
          SizedBox(height: 16),
          Text(
            'No customers found',
            style: AppStyles.custom(
              size: 18,
              weight: FontWeight.w600,
              color: AppTheme.grey600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms',
            style: AppStyles.custom(size: 14, color: AppTheme.grey500),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.resetFilters(),
            child: Text('Clear Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6C5CE7),
              foregroundColor: AppTheme.backgroundLight,
            ),
          ),
        ],
      ),
    );
  }
}


class CustomerDetailDialog extends StatelessWidget {
  final Customer customer;

  const CustomerDetailDialog({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customer Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close, color: Colors.grey[600]),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  shape: CircleBorder(),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Profile section
          _buildProfileSection(customer),

          SizedBox(height: 20),

          // Details sections
          _buildContactSection(customer),
          
          SizedBox(height: 16),
          
          _buildAddressSection(customer),
          
          SizedBox(height: 16),
          
          _buildFinancialSection(customer),

          SizedBox(height: 20),

          // Action buttons
          _buildActionButtons(customer, context),
        ],
      ),
    );
  }

  Widget _buildProfileSection(Customer customer) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFF9C88FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Profile picture or avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            ),
            child: customer.profilePhotoUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.network(
                      customer.profilePhotoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.person, color: Colors.white, size: 30);
                      },
                    ),
                  )
                : Icon(Icons.person, color: Colors.white, size: 30),
          ),
          
          SizedBox(width: 16),
          
          // Name and ID
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'ID: ${customer.id}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(Customer customer) {
    return _buildSection(
      title: 'Contact Information',
      icon: Icons.contact_phone,
      iconColor: Color(0xFF51CF66),
      children: [
        _buildDetailRow(
          icon: Icons.phone,
          label: 'Primary Phone',
          value: customer.primaryPhone,
          isClickable: true,
          onTap: () => _makePhoneCall(customer.primaryPhone),
        ),
        if (customer.alternatePhones.isNotEmpty) ...[
          SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.phone_outlined,
            label: 'Alternate Phones',
            value: customer.alternatePhones.join(', '),
            isMultiline: true,
          ),
        ],
      ],
    );
  }

  Widget _buildAddressSection(Customer customer) {
    return _buildSection(
      title: 'Address Information',
      icon: Icons.location_on,
      iconColor: Color(0xFFFF6B6B),
      children: [
        _buildDetailRow(
          icon: Icons.home,
          label: 'Primary Address',
          value: customer.primaryAddress.isEmpty ? 'Not provided' : customer.primaryAddress,
          isMultiline: true,
        ),
        SizedBox(height: 8),
        _buildDetailRow(
          icon: Icons.location_city,
          label: 'Location',
          value: customer.location.isEmpty ? 'Not provided' : customer.location,
        ),
      ],
    );
  }

  Widget _buildFinancialSection(Customer customer) {
    return _buildSection(
      title: 'Financial Summary',
      icon: Icons.account_balance_wallet,
      iconColor: Color(0xFF6C5CE7),
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFinancialCard(
                title: 'Total Purchase',
                value: _formatCurrency(customer.totalPurchase),
                color: Color(0xFF51CF66),
                icon: Icons.shopping_cart,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildFinancialCard(
                title: 'Total Dues',
                value: _formatCurrency(customer.totalDues),
                color: customer.totalDues > 0 ? Color(0xFFFF6B6B) : Colors.grey,
                icon: Icons.account_balance_wallet,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isClickable = false,
    bool isMultiline = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isClickable ? onTap : null,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: Colors.grey[600]),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 12,
                      color: isClickable ? Color(0xFF6C5CE7) : Colors.black87,
                      fontWeight: FontWeight.w500,
                      decoration: isClickable ? TextDecoration.underline : null,
                    ),
                    maxLines: isMultiline ? null : 1,
                    overflow: isMultiline ? null : TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isClickable)
              Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Customer customer, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _makePhoneCall(customer.primaryPhone),
            icon: Icon(Icons.call, size: 16),
            label: Text('Call'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF51CF66),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              // Add your edit customer logic here
              // controller.editCustomer(customer);
            },
            icon: Icon(Icons.edit, size: 16),
            label: Text('Edit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6C5CE7),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    if (amount == 0) return '₹0';
    if (amount < 1000) return '₹${amount.toStringAsFixed(0)}';
    if (amount < 100000) return '₹${(amount / 1000).toStringAsFixed(1)}K';
    return '₹${(amount / 100000).toStringAsFixed(1)}L';
  }

  void _makePhoneCall(String phoneNumber) {
    // Add your phone call logic here
    // For example: launch('tel:$phoneNumber');
    print('Calling: $phoneNumber');
  }
}