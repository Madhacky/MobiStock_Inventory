import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobistock/controllers/sales_managenment_controller.dart';
import 'package:mobistock/views/sales%20management/sales_managenment_screen.dart';
import 'package:mobistock/views/sales%20management/widgets/sales_widgets.dart';

class Fiveform extends StatefulWidget {
  const Fiveform({super.key});

  @override
  State<Fiveform> createState() => _FiveformState();
}

class _FiveformState extends State<Fiveform> {
    final SalesManagementController controller = Get.find<SalesManagementController>();

  
  // int currentStep = 0;

  List<Step> getSteps() {
    return [
      ///Step One
      Step(
        state:controller.currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive:controller. currentStep >= 0,
        title: Text("stepOne"),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            // key: controller.salesformstep1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
        state:controller. currentStep > 1 ? StepState.complete : StepState.indexed,

        isActive:controller. currentStep >= 1,

        title: Text("Steptwo"),
        content: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

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
                keyboardType: TextInputType.number,
                // textInputAction: TextInputAction.next,
                label: 'Down Payment(₹)',
                validator: controller.requiredField,
              ),
              SizedBox(height: 20),

              SalesWidgets.salesTextFormField(
                controller: controller.customerAddressController,
                keyboardType: TextInputType.number,
                // textInputAction: TextInputAction.next,
                label: 'Remaining EMI Amount(₹)',
                validator: controller.requiredField,
              ),
              SizedBox(height: 20),
              SalesWidgets.salesTextFormField(
                controller: controller.customerPhoneController,
                keyboardType: TextInputType.number,
                // textInputAction: TextInputAction.next,
                label: 'Monthly EMI Amount(₹)',
                validator: controller.requiredField,
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
        state:controller. currentStep > 2 ? StepState.complete : StepState.indexed,

        isActive:controller. currentStep >= 2,

        title: Text("Step Three"),
        content: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SalesWidgets.salesTitle(title: "Base Price(₹)"),
              SizedBox(height: 20),
              SalesWidgets.salesTextFormField(
                controller: controller.basePriceController,
                keyboardType: TextInputType.number,
                // textInputAction: TextInputAction.next,
                label: 'Enter Base Price',
                validator: controller.requiredField,
              ),
              SizedBox(height: 10),
              SalesWidgets.salesTitle(title: "GST(₹)"),
              SizedBox(height: 20),
              SalesWidgets.salesTextFormField(
                controller: controller.gstController,
                keyboardType: TextInputType.number,
                // textInputAction: TextInputAction.next,
                label: 'Enter GST Amount',
                validator: controller.requiredField,
              ),
              SizedBox(height: 10),
              SalesWidgets.salesTitle(title: "Accessories (₹)"),
              SizedBox(height: 20),
              SalesWidgets.salesTextFormField(
                controller: controller.accessoriesController,
                keyboardType: TextInputType.number,
                // textInputAction: TextInputAction.next,
                label: 'Enter Accessories Cost',
                validator: controller.requiredField,
              ),
              SizedBox(height: 10),
              SalesWidgets.salesTitle(title: "Repair (₹)"),
              SizedBox(height: 20),
              SalesWidgets.salesTextFormField(
                controller: controller.repairController,
                keyboardType: TextInputType.number,
                // textInputAction: TextInputAction.next,
                label: 'Enter Repair Cost',
                validator: controller.requiredField,
              ),
              SizedBox(height: 20),
              SizedBox(height: 10),
              SalesWidgets.salesTitle(title: "Discount (₹)"),
              SizedBox(height: 20),
              SalesWidgets.salesTextFormField(
                controller: controller.discountController,
                keyboardType: TextInputType.number,
                // textInputAction: TextInputAction.next,
                label: 'Enter Discount Amount',
                validator: controller.requiredField,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    "Fainal Total Amount",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    " ₹8397598374  ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      //Step Four
      Step(
        state:controller. currentStep > 3 ? StepState.complete : StepState.indexed,

        isActive:controller. currentStep >= 3,

        title: Text("Step Four"),
        content: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SalesWidgets.salesTitle(title: "Csustomer Name"),
              SizedBox(height: 20),
              SalesWidgets.salesTextFormField(
                controller: controller.customerNameController,
                keyboardType: TextInputType.name,
                // textInputAction: TextInputAction.next,
                label: 'Enter Customer Name',
                validator: controller.requiredField,
              ),
              SizedBox(height: 10),
              SalesWidgets.salesTitle(title: "Customer Phone"),
              SizedBox(height: 20),
              SalesWidgets.salesTextFormField(
                controller: controller.phoneNoController,
                keyboardType: TextInputType.phone,
                // textInputAction: TextInputAction.next,
                label: 'Enter Phone Number',
                validator: controller.requiredField,
              ),
              SizedBox(height: 10),
              SalesWidgets.salesTitle(title: "Customer Email (optional)"),
              SizedBox(height: 20),
              SalesWidgets.salesTextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                // textInputAction: TextInputAction.next,
                label: 'Enter Email Address',
                validator: controller.requiredField,
              ),
              SizedBox(height: 10),
              SalesWidgets.salesTitle(title: "Customer Address (optional)"),
              SizedBox(height: 20),
              SalesWidgets.salesTextFormField(
                controller: controller.addressController,
                keyboardType: TextInputType.streetAddress,
                // textInputAction: TextInputAction.next,
                label: 'Enter Address',
                validator: controller.requiredField,
              ),
              SizedBox(height: 20),

              SalesWidgets.salesTitle(title: "Upload Bill/Invoice (optional)"),
              SizedBox(height: 20),
              SalesWidgets.salesTextFormField(
                controller: TextEditingController(),
                keyboardType: TextInputType.text,
                // textInputAction: TextInputAction.next,
                label: 'Choose File',
                validator: controller.requiredField,
              ),
              SizedBox(height: 20),
              Text(
                "Upload Bill/Invoice for Warranty Claimc(PDF, JPG, PNG)",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),

      // Step Five
      Step(
        state:controller. currentStep > 4 ? StepState.complete : StepState.indexed,

        isActive:controller. currentStep >= 4,

        title: Text('Step Five '),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            Text(
              "Preview",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Divider(),

            SalesWidgets.previewItem(
              "Company",
              controller.selectedCompany.value,
            ),
            SalesWidgets.previewItem("Model", controller.selectedModel.value),
            SalesWidgets.previewItem("RAM", controller.selectedRam.value),
            SalesWidgets.previewItem("Color", controller.selectedColor.value),
            SalesWidgets.previewItem("Quantity", controller.quantity.text),

            Divider(),
            SalesWidgets.previewItem(
              "Payment Type",
              controller.radioGroupValue.value ? "Full Payment" : "EMI Payment",
            ),
            SalesWidgets.previewItem(
              "EMI Type",
              controller.radioGroupValue.value ? "Company EMI" : "Shop EMI",
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
            SalesWidgets.previewItem("GST", controller.gstController.text),
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
            SalesWidgets.previewItem("Email", controller.emailController.text),
            SalesWidgets.previewItem(
              "Address",
              controller.addressController.text,
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Stepper(
        onStepTapped: (step) => setState(() {
          controller.currentStep.value = step;
        }),
        steps: getSteps(),
        currentStep: controller.currentStep.value,
        onStepContinue: () {
          final isLastStep = controller.currentStep.value == getSteps().length - 1;
          if (isLastStep) {
            // Validate all fields before finishing
            bool allValid = 
              controller.selectedCompany.value.isNotEmpty && 
              controller.selectedModel.value.isNotEmpty &&
              controller.selectedRam.value.isNotEmpty &&
              controller.selectedColor.value.isNotEmpty &&
              controller.quantity.text.isNotEmpty &&
              controller.customerNameController.text.isNotEmpty &&
              controller.customerAddressController.text.isNotEmpty &&
              controller.customerPhoneController.text.isNotEmpty &&
              controller.selectedEmi.value.isNotEmpty &&
              controller.basePriceController.text.isNotEmpty &&
              controller.gstController.text.isNotEmpty &&
              controller.accessoriesController.text.isNotEmpty &&
              controller.repairController.text.isNotEmpty &&
              controller.discountController.text.isNotEmpty &&
              controller.phoneNoController.text.isNotEmpty &&
              controller.emailController.text.isNotEmpty &&
              controller.addressController.text.isNotEmpty;
            if (allValid) {
              Get.to(SalesManagenmentScreen());
            } else {
              Get.snackbar(
                'Error',
                'Please fill all required fields before finishing',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
            }
          } else {
            setState(() {
              controller.currentStep.value += 1;
            });
          }
        },
        onStepCancel: () {
          controller.currentStep.value == 0
              ? null
              : setState(() {
                  controller.currentStep.value -= 1;
                });
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  bool isValid = false;
                  switch (controller.currentStep.value) {
                    case 0:
                      isValid = controller.selectedCompany.value.isNotEmpty &&
                          controller.selectedModel.value.isNotEmpty &&
                          controller.selectedRam.value.isNotEmpty &&
                          controller.selectedColor.value.isNotEmpty &&
                          controller.quantity.text.isNotEmpty;
                      break;
                    case 1:
                      isValid = controller.customerNameController.text.isNotEmpty &&
                          controller.customerAddressController.text.isNotEmpty &&
                          controller.customerPhoneController.text.isNotEmpty &&
                          controller.selectedEmi.value.isNotEmpty;
                      break;
                    case 2:
                      isValid = controller.basePriceController.text.isNotEmpty &&
                          controller.gstController.text.isNotEmpty &&
                          controller.accessoriesController.text.isNotEmpty &&
                          controller.repairController.text.isNotEmpty &&
                          controller.discountController.text.isNotEmpty;
                      break;
                    case 3:
                      isValid = controller.customerNameController.text.isNotEmpty &&
                          controller.phoneNoController.text.isNotEmpty &&
                          controller.emailController.text.isNotEmpty &&
                          controller.addressController.text.isNotEmpty;
                      break;
                    default:
                      isValid = true;
                  }
                  if (isValid) {
                    details.onStepContinue?.call();
                  } else {
                    Get.snackbar(
                      'Error',
                      'Please fill all required fields',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                  }
                },
                 style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color(0xFFFF6B6B)),
                    foregroundColor: MaterialStateProperty.all(const Color(0xffffffff)),
                    

                  ),
                child: Text(controller.currentStep.value == getSteps().length - 1 ? 'Finish' : 'Next'),
              ),
              SizedBox(width: 8),
              if (controller.currentStep.value != 0)
                ElevatedButton(
                 
                  onPressed: details.onStepCancel,
                  child: const Text('Back'),
                ),
            ],
          );
        },
      ),
    );
  }
}
