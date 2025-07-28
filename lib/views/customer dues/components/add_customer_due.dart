import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/customer%20dues%20controllers/customer_due_operations_controller.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/utils/common_textfield.dart';
import 'package:smartbecho/utils/custom_back_button.dart';
import 'package:smartbecho/utils/app_styles.dart';

class AddDuesPage extends StatelessWidget {
  const AddDuesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get or create the controller instance
    final AddDuesController controller = Get.put(AddDuesController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(controller),
      body: Form(
        key: controller.addDueFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormHeader(controller),
              _buildFormContent(controller),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AddDuesController controller) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: customBackButton(isdark: true),
      ),
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 45.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CREATE DUE ENTRY',
                    style: AppStyles.custom(
                      color: const Color(0xFF1A1A1A),
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Fill details to create due entry',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormHeader(AddDuesController controller) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF6366F1).withOpacity(0.2),
                  ),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Color(0xFF6366F1),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.selectedCustomerName.value.isEmpty
                          ? 'Select Customer'
                          : controller.selectedCustomerName.value,
                      style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      controller.remainingDueAmount.value > 0
                          ? '₹${controller.remainingDueAmount.value.toStringAsFixed(2)} remaining'
                          : 'Enter due amount',
                      style: TextStyle(
                        color:
                            controller.remainingDueAmount.value > 0
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF6B7280),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.selectedPaymentDate.value != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    controller.paymentDateController.text,
                    style: const TextStyle(
                      color: Color(0xFF6366F1),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(AddDuesController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Customer Selection', Icons.person_search),
            const SizedBox(height: 16),

            // Customer Selection Dropdown
            _buildCustomerDropdown(controller),
            const SizedBox(height: 24),

            _buildSectionTitle('Due Information', Icons.account_balance_wallet),
            const SizedBox(height: 16),

            // Due Amount Fields Row
            Row(
              children: [
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'Total Due Amount',
                    controller: controller.totalDueController,
                    hintText: 'Enter total due',
                    keyboardType: TextInputType.number,
                    validator: controller.validateTotalDue,
                    // prefixIcon: const Icon(Icons.currency_rupee, size: 18),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'Total Paid Amount',
                    controller: controller.totalPaidController,
                    hintText: 'Enter paid amount',
                    keyboardType: TextInputType.number,
                    validator: controller.validateTotalPaid,
                    // prefixIcon: const Icon(Icons.currency_rupee, size: 18),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Remaining Due Amount Display
            Obx(
              () => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      controller.remainingDueAmount.value > 0
                          ? const Color(0xFFEF4444).withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        controller.remainingDueAmount.value > 0
                            ? const Color(0xFFEF4444).withOpacity(0.3)
                            : Colors.green.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      controller.remainingDueAmount.value > 0
                          ? Icons.warning_amber
                          : Icons.check_circle,
                      color:
                          controller.remainingDueAmount.value > 0
                              ? const Color(0xFFEF4444)
                              : Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Remaining Due Amount',
                            style: TextStyle(
                              color:
                                  controller.remainingDueAmount.value > 0
                                      ? const Color(0xFFEF4444)
                                      : Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '₹${controller.remainingDueAmount.value.toStringAsFixed(2)}',
                            style: TextStyle(
                              color:
                                  controller.remainingDueAmount.value > 0
                                      ? const Color(0xFFEF4444)
                                      : Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle('Payment Date', Icons.calendar_today),
            const SizedBox(height: 16),

            // Payment Date Field
            GestureDetector(
              onTap: () => controller.selectPaymentDate(Get.context!),
              child: AbsorbPointer(
                child: buildStyledTextField(
                  labelText: 'Payment Retrieval Date',
                  controller: controller.paymentDateController,
                  hintText: 'Select payment date',
                  validator: controller.validatePaymentDate,
                  // suffixIcon: const Icon(Icons.calendar_today, size: 18),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      child: OutlinedButton(
                        onPressed:
                            controller.isAddingDue.value
                                ? null
                                : controller.cancelAddDue,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            controller.isAddingDue.value
                                ? null
                                : controller.addDueEntry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child:
                            controller.isAddingDue.value
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Create Due Entry',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Error Message Display
            Obx(
              () =>
                  controller.hasAddDueError.value
                      ? Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.addDueErrorMessage.value,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerDropdown(AddDuesController controller) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: DropdownButtonFormField<String>(
                isDense: false,
                decoration: InputDecoration(
                  labelText: 'Select Customer',
                  hintText: 'Choose a customer',
                  prefixIcon: const Icon(Icons.person_search, size: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.05),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                ),
                value:
                    controller.selectedCustomerId.value.isEmpty
                        ? null
                        : controller.selectedCustomerId.value,
                validator: controller.validateCustomer,
                items:
                    controller.customers.map((customer) {
                      return DropdownMenuItem<String>(
                        value: customer['id'].toString(),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFF6366F1),
                                size: 16,
                              ),
                              //  customer['profilePhoto'] != null
                              //     ? ClipRRect(
                              //         borderRadius: BorderRadius.circular(8),
                              //         child: Image.network(
                              //           customer['profilePhoto'],
                              //           fit: BoxFit.cover,
                              //         ),
                              //       )
                              //     : const Icon(
                              //         Icons.person,
                              //         color: Color(0xFF6366F1),
                              //         size: 16,
                              //       ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    customer['name'] ?? "",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (customer['primaryNumber'] != null)
                                    Text(
                                      customer['primaryNumber'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    final selectedCustomer = controller.customers.firstWhere(
                      (customer) => customer['id'].toString() == value,
                    );
                    controller.onCustomerSelected(value, selectedCustomer['name']);
                  }
                },
                isExpanded: true,
                icon:
                    controller.isLoadingCustomers.value
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.arrow_drop_down),
              ),
            ),
          ),
          SizedBox(width: 5,),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.addCustomer),
            child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF6366F1).withOpacity(0.2),
                    ),
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1,
                    color: Color(0xFF6366F1),
                    size: 24,
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF6366F1), size: 16),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
