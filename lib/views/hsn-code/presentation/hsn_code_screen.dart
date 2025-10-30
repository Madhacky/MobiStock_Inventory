import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/bottom_navigation_screen.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:smartbecho/views/hsn-code/controllers/hsn_code_controller.dart';
import 'package:smartbecho/views/hsn-code/models/hsn_code_model.dart';
import 'package:smartbecho/views/hsn-code/widgets/add_and_edit_hsncode.dart';
import 'package:smartbecho/views/hsn-code/widgets/hsn_code_card.dart';
import 'package:smartbecho/views/hsn-code/widgets/hsn_code_table.dart';

class HsnCodeScreen extends StatelessWidget {
  HsnCodeScreen({super.key});
  TextEditingController searchController = TextEditingController();
  final HsnCodeController controller = Get.put(HsnCodeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
            () => AddEditHsnCodeForm(
              itemCategories: controller.itemCategories,
              onSave: (Map<String, dynamic> data) {
                controller.addHsnCode(data);
              },
            ),
          );
        },
        backgroundColor: const Color(0xFF16A085),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: SafeArea(
        child: Column(
          children: [
            buildCustomAppBar(
              "HSN Code Management",
              isdark: true,
              onPressed: () {
                Get.find<BottomNavigationController>().setIndex(0);
                Get.back();
              },
              actionItem: IconButton(
                onPressed: () {
                  controller.fetchHsnCodes();
                },
                icon: Icon(Icons.refresh, color: Colors.teal),
              ),
            ),
            Expanded(
              child: Obx(
                () =>
                    controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            children: [
                              _buildHeader(context),
                              const SizedBox(height: 20),
                              Expanded(child: _buildCardView()),
                              if (controller.totalPages.value > 1)
                                _buildPagination(),
                            ],
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.teal.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          // Row(
          //   children: [
          //     Obx(
          //       () => ToggleButtons(
          //         borderRadius: BorderRadius.circular(8),
          //         selectedColor: Colors.white,
          //         fillColor: Colors.teal,
          //         color: Colors.teal,
          //         constraints: const BoxConstraints(
          //           minHeight: 40,
          //           minWidth: 80,
          //         ),
          //         isSelected: [
          //           controller.isTableView.value,
          //           !controller.isTableView.value,
          //         ],
          //         onPressed: (index) {
          //           controller.toggleView();
          //         },
          //         children: const [
          //           Padding(
          //             padding: EdgeInsets.symmetric(horizontal: 12),
          //             child: Row(
          //               children: [
          //                 Icon(Icons.table_chart, size: 18),
          //                 SizedBox(width: 4),
          //                 Text('Table'),
          //               ],
          //             ),
          //           ),
          //           Padding(
          //             padding: EdgeInsets.symmetric(horizontal: 12),
          //             child: Row(
          //               children: [
          //                 Icon(Icons.grid_view, size: 18),
          //                 SizedBox(width: 4),
          //                 Text('Cards'),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),

          //     // const Spacer(),
          //   ],
          // ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Search Field
              Container(
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  // onChanged: (value) => controller.searchHsnCodes(value),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search HSN codes...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.teal,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.teal,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),

              // Filter Button
              // Container(
              //   height: 48,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.teal.withOpacity(0.1),
              //         blurRadius: 10,
              //         offset: const Offset(0, 2),
              //       ),
              //     ],
              //   ),
              //   child: OutlinedButton.icon(
              //     onPressed: () {
              //       controller.searchHsnCodes(searchController.text);
              //     },
              //     icon: const Icon(Icons.filter_list, size: 18),
              //     label: const Text(
              //       'Filter',
              //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              //     ),
              //     style: OutlinedButton.styleFrom(
              //       foregroundColor: Colors.teal,
              //       side: BorderSide(
              //         color: Colors.teal.withOpacity(0.3),
              //         width: 1.5,
              //       ),
              //       backgroundColor: Colors.teal.withOpacity(0.05),
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 20,
              //         vertical: 12,
              //       ),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //   ),
              // ),

              // Add HSN Code Button (Commented)
              // ElevatedButton.icon(
              //   onPressed: () => _showAddEditDialog(context),
              //   icon: const Icon(Icons.add),
              //   label: const Text('Add HSN Code'),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.teal,
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 20,
              //       vertical: 12,
              //     ),
              //   ),
              // ),

              // Export Button
              // Container(
              //   height: 48,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.teal.withOpacity(0.1),
              //         blurRadius: 10,
              //         offset: const Offset(0, 2),
              //       ),
              //     ],
              //   ),
              //   child: OutlinedButton.icon(
              //     onPressed: () {
              //       Get.snackbar(
              //         'Coming Soon',
              //         'Export feature coming soon!',
              //         snackPosition: SnackPosition.BOTTOM,
              //         backgroundColor: Colors.orangeAccent,
              //         colorText: Colors.white,
              //       );
              //     },
              //     icon: const Icon(Icons.download, size: 18),
              //     label: const Text(
              //       'Export',
              //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              //     ),
              //     style: OutlinedButton.styleFrom(
              //       foregroundColor: Colors.teal,
              //       side: BorderSide(
              //         color: Colors.teal.withOpacity(0.3),
              //         width: 1.5,
              //       ),
              //       backgroundColor: Colors.teal.withOpacity(0.05),
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 20,
              //         vertical: 12,
              //       ),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'HSN Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Item Category',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'GST %',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Description',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Action',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.hsnCodes.length,
                itemBuilder: (context, index) {
                  final hsnCode = controller.hsnCodes[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Text(hsnCode.hsnCode)),
                        Expanded(flex: 2, child: Text(hsnCode.itemCategory)),
                        Expanded(
                          flex: 1,
                          child: Text('${hsnCode.gstPercentage}%'),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(hsnCode.description ?? '-'),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  hsnCode.isActive
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              hsnCode.isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                color:
                                    hsnCode.isActive
                                        ? Colors.green
                                        : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed:
                                    () => _showAddEditDialog(
                                      context,
                                      hsnCode: hsnCode,
                                    ),
                                icon: const Icon(Icons.edit),
                                color: Colors.blue,
                              ),
                              IconButton(
                                onPressed:
                                    () => _confirmDelete(
                                      context,
                                      hsnCode.id.toString(),
                                    ),
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardView() {
    return Obx(
      () => GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        padding: const EdgeInsets.all(16),
        itemCount: controller.hsnCodes.length,
        itemBuilder: (context, index) {
          final hsnCode = controller.hsnCodes[index];
          return HsnCodeCard(
            hsnCode: hsnCode,
            // onEdit: () => _showAddEditDialog(context, hsnCode: hsnCode),
            onEdit: () {
              Get.to(
                () => AddEditHsnCodeForm(
                  hsnCode: hsnCode,
                  itemCategories: controller.itemCategories,
                  onSave: (data) {
                    // this onEdit path deals with an existing hsnCode, so update it
                    controller.updateHsnCode(hsnCode.id.toString(), data);
                    Get.back();
                  },
                ),
              );
            },
            onDelete: () => _confirmDelete(context, hsnCode.id.toString()),
          );
        },
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed:
                controller.currentPage.value > 0
                    ? () => controller.fetchHsnCodes(
                      page: controller.currentPage.value - 1,
                    )
                    : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Obx(
            () => Text(
              'Page ${controller.currentPage.value + 1} of ${controller.totalPages.value}',
            ),
          ),
          IconButton(
            onPressed:
                controller.currentPage.value < controller.totalPages.value - 1
                    ? () => controller.fetchHsnCodes(
                      page: controller.currentPage.value + 1,
                    )
                    : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, {HsnCodeModel? hsnCode}) {
    final isEdit = hsnCode != null;
    final hsnCodeController = TextEditingController(text: hsnCode?.hsnCode);
    final descriptionController = TextEditingController(
      text: hsnCode?.description,
    );
    final gstController = TextEditingController(
      text: hsnCode?.gstPercentage.toString(),
    );
    String selectedCategory = hsnCode?.itemCategory ?? '';
    bool isActive = hsnCode?.isActive ?? true;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(isEdit ? 'Edit HSN Code' : 'Add New HSN Code'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: hsnCodeController,
                    decoration: const InputDecoration(
                      labelText: 'HSN Code *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      value: selectedCategory.isEmpty ? null : selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Item Category *',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          controller.itemCategories
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.replaceAll('_', ' ')),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        selectedCategory = value ?? '';
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: gstController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'GST Percentage *',
                      border: OutlineInputBorder(),
                      suffixText: '%',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  StatefulBuilder(
                    builder:
                        (context, setState) => DropdownButtonFormField<bool>(
                          value: isActive,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: true,
                              child: Text('Active'),
                            ),
                            DropdownMenuItem(
                              value: false,
                              child: Text('Inactive'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              isActive = value ?? true;
                            });
                          },
                        ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (hsnCodeController.text.isEmpty ||
                      selectedCategory.isEmpty ||
                      gstController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please fill all required fields',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  final data = {
                    'hsnCode': hsnCodeController.text,
                    'itemCategory': selectedCategory,
                    'gstPercentage': double.parse(gstController.text),
                    'description': descriptionController.text,
                    'isActive': isActive,
                  };

                  if (isEdit) {
                    controller.updateHsnCode(hsnCode.id.toString(), data);
                  } else {
                    controller.addHsnCode(data);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: Text(isEdit ? 'Update' : 'Save'),
              ),
            ],
          ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete HSN Code'),
            content: const Text(
              'Are you sure you want to delete this HSN code?',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.deleteHsnCode(id);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
