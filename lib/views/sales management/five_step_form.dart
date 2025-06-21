// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mobistock/controllers/sales_managenment_controller.dart';
// import 'package:mobistock/views/sales%20management/salesformstep1.dart';
// import 'package:mobistock/views/sales%20management/salesformstep2.dart';
// import 'package:mobistock/views/sales%20management/salesformstep3.dart';
// import 'package:mobistock/views/sales%20management/salesformstep4.dart';
// import 'package:mobistock/views/sales%20management/salesformstep5.dart';

// class FiveStepForm extends StatelessWidget {
//   final SalesManagementController controller = Get.put(SalesManagementController());

//   final List<Widget> steps = [
//     Salesformstep1(),
//     SalesFormStep2(),
//     Salesformstep3(),
//     Salesformstep4(),
//     SalesFormStep5() // We'll define this next
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Sales Form")),
//       body: Obx(() => steps[controller.currentStep.value]),
//       bottomNavigationBar: Obx(() => BottomAppBar(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             if (controller.currentStep.value > 0)
//               TextButton(
//                 onPressed: controller.previousStep,
//                 child: Text("Back"),
//               ),
//             if (controller.currentStep.value < 4)
//               ElevatedButton(
//                 onPressed: controller.nextStep,
//                 child: Text("Next"),
//               ),
//             if (controller.currentStep.value == 4)
//               ElevatedButton(
//                 onPressed: controller.goToSalesManagementScreen,
//                 child: Text("Finish"),
//               ),
//           ],
//         ),
//       )),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobistock/controllers/sales_managenment_controller.dart';
import 'package:mobistock/views/sales%20management/widgets/sales_widgets.dart';

class FiveStepForm extends StatefulWidget {
  const FiveStepForm({super.key});

  @override
  State<FiveStepForm> createState() => _FiveStepFormState();
}

class _FiveStepFormState extends State<FiveStepForm> {
  final SalesManagementController controller = Get.put(
    SalesManagementController(),
  );
  int currentStep = 0;
  // Removed invalid getSteps list, as Step is not a Widget.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stepper(
          currentStep: currentStep,
          onStepContinue: () {
            setState(() {
              currentStep += 1;
            });
        
          },
          onStepCancel:() {
            setState(() {
              currentStep -= 1;
            });
          },




