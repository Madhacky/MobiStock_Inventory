import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/inventory%20controllers/add_new_stock_operation_controller.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/utils/common_textfield.dart';
import 'package:smartbecho/utils/custom_back_button.dart';
import 'package:smartbecho/utils/custom_dropdown.dart';

class AddNewStockForm extends StatelessWidget {
  const AddNewStockForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddNewStockOperationController controller = Get.find();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(controller),
      body: Form(
        key: controller.addBillFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildFormContent(controller)],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AddNewStockOperationController controller) {
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
                Icons.shopping_cart,
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
                    'ADD PURCHASE BILL',
                    style: AppStyles.custom(
                      color: const Color(0xFF1A1A1A),
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Create a new purchase entry',
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

  Widget _buildFormContent(AddNewStockOperationController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Bill Information', Icons.receipt),
            const SizedBox(height: 16),

            // Company Name
            buildStyledTextField(
              labelText: 'Vendor Name *',
              controller: controller.companyNameController,
              hintText: 'Enter vendor name',
              validator: controller.validateCompanyName,
            ),
            const SizedBox(height: 16),

            // // Payment Status
            // _buildPaymentStatusToggle(controller),
            // const SizedBox(height: 16),

            // GST and Without GST Row
            Row(
              children: [
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'GST (%) *',
                    controller: controller.gstController,
                    hintText: '0',
                    keyboardType: TextInputType.number,
                    validator: controller.validateGst,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'Without GST',
                    controller: controller.withoutGstController,
                    hintText: '0.00',
                    prefixText: '₹ ',
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    //  fillColor: Colors.grey.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Total Amount and Dues
            Row(
              children: [
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'Total Amount *',
                    controller: controller.amountController,
                    hintText: '0.00',
                    prefixText: '₹ ',
                    keyboardType: TextInputType.number,
                    validator: controller.validateAmount,
                  ),
                ),
                // const SizedBox(width: 16),
                // Expanded(
                //   child: buildStyledTextField(
                //     labelText: 'Dues',
                //     controller: controller.duesController,
                //     hintText: '0.00',
                //     prefixText: '₹ ',
                //     keyboardType: TextInputType.number,
                //     readOnly: true,
                //    // fillColor: Colors.grey.withValues(alpha: 0.1),
                //   ),
                // ),
              ],
            ),

            const SizedBox(height: 24),
            _buildSectionTitle('Items', Icons.inventory_2),
            const SizedBox(height: 16),

            // Items List
            Obx(
              () => Column(
                children: [
                  ...controller.billItems.asMap().entries.map((entry) {
                    int index = entry.key;
                    BillItem item = entry.value;
                    return _buildItemCard(controller, item, index);
                  }).toList(),

                  // Add Item Button
                  Container(
                    width: double.infinity,
                    height: 48,
                    margin: const EdgeInsets.only(top: 12),
                    child: OutlinedButton.icon(
                      onPressed: controller.addNewItem,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Item'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: const Color(0xFF10B981).withValues(alpha: 0.3),
                        ),
                        foregroundColor: const Color(0xFF10B981),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  // Show message if no items
                  if (controller.billItems.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No items added yet',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Click "Add Item" to add your first item',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle('Invoice File (Optional)', Icons.attach_file),
            const SizedBox(height: 16),

            // File Upload Section
            _buildFileUploadSection(controller),

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
                            controller.isAddingBill.value
                                ? null
                                : controller.cancelAddBill,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            controller.isAddingBill.value
                                ? null
                                : controller.addBillToSystem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child:
                            controller.isAddingBill.value
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
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Create Purchase Bill',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
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
                  controller.hasAddBillError.value
                      ? Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.errorLight.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppColors.errorLight,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.addBillErrorMessage.value,
                                style: const TextStyle(
                                  color: AppColors.errorLight,
                                  fontSize: 12,
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

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF10B981)),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStatusToggle(AddNewStockOperationController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Status *',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.isPaid.value = true;
                      controller.onPaymentStatusChanged();
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color:
                            controller.isPaid.value
                                ? const Color(0xFF10B981)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color:
                                  controller.isPaid.value
                                      ? Colors.white
                                      : const Color(0xFF6B7280),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Paid',
                              style: TextStyle(
                                color:
                                    controller.isPaid.value
                                        ? Colors.white
                                        : const Color(0xFF6B7280),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.isPaid.value = false;
                      controller.onPaymentStatusChanged();
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color:
                            !controller.isPaid.value
                                ? const Color(0xFFEF4444)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pending,
                              color:
                                  !controller.isPaid.value
                                      ? Colors.white
                                      : const Color(0xFF6B7280),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Unpaid',
                              style: TextStyle(
                                color:
                                    !controller.isPaid.value
                                        ? Colors.white
                                        : const Color(0xFF6B7280),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(
    AddNewStockOperationController controller,
    BillItem item,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item header with remove button
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Item ${index + 1}',
                  style: const TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => controller.removeItem(index),
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.errorLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: AppColors.errorLight,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Category Dropdown
          Obx(
            () => buildStyledDropdown(
              labelText: 'Category *',
              hintText: 'Select Category',
              value: item.category.value.isEmpty ? null : item.category.value,
              items: controller.categories,
              onChanged: (String? newValue) {
                controller.updateItemField(index, 'category', newValue ?? '');
              },
            ),
          ),
          const SizedBox(height: 16),

          // Company and Model Row
          Row(
            children: [
              Expanded(
                child: buildStyledTextField(
                  labelText: 'Company *',
                  controller: item.companyController,
                  hintText: 'Enter company name',
                  onChanged: (value) {
                    controller.updateItemField(index, 'company', value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Company is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: buildStyledTextField(
                  labelText: 'Model *',
                  controller: item.modelController,
                  hintText: 'Enter model name',
                  onChanged: (value) {
                    controller.updateItemField(index, 'model', value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Model is required';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Show RAM and ROM only for SMARTPHONE category
          Obx(
            () =>
                item.category.value.toUpperCase() == 'SMARTPHONE' ||
                        item.category.value.toUpperCase() == 'TABLET'
                    ? Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: buildStyledTextField(
                                labelText: 'RAM (GB) *',
                                controller: item.ramController,
                                hintText: 'Enter RAM (e.g., 8)',
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  controller.updateItemField(
                                    index,
                                    'ram',
                                    value,
                                  );
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'RAM is required';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Enter valid RAM';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: buildStyledTextField(
                                labelText: 'ROM (GB) *',
                                controller: item.romController,
                                hintText: 'Enter ROM (e.g., 128)',
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  controller.updateItemField(
                                    index,
                                    'rom',
                                    value,
                                  );
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'ROM is required';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Enter valid ROM';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                    : const SizedBox.shrink(),
          ),

          // Color and Quantity Row
          Row(
            children: [
              Expanded(
                child: buildStyledTextField(
                  labelText: 'Color *',
                  controller: item.colorController,
                  hintText: 'Enter color',
                  onChanged: (value) {
                    controller.updateItemField(index, 'color', value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Color is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: buildStyledTextField(
                  labelText: 'Quantity *',
                  controller: item.qtyController,
                  hintText: '1',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    controller.updateItemField(index, 'qty', value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Enter valid quantity';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Selling Price
          buildStyledTextField(
            labelText: 'Selling Price *',
            controller: item.priceController,
            hintText: '0',
            prefixText: '₹ ',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              controller.updateItemField(index, 'sellingPrice', value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Price is required';
              }
              if (double.tryParse(value) == null || double.parse(value) <= 0) {
                return 'Enter valid price';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Description
          buildStyledTextField(
            labelText: 'Description (Optional)',
            controller: item.descriptionController,
            hintText: 'Enter item description',
            maxLines: 3,
            onChanged: (value) {
              controller.updateItemField(index, 'description', value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFileUploadSection(AddNewStockOperationController controller) {
    return Obx(
      () => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2),
            style: BorderStyle.solid,
          ),
        ),
        child:
            controller.selectedFile.value != null
                ? _buildSelectedFileCard(controller)
                : _buildFilePickerButton(controller),
      ),
    );
  }

  Widget _buildFilePickerButton(AddNewStockOperationController controller) {
    return Obx(
      () => InkWell(
        onTap: controller.isFileUploading.value ? null : controller.pickFile,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.isFileUploading.value)
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF10B981),
                    ),
                  ),
                )
              else
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.cloud_upload_rounded,
                    color: Color(0xFF10B981),
                    size: 24,
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                controller.isFileUploading.value
                    ? 'Selecting file...'
                    : 'Upload Invoice (Optional)',
                style: const TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                controller.isFileUploading.value
                    ? 'Please wait'
                    : 'Click to select JPG, PNG, or PDF file',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedFileCard(AddNewStockOperationController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getFileIcon(controller.fileName.value),
              color: const Color(0xFF10B981),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.fileName.value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'File selected successfully',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: controller.removeFile,
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.errorLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.close,
                color: AppColors.errorLight,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    String extension = fileName.toLowerCase().split('.').last;
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.attach_file;
    }
  }
}
