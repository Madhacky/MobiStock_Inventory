import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/customer%20controllers/customer_card_view_controller.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/utils/show_network_image.dart';
import 'package:smartbecho/models/customer%20management/customer_data_model.dart';

class BuildCompactCustomerCard extends StatelessWidget {
  BuildCompactCustomerCard({super.key});
  final CustomerCardsController controller = Get.put(
    CustomerCardsController(),
    permanent: false,
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.hasError.value) {
        return _buildErrorState();
      }

      if (controller.isLoading.value && controller.apiCustomers.isEmpty) {
        return _buildLoadingState();
      }

      if (controller.filteredCustomers.isEmpty &&
          !controller.isLoading.value &&
          !controller.isSearching.value) {
        return _buildEmptyState();
      }

      return GridView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75, // Adjust card height
        ),
        itemCount:
            controller.filteredCustomers.length +
            (controller.isLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.filteredCustomers.length) {
            return controller.isLoadingMore.value
                ? Container(
                  padding: const EdgeInsets.all(16),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF6C5CE7),
                      strokeWidth: 2,
                    ),
                  ),
                )
                : const SizedBox.shrink();
          }

          final customer = controller.filteredCustomers[index];
          return _buildCompactCustomerCard(customer, index);
        },
      );
    });
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
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          SizedBox(height: 16),
          Text(
            'Error loading customers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red[600],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessage.value,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.refreshCustomers(),
            child: Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6C5CE7),
              foregroundColor: Colors.white,
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
          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            controller.searchQuery.value.isNotEmpty
                ? 'No customers found for "${controller.searchQuery.value}"'
                : 'No customers found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            controller.searchQuery.value.isNotEmpty
                ? 'Try searching with a different name or phone number'
                : 'Try adjusting your filters or search terms',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.resetFilters(),
            child: Text('Clear Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6C5CE7),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactCustomerCard(Customer customer, int index) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.06),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: controller
              .getCustomerTypeColor(customer.customerType)
              .withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section with avatar and customer type badge
          Row(
            children: [
              customer.profilePhotoUrl == null ||
                      customer.profilePhotoUrl.isEmpty
                  ? Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          controller.getCustomerTypeColor(
                            customer.customerType,
                          ),
                          controller
                              .getCustomerTypeColor(customer.customerType)
                              .withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      controller.getCustomerTypeIcon(customer.customerType),
                      color: Colors.white,
                      size: 18,
                    ),
                  )
                  : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: cachedImage(
                      customer.profilePhotoUrl,
                      width: 36,
                      height: 36,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
              Spacer(),
              _buildCompactCustomerTypeBadge(customer.customerType),
            ],
          ),

          SizedBox(height: 6),

          // Customer name
          Text(
            customer.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 6),

          // Phone number
          Row(
            children: [
              Icon(Icons.phone, size: 10, color: Colors.grey[500]),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  customer.primaryPhone,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
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
              Icon(Icons.location_on, size: 10, color: Colors.grey[500]),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  customer.location,
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
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
              color: Colors.grey[50],
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
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Purchase',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      customer.formattedTotalPurchase,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
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
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Dues',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      customer.formattedTotalDues,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color:
                            customer.totalDues > 0
                                ? Color(0xFFFF6B6B)
                                : Colors.grey[600],
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
                      backgroundColor: Color(0xFF51CF66).withValues(alpha: 0.1),
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
                      backgroundColor: Color(0xFF6C5CE7).withValues(alpha: 0.1),
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
                    onPressed:
                        () => Get.toNamed(
                          AppRoutes.customerDetails,
                          arguments: customer.id,
                        ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6B6B).withValues(alpha: 0.1),
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

  Widget _buildCompactCustomerTypeBadge(String type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: controller.getCustomerTypeColor(type).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: controller.getCustomerTypeColor(type).withValues(alpha: 0.3),
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
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: controller.getCustomerTypeColor(type),
            ),
          ),
        ],
      ),
    );
  }
}
