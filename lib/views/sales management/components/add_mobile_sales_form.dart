
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smartbecho/controllers/sales%20hisrory%20controllers/add_mobile_sales_controller.dart';
import 'package:smartbecho/utils/common_textfield.dart';
import 'package:smartbecho/utils/custom_dropdown.dart';
import 'package:smartbecho/utils/custom_back_button.dart';
import 'package:smartbecho/utils/app_styles.dart';

class MobileSalesForm extends StatelessWidget {
  const MobileSalesForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SalesCrudOperationController controller =
        Get.find<SalesCrudOperationController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(controller),
      body: Form(
        key: controller.salesFormKey,
        child: Column(
          children: [
            _buildStepIndicator(controller),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(controller),
                  _buildStep2(controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(SalesCrudOperationController controller) {
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
              child: const Icon(Icons.sell, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MOBILE SALES FORM',
                    style: AppStyles.custom(
                      color: const Color(0xFF1A1A1A),
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Complete the sale process',
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

  Widget _buildStepIndicator(SalesCrudOperationController controller) {
    return Obx(
      () => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            _buildStepCircle(1, controller.currentStep.value >= 1, true),
            Expanded(
              child: Container(
                height: 2,
                color: controller.currentStep.value >= 2
                    ? const Color(0xFF6366F1)
                    : Colors.grey.shade300,
              ),
            ),
            _buildStepCircle(2, controller.currentStep.value >= 2, false),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCircle(int step, bool isActive, bool isFirst) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF6366F1) : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isFirst ? 'Product & Customer Details' : 'Payment & Pricing',
          style: TextStyle(
            color: isActive ? const Color(0xFF6366F1) : Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStep1(SalesCrudOperationController controller) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductDetailsSection(controller),
          _buildCustomerDetailsSection(controller),
          _buildStep1Navigation(controller),
        ],
      ),
    );
  }

  Widget _buildStep2(SalesCrudOperationController controller) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPaymentSection(controller),
          _buildStep2Navigation(controller),
        ],
      ),
    );
  }

  Widget _buildProductDetailsSection(SalesCrudOperationController controller) {
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
            _buildSectionTitle('Product Details', Icons.phone_android),
            const SizedBox(height: 16),

            // Category Dropdown
            Obx(() {
              if (controller.isLoadingFilters.value) {
                return buildShimmerTextField();
              }
              
              return buildStyledDropdown(
                labelText: 'Category',
                hintText: 'Select Category',
                value: controller.selectedCategory.value.isEmpty
                    ? null
                    : controller.selectedCategory.value,
                items: controller.categories,
                onChanged: (value) => controller.onCategoryChanged(value ?? ''),
                validator: controller.validateCategory,
              );
            }),
            const SizedBox(height: 16),

            // Company Dropdown
            Obx(() {
              if (controller.isLoadingCompanies.value) {
                return buildShimmerTextField();
              }

              bool isEnabled = controller.isCategorySelected;
              
              return buildStyledDropdown(
                labelText: 'Company',
                hintText: isEnabled ? 'Select Company' : 'Please select category first',
                value: controller.selectedCompany.value.isEmpty
                    ? null
                    : controller.selectedCompany.value,
                items: controller.companies,
                enabled: isEnabled,
                onChanged: (value) => controller.onCompanyChanged(value ?? ''),
                validator: controller.validateCompany,
              );
            }),
            const SizedBox(height: 16),

            // Model Dropdown
            Obx(() {
              if (controller.isLoadingModels.value) {
                return buildShimmerTextField();
              }

              bool isEnabled = controller.isCompanySelected;
              
              return buildStyledDropdown(
                labelText: 'Model',
                hintText: isEnabled ? 'Select Model' : 'Please select company first',
                value: controller.selectedModel.value.isEmpty
                    ? null
                    : controller.selectedModel.value,
                items: controller.models,
                enabled: isEnabled,
                onChanged: (value) => controller.onModelChanged(value ?? ''),
                validator: controller.validateModel,
              );
            }),
            const SizedBox(height: 16),

            // Product Description
            buildStyledTextField(
              labelText: 'Product Description',
              controller: controller.productDescriptionController,
              hintText: 'Enter product description',
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Color Dropdown
            Obx(() => buildStyledDropdown(
              labelText: 'Color',
              hintText: 'Select Color',
              value: controller.selectedColor.value.isEmpty
                  ? null
                  : controller.selectedColor.value,
              items: controller.colorOptions,
              onChanged: (value) => controller.onColorChanged(value ?? ''),
              validator: controller.validateColor,
            )),
            const SizedBox(height: 16),

            // Quantity and Unit Price Row
            Row(
              children: [
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'Quantity',
                    controller: controller.quantityController,
                    hintText: '1',
                    keyboardType: TextInputType.number,
                    validator: controller.validateQuantity,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'Unit Price (₹)',
                    controller: controller.unitPriceController,
                    hintText: '0',
                    keyboardType: TextInputType.number,
                    validator: controller.validateUnitPrice,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerDetailsSection(SalesCrudOperationController controller) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
            _buildSectionTitle('Customer Details', Icons.person),
            const SizedBox(height: 16),

            // Customer Name
            buildStyledTextField(
              labelText: 'Customer Name',
              controller: controller.customerNameController,
              hintText: 'Enter customer name',
              validator: controller.validateCustomerName,
            ),
            const SizedBox(height: 16),

            // Phone Number with auto-fetch
            Obx(() => buildStyledTextField(
              labelText: 'Phone Number',
              controller: controller.phoneNumberController,
              hintText: 'Enter phone number',
              keyboardType: TextInputType.phone,
              validator: controller.validatePhoneNumber,
              onChanged: controller.onPhoneNumberChanged,
              suffixIcon: controller.isLoadingCustomer.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : controller.customerFound.value
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
            )),
            const SizedBox(height: 16),

            // Email
            buildStyledTextField(
              labelText: 'Email',
              controller: controller.emailController,
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              validator: controller.validateEmail,
            ),
            const SizedBox(height: 16),

            // Address
            buildStyledTextField(
              labelText: 'Address',
              controller: controller.addressController,
              hintText: 'Enter address',
              maxLines: 3,
              validator: controller.validateAddress,
            ),
            const SizedBox(height: 16),

            // City, State, Pincode Row
            Row(
              children: [
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'City',
                    controller: controller.cityController,
                    hintText: 'Enter city',
                    validator: controller.validateCity,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'State',
                    controller: controller.stateController,
                    hintText: 'Enter state',
                    validator: controller.validateState,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'Pincode',
                    controller: controller.pincodeController,
                    hintText: 'Enter pincode',
                    keyboardType: TextInputType.number,
                    validator: controller.validatePincode,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection(SalesCrudOperationController controller) {
    return Column(
      children: [
        // Price Calculation Section
        _buildPriceCalculationSection(controller),
        
        // Payment Details Section
        Container(
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
                _buildSectionTitle('Payment Details', Icons.payment),
                const SizedBox(height: 16),

                // Payment Mode Selection
                Text(
                  'Payment Mode',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => Row(
                  children: [
                    _buildPaymentModeRadio(
                      controller,
                      'Full Payment',
                      PaymentMode.fullPayment,
                    ),
                    const SizedBox(width: 16),
                    _buildPaymentModeRadio(
                      controller,
                      'Dues (Partial Payment)',
                      PaymentMode.partialPayment,
                    ),
                    const SizedBox(width: 16),
                    _buildPaymentModeRadio(
                      controller,
                      'EMI',
                      PaymentMode.emi,
                    ),
                  ],
                )),
                const SizedBox(height: 20),

                // Payment Mode Specific Fields
                Obx(() => _buildPaymentModeFields(controller)),
                
                const SizedBox(height: 24),
                
                // Price Summary
                _buildPriceSummary(controller),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceCalculationSection(SalesCrudOperationController controller) {
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
            _buildSectionTitle('Price Calculation', Icons.calculate),
            const SizedBox(height: 16),

            // GST Percentage and Extra Charges Row
            Row(
              children: [
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'GST Percentage (%)',
                    controller: controller.gstPercentageController,
                    hintText: '12',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => controller.calculatePrices(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'Extra Charges (₹)',
                    controller: controller.extraChargesController,
                    hintText: '0',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => controller.calculatePrices(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Accessories Cost and Repair Charges Row
            Row(
              children: [
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'Accessories Cost (₹)',
                    controller: controller.accessoriesCostController,
                    hintText: '0',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => controller.calculatePrices(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'Repair Charges (₹)',
                    controller: controller.repairChargesController,
                    hintText: '0',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => controller.calculatePrices(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Total Discount
            buildStyledTextField(
              labelText: 'Total Discount (₹)',
              controller: controller.totalDiscountController,
              hintText: '0',
              keyboardType: TextInputType.number,
              onChanged: (value) => controller.calculatePrices(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary(SalesCrudOperationController controller) {
    return Obx(() => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Summary',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          
          _buildSummaryRow('Base Amount:', '₹${controller.baseAmount.value.toStringAsFixed(2)}'),
          _buildSummaryRow('Amount without GST:', '₹${controller.amountWithoutGST.value.toStringAsFixed(2)}'),
          _buildSummaryRow('GST (${controller.gstPercentage.value.toStringAsFixed(1)}%):', '₹${controller.gstAmount.value.toStringAsFixed(2)}'),
          const Divider(height: 16),
          _buildSummaryRow(
            'Total Payable Amount:', 
            '₹${controller.totalPayableAmount.value.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    ));
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 14 : 13,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              color: isTotal ? const Color(0xFF1A1A1A) : Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 14 : 13,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              color: isTotal ? const Color(0xFF6366F1) : const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentModeRadio(
    SalesCrudOperationController controller,
    String title,
    PaymentMode mode,
  ) {
    return Expanded(
      child: Row(
        children: [
          Radio<PaymentMode>(
            value: mode,
            groupValue: controller.selectedPaymentMode.value,
            onChanged: (value) => controller.onPaymentModeChanged(value!),
            activeColor: const Color(0xFF6366F1),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentModeFields(SalesCrudOperationController controller) {
    switch (controller.selectedPaymentMode.value) {
      case PaymentMode.fullPayment:
        return _buildFullPaymentFields(controller);
      case PaymentMode.partialPayment:
        return _buildPartialPaymentFields(controller);
      case PaymentMode.emi:
        return _buildEMIFields(controller);
    }
  }

  Widget _buildFullPaymentFields(SalesCrudOperationController controller) {
    return Column(
      children: [
        // Payment Method
        buildStyledDropdown(
          labelText: 'Payment Method',
          hintText: 'Select Payment Method',
          value: controller.selectedPaymentMethod.value.isEmpty
              ? null
              : controller.selectedPaymentMethod.value,
          items: controller.paymentMethods,
          onChanged: (value) => controller.onPaymentMethodChanged(value ?? ''),
          validator: controller.validatePaymentMethod,
        ),
        const SizedBox(height: 16),

        // Payable Amount
        buildStyledTextField(
          labelText: 'Payable Amount (₹)',
          controller: controller.payableAmountController,
          hintText: '1.06',
          keyboardType: TextInputType.number,
          validator: controller.validatePayableAmount,
        ),
      ],
    );
  }

  Widget _buildPartialPaymentFields(SalesCrudOperationController controller) {
    return Column(
      children: [
        // Payment Method
        buildStyledDropdown(
          labelText: 'Payment Method',
          hintText: 'Select Payment Method',
          value: controller.selectedPaymentMethod.value.isEmpty
              ? null
              : controller.selectedPaymentMethod.value,
          items: controller.paymentMethods,
          onChanged: (value) => controller.onPaymentMethodChanged(value ?? ''),
          validator: controller.validatePaymentMethod,
        ),
        const SizedBox(height: 16),

        // Down Payment
        buildStyledTextField(
          labelText: 'Down Payment (₹)',
          controller: controller.downPaymentController,
          hintText: '1.06',
          keyboardType: TextInputType.number,
          validator: controller.validateDownPayment,
        ),
        const SizedBox(height: 16),

        // Payment Retrieval Date
        buildStyledTextField(
          labelText: 'Payment Retrieval Date',
          controller: controller.paymentRetrievalDateController,
          hintText: 'dd-mm-yyyy',
          readOnly: true,
          onTap: () => controller.selectPaymentRetrievalDate(),
          suffixIcon: const Icon(Icons.calendar_today, size: 20),
          validator: controller.validatePaymentRetrievalDate,
        ),
      ],
    );
  }

  Widget _buildEMIFields(SalesCrudOperationController controller) {
    return Column(
      children: [
        // Payment Method
        buildStyledDropdown(
          labelText: 'Payment Method',
          hintText: 'Select Payment Method',
          value: controller.selectedPaymentMethod.value.isEmpty
              ? null
              : controller.selectedPaymentMethod.value,
          items: controller.paymentMethods,
          onChanged: (value) => controller.onPaymentMethodChanged(value ?? ''),
          validator: controller.validatePaymentMethod,
        ),
        const SizedBox(height: 16),

        // Down Payment
        buildStyledTextField(
          labelText: 'Down Payment (₹)',
          controller: controller.downPaymentController,
          hintText: '1.06',
          keyboardType: TextInputType.number,
          validator: controller.validateDownPayment,
        ),
        const SizedBox(height: 16),

        // EMI Tenure
        buildStyledDropdown(
          labelText: 'EMI Tenure (Months)',
          hintText: 'Select EMI Tenure',
          value: controller.selectedEMITenure.value.isEmpty
              ? null
              : controller.selectedEMITenure.value,
          items: controller.emiTenureOptions,
          onChanged: (value) => controller.onEMITenureChanged(value ?? ''),
          validator: controller.validateEMITenure,
        ),
        const SizedBox(height: 16),

        // Monthly EMI
        buildStyledTextField(
          labelText: 'Monthly EMI (₹)',
          controller: controller.monthlyEMIController,
          hintText: 'Monthly EMI amount',
          keyboardType: TextInputType.number,
          validator: controller.validateMonthlyEMI,
        ),
      ],
    );
  }

  Widget _buildStep1Navigation(SalesCrudOperationController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 48,
              child: ElevatedButton(
                onPressed: controller.goToStep2,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Navigation(SalesCrudOperationController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                child: OutlinedButton(
                  onPressed: controller.isProcessingSale.value
                      ? null
                      : controller.goToStep1,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.isProcessingSale.value
                      ? null
                      : controller.completeSale,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isProcessingSale.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Complete Sale',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
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

  Widget buildShimmerTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 14,
            width: 100,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 6),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}