          steps: [
            /// Step one
            Step(
              isActive: currentStep >=0,
              title: Text("stepOne"),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: controller.salesformstep1,
                  child: Column(
                    children: [
                      Obx(
                        () => SalesWidgets.salesDropdownButton(
                          items: controller.company,
                          selectedItem: controller.selectedCompany.value,
                          onChanged: controller.setSelectedCompany,
                          label: 'Company',
                        ),
                      ),
                      SizedBox(height: 20),
                      Obx(
                        () => SalesWidgets.salesDropdownButton(
                          items: controller.model,
                          selectedItem: controller.selectedModel.value,
                          onChanged: controller.setSelectedModel,
                          label: 'Select Model',
                        ),
                      ),
                      SizedBox(height: 20),
                      Obx(
                        () => SalesWidgets.salesDropdownButton(
                          items: controller.ram,
                          selectedItem: controller.selectedRam.value,
                          onChanged: controller.setSelectedRam,
                          label: 'Select RAM',
                        ),
                      ),
                      SizedBox(height: 20),
                      Obx(
                        () => SalesWidgets.salesDropdownButton(
                          items: controller.color,
                          selectedItem: controller.selectedColor.value,
                          onChanged: controller.setSelectedColor,
                          label: 'Select Color',
                        ),
                      ),
                      SizedBox(height: 20),
        
                      SizedBox(height: 20),
        
                      SalesWidgets.salesTextFormField(
                        controller: controller.quantity,
                        keyboardType: TextInputType.number,
                        // textInputAction: TextInputAction.next,
                        label: 'Enter Details',
                        validator: controller.requiredField,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        
            //Step two
            Step(
              isActive: currentStep >=1,

              title: Text("Steptow"),
              content: Form(
                child: Column(
                  children: [
                    SalesWidgets.salesTitle(title: "Payment Type"),
                    SizedBox(height: 10),
                    Obx(
                      () => SalesWidgets.salesRadioButton(
                        title: 'Full Payment',
                        value: true,
                        groupValue: controller.radioGroupValue.value,
                        onChanged: controller.setRadioValue,
                      ),
                    ),
                    Obx(
                      () => SalesWidgets.salesRadioButton(
                        title: 'EMI Payment',
                        value: false,
                        groupValue: controller.radioGroupValue.value,
                        onChanged: controller.setRadioValue,
                      ),
                    ),
                    SizedBox(height: 10),
                    SalesWidgets.salesTitle(title: "EMI Type"),
                    SizedBox(height: 20),
        
                    Obx(
                      () => SalesWidgets.salesRadioButton(
                        title: 'Company EMI',
                        value: true,
                        groupValue: controller.radioGroupValue.value,
                        onChanged: controller.setRadioValue,
                      ),
                    ),
                    Obx(
                      () => SalesWidgets.salesRadioButton(
                        title: 'Shop EMI',
                        value: false,
                        groupValue: controller.radioGroupValue.value,
                        onChanged: controller.setRadioValue,
                      ),
                    ),
        
                    SizedBox(height: 20),
                    SalesWidgets.salesTextFormField(
                      controller: controller.customerNameController,
                      keyboardType: TextInputType.text,
                      // textInputAction: TextInputAction.next,
                      label: 'Down Payment(₹)',
                    ),
                    SizedBox(height: 20),
        
                    SalesWidgets.salesTextFormField(
                      controller: controller.customerAddressController,
                      keyboardType: TextInputType.text,
                      // textInputAction: TextInputAction.next,
                      label: 'Remaining EMI Amount(₹)',
                    ),
                    SizedBox(height: 20),
                    SalesWidgets.salesTextFormField(
                      controller: controller.customerPhoneController,
                      keyboardType: TextInputType.text,
                      // textInputAction: TextInputAction.next,
                      label: 'Monthly EMI Amount(₹)',
                    ),
                    SizedBox(height: 20),
        
                    Obx(
                      () => SalesWidgets.salesDropdownButton(
                        items: controller.emi,
                        selectedItem: controller.selectedEmi.value,
                        onChanged: controller.setSelectedEmi,
                        label: 'EMi Tenure(Months)',
                      ),
                    ),
        
                    //     text: 'Submit',
                    //     onPressed: controller.onButtonPressed,
                    //     color: Colors.green,
                    //     textColor: Colors.white,
                    //     fontSize: 18,
                    //     height: 50,
                    //     width: 200,
                    //   ),
                  ],
                ),
              ),
            ),
            // Step three
            Step(
              isActive: currentStep >=2,

              title: Text("Step Three"),
              content: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SalesWidgets.salesTitle(title: "Base Price(₹)"),
                    SizedBox(height: 20),
                    SalesWidgets.salesTextFormField(
                      controller: controller.basePriceController,
                      keyboardType: TextInputType.number,
                      // textInputAction: TextInputAction.next,
                      label: 'Enter Base Price',
                    ),
                    SizedBox(height: 10),
                    SalesWidgets.salesTitle(title: "GST(₹)"),
                    SizedBox(height: 20),
                    SalesWidgets.salesTextFormField(
                      controller: controller.gstController,
                      keyboardType: TextInputType.text,
                      // textInputAction: TextInputAction.next,
                      label: 'Enter GST Amount',
                    ),
                    SizedBox(height: 10),
                    SalesWidgets.salesTitle(title: "Accessories (₹)"),
                    SizedBox(height: 20),
                    SalesWidgets.salesTextFormField(
                      controller: controller.accessoriesController,
                      keyboardType: TextInputType.text,
                      // textInputAction: TextInputAction.next,
                      label: 'Enter Accessories Cost',
                    ),
                    SizedBox(height: 10),
                    SalesWidgets.salesTitle(title: "Repair (₹)"),
                    SizedBox(height: 20),
                    SalesWidgets.salesTextFormField(
                      controller: controller.repairController,
                      keyboardType: TextInputType.text,
                      // textInputAction: TextInputAction.next,
                      label: 'Enter Repair Cost',
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 10),
                    SalesWidgets.salesTitle(title: "Discount (₹)"),
                    SizedBox(height: 20),
                    SalesWidgets.salesTextFormField(
                      controller: controller.discountController,
                      keyboardType: TextInputType.text,
                      // textInputAction: TextInputAction.next,
                      label: 'Enter Discount Amount',
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
                      children: [
                        Text(
                          "Fainal Total Amount",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          " ₹8397598374  ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        
            //Step Four
            Step(
              isActive: currentStep >=3,

              title: Text("Step Four"),
              content: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SalesWidgets.salesTitle(title: "Csustomer Name"),
                    SizedBox(height: 20),
                    SalesWidgets.salesTextFormField(
                      controller: controller.customerNameController,
                      keyboardType: TextInputType.text,
                      // textInputAction: TextInputAction.next,
                      label: 'Enter Customer Name',
                    ),
                    SizedBox(height: 10),
                    SalesWidgets.salesTitle(title: "Customer Phone"),
                    SizedBox(height: 20),
                    SalesWidgets.salesTextFormField(
                      controller: controller.phoneNoController,
                      keyboardType: TextInputType.text,
                      // textInputAction: TextInputAction.next,
                      label: 'Enter Phone Number',
                    ),
                    SizedBox(height: 10),
                    SalesWidgets.salesTitle(
                      title: "Customer Email (optional)",
                    ),
                    SizedBox(height: 20),
                    SalesWidgets.salesTextFormField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.text,
                      // textInputAction: TextInputAction.next,
                      label: 'Enter Email Address',
                    ),
                    SizedBox(height: 10),
                    SalesWidgets.salesTitle(
                      title: "Customer Address (optional)",
                    ),
                    SizedBox(height: 20),
                    SalesWidgets.salesTextFormField(
                      controller: controller.addressController,
                      keyboardType: TextInputType.text,
                      // textInputAction: TextInputAction.next,
                      label: 'Enter Address',
                    ),
                    SizedBox(height: 20),
        
                    SalesWidgets.salesTitle(
                      title: "Upload Bill/Invoice (optional)",
                    ),
                    SizedBox(height: 20),
                    SalesWidgets.salesTextFormField(
                      controller: TextEditingController(),
                      keyboardType: TextInputType.text,
                      // textInputAction: TextInputAction.next,
                      label: 'Choose File',
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Upload Bill/Invoice for Warranty Claimc(PDF, JPG, PNG)",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        
            // Step Five
            Step(
              isActive: currentStep >=4,
              
              title: Text('Step Five '),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                
  
        
                children: [
                  Text(
                    "Preview",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(),
        
                  SalesWidgets.previewItem(
                    "Company",
                    controller.selectedCompany.value,
                  ),
                  SalesWidgets.previewItem(
                    "Model",
                    controller.selectedModel.value,
                  ),
                  SalesWidgets.previewItem(
                    "RAM",
                    controller.selectedRam.value,
                  ),
                  SalesWidgets.previewItem(
                    "Color",
                    controller.selectedColor.value,
                  ),
                  SalesWidgets.previewItem(
                    "Quantity",
                    controller.quantity.text,
                  ),
        
                  Divider(),
                  SalesWidgets.previewItem(
                    "Payment Type",
                    controller.radioGroupValue.value
                        ? "Full Payment"
                        : "EMI Payment",
                  ),
                  SalesWidgets.previewItem(
                    "EMI Type",
                    controller.radioGroupValue.value
                        ? "Company EMI"
                        : "Shop EMI",
                  ),
                  SalesWidgets.previewItem(
                    "Down Payment",
                    controller.customerNameController.text,
                  ),
                  SalesWidgets.previewItem(
                    "Remaining EMI",
                    controller.customerAddressController.text,
                  ),
                  SalesWidgets.previewItem(
                    "Monthly EMI",
                    controller.customerPhoneController.text,
                  ),
                  SalesWidgets.previewItem(
                    "EMI Tenure",
                    controller.selectedEmi.value,
                  ),
        
                  Divider(),
                  SalesWidgets.previewItem(
                    "Base Price",
                    controller.basePriceController.text,
                  ),
                  SalesWidgets.previewItem(
                    "GST",
                    controller.gstController.text,
                  ),
                  SalesWidgets.previewItem(
                    "Accessories",
                    controller.accessoriesController.text,
                  ),
                  SalesWidgets.previewItem(
                    "Repair",
                    controller.repairController.text,
                  ),
                  SalesWidgets.previewItem(
                    "Discount",
                    controller.discountController.text,
                  ),
        
                  Divider(),
                  SalesWidgets.previewItem(
                    "Customer Name",
                    controller.customerNameController.text,
                  ),
                  SalesWidgets.previewItem(
                    "Phone",
                    controller.phoneNoController.text,
                  ),
                  SalesWidgets.previewItem(
                    "Email",
                    controller.emailController.text,
                  ),
                  SalesWidgets.previewItem(
                    "Address",
                    controller.addressController.text,
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












  // Widget stepOneWidget() {
  //   return Form(
  //     // key: controller.salesformstep1,
  //     child: ListView(
  //       shrinkWrap: true,
  //       physics: NeverScrollableScrollPhysics(),
  //       children: [
  //         Obx(
  //           () => SalesWidgets.salesDropdownButton(
  //             items: controller.company,
  //             selectedItem: controller.selectedCompany.value,
  //             onChanged: controller.setSelectedCompany,
  //             label: 'Company',
  //           ),
  //         ),
  //         SizedBox(height: 20),
  //         Obx(
  //           () => SalesWidgets.salesDropdownButton(
  //             items: controller.model,
  //             selectedItem: controller.selectedModel.value,
  //             onChanged: controller.setSelectedModel,
  //             label: 'Select Model',
  //           ),
  //         ),
  //         SizedBox(height: 20),
  //         Obx(
  //           () => SalesWidgets.salesDropdownButton(
  //             items: controller.ram,
  //             selectedItem: controller.selectedRam.value,
  //             onChanged: controller.setSelectedRam,
  //             label: 'Select RAM',
  //           ),
  //         ),
  //         SizedBox(height: 20),
  //         Obx(
  //           () => SalesWidgets.salesDropdownButton(
  //             items: controller.color,
  //             selectedItem: controller.selectedColor.value,
  //             onChanged: controller.setSelectedColor,
  //             label: 'Select Color',
  //           ),
  //         ),
  //         SizedBox(height: 20),

  //         SizedBox(height: 20),

  //         SalesWidgets.salesTextFormField(
  //           controller: controller.quantity,
  //           keyboardType: TextInputType.number,
  //           label: 'Enter Details',
  //           validator: (value) {
  //             if (value == null || value.isEmpty) {
  //               return 'Please enter details';
  //             }
  //             return null;
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget stepTwoWidget() {
  //   return Form(
  //     child: ListView(
  //       children: [
  //         SalesWidgets.salesTitle(title: "Payment Type"),
  //         SizedBox(height: 10),
  //         Obx(
  //           () => SalesWidgets.salesRadioButton(
  //             title: 'Full Payment',
  //             value: true,
  //             groupValue: controller.radioGroupValue.value,
  //             onChanged: controller.setRadioValue,
  //           ),
  //         ),
  //         Obx(
  //           () => SalesWidgets.salesRadioButton(
  //             title: 'EMI Payment',
  //             value: false,
  //             groupValue: controller.radioGroupValue.value,
  //             onChanged: controller.setRadioValue,
  //           ),
  //         ),
  //         SizedBox(height: 10),
  //         SalesWidgets.salesTitle(title: "EMI Type"),
  //         SizedBox(height: 20),

  //         Obx(
  //           () => SalesWidgets.salesRadioButton(
  //             title: 'Company EMI',
  //             value: true,
  //             groupValue: controller.radioGroupValue.value,
  //             onChanged: controller.setRadioValue,
  //           ),
  //         ),
  //         Obx(
  //           () => SalesWidgets.salesRadioButton(
  //             title: 'Shop EMI',
  //             value: false,
  //             groupValue: controller.radioGroupValue.value,
  //             onChanged: controller.setRadioValue,
  //           ),
  //         ),

  //         SizedBox(height: 20),
  //         SalesWidgets.salesTextFormField(
  //           controller: TextEditingController(),
  //           keyboardType: TextInputType.text,
  //           // textInputAction: TextInputAction.next,
  //           label: 'Down Payment(₹)',
  //         ),
  //         SizedBox(height: 20),

  //         SalesWidgets.salesTextFormField(
  //           controller: TextEditingController(),
  //           keyboardType: TextInputType.text,
  //           // textInputAction: TextInputAction.next,
  //           label: 'Remaining EMI Amount(₹)',
  //         ),
  //         SizedBox(height: 20),
  //         SalesWidgets.salesTextFormField(
  //           controller: TextEditingController(),
  //           keyboardType: TextInputType.text,
  //           // textInputAction: TextInputAction.next,
  //           label: 'Monthly EMI Amount(₹)',
  //         ),
  //         SizedBox(height: 20),

  //         Obx(
  //           () => SalesWidgets.salesDropdownButton(
  //             items: controller.emi,
  //             selectedItem: controller.selectedEmi.value,
  //             onChanged: controller.setSelectedEmi,
  //             label: 'EMi Tenure(Months)',
  //           ),
  //         ),

  //         //     text: 'Submit',
  //         //     onPressed: controller.onButtonPressed,
  //         //     color: Colors.green,
  //         //     textColor: Colors.white,
  //         //     fontSize: 18,
  //         //     height: 50,
  //         //     width: 200,
  //         //   ),
  //       ],
  //     ),
  //   );
  // }

  // Widget stepThreeWidget() {
  //   return Form(
  //     key: controller.salesformstep1,
  //     child: ListView(
  //       shrinkWrap: true,
  //       physics: BouncingScrollPhysics(),
  //       children: [
  //         SalesWidgets.salesTitle(title: "Base Price(₹)"),
  //         SizedBox(height: 20),
  //         SalesWidgets.salesTextFormField(
  //           controller: controller.basePriceController,
  //           keyboardType: TextInputType.number,
  //           // textInputAction: TextInputAction.next,
  //           label: 'Enter Base Price',
  //         ),
  //         SizedBox(height: 10),
  //         SalesWidgets.salesTitle(title: "GST(₹)"),
  //         SizedBox(height: 20),
  //         SalesWidgets.salesTextFormField(
  //           controller: controller.gstController,
  //           keyboardType: TextInputType.text,
  //           // textInputAction: TextInputAction.next,
  //           label: 'Enter GST Amount',
  //         ),
  //         SizedBox(height: 10),
  //         SalesWidgets.salesTitle(title: "Accessories (₹)"),
  //         SizedBox(height: 20),
  //         SalesWidgets.salesTextFormField(
  //           controller: controller.accessoriesController,
  //           keyboardType: TextInputType.text,
  //           // textInputAction: TextInputAction.next,
  //           label: 'Enter Accessories Cost',
  //         ),
  //         SizedBox(height: 10),
  //         SalesWidgets.salesTitle(title: "Repair (₹)"),
  //         SizedBox(height: 20),
  //         SalesWidgets.salesTextFormField(
  //           controller: controller.repairController,
  //           keyboardType: TextInputType.text,
  //           // textInputAction: TextInputAction.next,
  //           label: 'Enter Repair Cost',
  //         ),
  //         SizedBox(height: 20),
  //         SizedBox(height: 10),
  //         SalesWidgets.salesTitle(title: "Discount (₹)"),
  //         SizedBox(height: 20),
  //         SalesWidgets.salesTextFormField(
  //           controller: controller.discountController,
  //           keyboardType: TextInputType.text,
  //           // textInputAction: TextInputAction.next,
  //           label: 'Enter Discount Amount',
  //         ),
  //         SizedBox(height: 20),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,

  //           children: [
  //             Text(
  //               "Fainal Total Amount",
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
  //             ),
  //             Text(
  //               " ₹8397598374  ",
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget stepForWidget() {
  //   return Form(
  //     key: controller.salesformstep1,
  //     child: ListView(
  //       shrinkWrap: true,
  //       physics: BouncingScrollPhysics(),
  //       children: [
  //         SalesWidgets.salesTitle(title: "Csustomer Name"),
  //         SizedBox(height: 20),
  //         SalesWidgets.salesTextFormField(
  //           controller:controller. customerNameController,
  //           keyboardType: TextInputType.text,
  //           // textInputAction: TextInputAction.next,
  //           label: 'Enter Customer Name',
  //         ),
  //         SizedBox(height: 10),
  //         SalesWidgets.salesTitle(title: "Customer Phone"),
  //         SizedBox(height: 20),
  //         SalesWidgets.salesTextFormField(
  //           controller: controller. phoneNoController,
  //           keyboardType: TextInputType.text,
  //           // textInputAction: TextInputAction.next,
  //           label: 'Enter Phone Number',
  //         ),
  //         SizedBox(height: 10),
  //         SalesWidgets.salesTitle(title: "Customer Email (optional)"),
  //         SizedBox(height: 20),
  //         SalesWidgets.salesTextFormField(
  //           controller:controller. emailController,
  //           keyboardType: TextInputType.text,
  //           // textInputAction: TextInputAction.next,
  //           label: 'Enter Email Address',
  //         ),
  //         SizedBox(height: 10),
  //         SalesWidgets.salesTitle(title: "Customer Address (optional)"),
  //         SizedBox(height: 20),
  //         SalesWidgets.salesTextFormField(
  //           controller:controller. addressController,
  //           keyboardType: TextInputType.text,
  //           // textInputAction: TextInputAction.next,
  //           label: 'Enter Address',
  //         ),
  //         SizedBox(height: 20),

  //         SalesWidgets.salesTitle(title: "Upload Bill/Invoice (optional)"),
  //         SizedBox(height: 20),
  //         SalesWidgets.salesTextFormField(
  //           controller: TextEditingController(),
  //           keyboardType: TextInputType.text,
  //           // textInputAction: TextInputAction.next,
  //           label: 'Choose File',
  //         ),
  //         SizedBox(height: 20),
  //         Text(
  //           "Upload Bill/Invoice for Warranty Claimc(PDF, JPG, PNG)",
  //           style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //         ),
  //       ],
  //     ),
  //   );
  // }

