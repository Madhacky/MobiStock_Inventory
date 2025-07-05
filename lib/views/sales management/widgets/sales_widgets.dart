import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';

class SalesWidgets {
  static Widget salesTitle({required String title}) {
    return Text(
      title,
      style: AppStyles.custom(
        weight: FontWeight.bold,
        color: AppTheme.backgroundDark,
        fontSize: 20,
      ),
    );
  }

  // Sales TextFormFiled Widget
  static Widget salesTextFormField({
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String label,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.backgroundLight.withOpacity(0.2),
          width: 1,
        ),
      ),

      child: TextFormField(
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: AppTheme.primarygrey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.0),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }
  // Sales Dropdown Widget

  static Widget salesDropdownButton({
    required List<String> items,
    required String selectedItem,
    required Function(String) onChanged,
    required String label,
    // required String hintText,
  }) {
    return DropdownButtonFormField<String>(
      value: selectedItem,
      items:
          items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: AppStyles.custom(
                      size: 16,
                      color: AppTheme.backgroundDark,
                    ),
                  ),
                ),
              )
              .toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
      isExpanded: true,
      // dropdownColor: AppTheme.backgroundLight.opacity(0.9)zz,
      decoration: InputDecoration(
        labelText: label,
        // hintText: hintText,
        // icon: Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Color(0xFF6C5CE7), width: 1.0),
        ),

        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(8.0),
        //   borderSide: BorderSide(color: AppTheme.primarygrey width: 1.0),
        // ),
      ),
      icon: Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
    );
  }

  static Widget salesRadioButton({
    required String title,
    required bool value,
    required bool groupValue,
    IconData? icon,
    required Function(bool?) onChanged,
  }) {
    return RadioListTile(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }

  static Widget salesButton({
    required String text,
    required VoidCallback onPressed,
    Color? color,
    Color? textColor,
    double? fontSize,
    double? height,
    double? width,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppTheme.primaryBlue,
        foregroundColor: textColor ?? AppTheme.backgroundLight,
        minimumSize: Size(width ?? double.infinity, height ?? 50),
      ),
      child: Text(text, style: AppStyles.custom(size: fontSize ?? 16)),
    );
  }

  static Widget previewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label:", style: AppStyles.custom(weight: FontWeight.w600)),
          Flexible(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
