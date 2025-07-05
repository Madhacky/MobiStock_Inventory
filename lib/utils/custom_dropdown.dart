import 'package:flutter/material.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';

Widget buildStyledDropdown({
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
