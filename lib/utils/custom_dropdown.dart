import 'package:flutter/material.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';

Widget buildStyledDropdown({
<<<<<<< HEAD
  required String labelText,
  required String hintText,
  required String? value,
  required List<String> items,
  required Function(String?) onChanged,
  String? Function(String?)? validator,
  bool enabled = true,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText,
        style: AppStyles.custom(
          color: Color(0xFF374151),
          size: 13,
          weight: FontWeight.w500,
=======
    required String labelText,
    required String hintText,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
    bool enabled = true,
    Widget? suffixIcon
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: Color(0xFF374151),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
        ),
      ),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: enabled ? AppTheme.backgroundLight : AppTheme.greyOpacity05,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.greyOpacity02),
        ),
        child: DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
<<<<<<< HEAD
          hint: Text(
            hintText,
            style: AppStyles.custom(color: Color(0xFF9CA3AF), size: 14),
          ),
          style: AppStyles.custom(
            color: Color(0xFF374151),
            size: 14,
            weight: FontWeight.w500,
          ),
          items:
              enabled
                  ? items.map((String item) {
=======
          child: DropdownButtonFormField<String>(
            
            value: value,
            isExpanded: true,
            decoration:  InputDecoration(
              border: InputBorder.none,
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            hint: Text(
              hintText,
              style: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
            ),
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            items: enabled
                ? items.map((String item) {
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList()
                  : [],
          onChanged: enabled ? onChanged : null,
          validator: validator,
        ),
      ),
    ],
  );
}
