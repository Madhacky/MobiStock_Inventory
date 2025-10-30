import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/account%20management%20controller/commission_received_controller.dart';
import 'package:smartbecho/utils/common_textfield.dart';
import 'package:smartbecho/utils/custom_back_button.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'dart:io';

import 'package:smartbecho/utils/custom_dropdown.dart';

class AddCommissionPage extends StatelessWidget {
  final CommissionReceivedController controller =
      Get.find<CommissionReceivedController>();

  AddCommissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildFormHeader(), _buildFormContent()],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
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
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.monetization_on,
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
                    'ADD COMMISSION',
                    style: AppStyles.custom(
                      color: const Color(0xFF1A1A1A),
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Record commission received',
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

  Widget _buildFormHeader() {
    return Padding(
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
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                ),
              ),
              child: const Icon(
                Icons.monetization_on,
                color: Color(0xFF10B981),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Commission Information',
                    style: TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Fill in the details below to record a commission received. All fields marked with * are required.',
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

  Widget _buildFormContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Commission Details', Icons.business_center),
            const SizedBox(height: 16),

            // Date Field
            _buildDateField(),
            const SizedBox(height: 16),

            // Company Field
            buildStyledTextField(
              labelText: 'Company *',
              controller: controller.companyController,
              hintText: 'Enter company name',
              validator: controller.validateRequired,
            ),
            const SizedBox(height: 16),

            // Amount Field
            buildStyledTextField(
              labelText: 'Amount *',
              controller: controller.amountController,
              hintText: '0.00',
              prefixText: '₹ ',
              keyboardType: TextInputType.number,
              validator: controller.validateAmount,
            ),
            const SizedBox(height: 16),

            // Received Mode Selection
            Obx(
              () => buildStyledDropdown(
                labelText: 'Payment Mode',
                hintText: 'Select payment mode',
                items:
                    controller.receivedModeFormOptions
                        .map(
                          (mode) => controller.getReceivedModeDisplayName(mode),
                        )
                        .toList(),
                value: controller.getReceivedModeDisplayName(
                  controller.selectedReceivedModeForm.value,
                ),
                onChanged: (displayName) {
                  // Find the actual value from display name
                  final actualValue = controller.receivedModeFormOptions
                      .firstWhere(
                        (mode) =>
                            controller.getReceivedModeDisplayName(mode) ==
                            displayName,
                      );
                  controller.setReceivedModeForm(actualValue);
                },
                validator: controller.validateReceivedMode,
              ),
            ),
            const SizedBox(height: 16),

            // Confirmed By Field
            buildStyledTextField(
              labelText: 'Confirmed By *',
              controller: controller.confirmedByController,
              hintText: 'Enter name of person who confirmed',
              validator: controller.validateRequired,
            ),
            const SizedBox(height: 16),

            // Description Field
            buildStyledTextField(
              labelText: 'Description *',
              controller: controller.descriptionController,
              hintText: 'Enter description',
              maxLines: 3,
              validator: controller.validateRequired,
            ),
            const SizedBox(height: 16),

            // File Upload Section
            _buildFileUploadSection(),
            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(),
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
            color: const Color(0xFF10B981).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF10B981), size: 16),
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

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date *',
          style: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: TextFormField(
            controller: controller.dateController,
            readOnly: true,
            style: const TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration(
              hintText: 'Select date',
              hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              suffixIcon: Icon(
                Icons.calendar_today,
                color: Color(0xFF6B7280),
                size: 18,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            validator: controller.validateRequired,
            onTap: () => controller.selectDate(Get.context!),
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Proof (PDF/Image)',
          style: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color:
                    controller.selectedFile.value != null
                        ? const Color(0xFF10B981)
                        : Colors.grey.withValues(alpha: 0.2),
              ),
            ),
            child: InkWell(
              onTap: controller.pickFile,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      controller.selectedFile.value != null
                          ? Icons.check_circle
                          : Icons.cloud_upload_outlined,
                      size: 32,
                      color:
                          controller.selectedFile.value != null
                              ? const Color(0xFF10B981)
                              : const Color(0xFF6B7280),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.selectedFile.value != null
                          ? 'File Selected: ${controller.selectedFile.value!.path.split('/').last}'
                          : 'Tap to upload file',
                      style: TextStyle(
                        color:
                            controller.selectedFile.value != null
                                ? const Color(0xFF10B981)
                                : const Color(0xFF6B7280),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (controller.selectedFile.value == null)
                      const Text(
                        'PDF, JPG, PNG files supported',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            height: 45,
            child: ElevatedButton(
              onPressed: controller.resetForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3F4F6),
                foregroundColor: const Color(0xFF6B7280),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.refresh, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Reset',
                    style: AppStyles.custom(weight: FontWeight.w600, size: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Obx(
            () => SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed:
                    controller.isFormLoading.value
                        ? null
                        : controller.saveCommission,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child:
                    controller.isFormLoading.value
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.save, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Record Commission',
                              style: AppStyles.custom(
                                weight: FontWeight.w600,
                                size: 13,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
