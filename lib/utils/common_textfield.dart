import 'package:flutter/material.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';

Widget buildStyledTextField({
  required String labelText,
  required TextEditingController controller,
  required String hintText,
  String? prefixText,
  String? suffixText,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
  void Function(String)? onChanged,
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
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.greyOpacity02),
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppStyles.custom(
            color: Color(0xFF374151),
            size: 14,
            weight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppStyles.custom(color: Color(0xFF9CA3AF), size: 14),
            prefixText: prefixText,
            suffixText: suffixText,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          validator: validator,
          onChanged: onChanged,
        ),
      ),
    ],
  );
}
