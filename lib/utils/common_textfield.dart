import 'package:flutter/material.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';

Widget buildStyledTextField({
<<<<<<< HEAD
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
=======
    required String labelText,
    required TextEditingController controller,
    required String hintText,
    String? prefixText,
    String? suffixText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    int? maxLines
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
            color: Color(0xFF374151),
            size: 14,
            weight: FontWeight.w500,
          ),
<<<<<<< HEAD
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
=======
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,maxLines:maxLines ,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
              prefixText: prefixText,
              suffixText: suffixText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            validator: validator,
            onChanged: onChanged,
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
          ),
          validator: validator,
          onChanged: onChanged,
        ),
      ),
    ],
  );
}
