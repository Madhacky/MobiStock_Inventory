import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildStyledTextField({
  required String labelText,
  required TextEditingController controller,
  required String hintText,
  String? prefixText,
  String? suffixText,
  Widget? suffixIcon,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
  void Function(String)? onChanged,
  void Function()? onTap,
  int? maxLines,
  bool readOnly = false,
  bool enabled = true,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText,
        style: TextStyle(
          color: enabled ? const Color(0xFF374151) : Colors.grey.shade500,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled 
                ? Colors.grey.withValues(alpha:0.2) 
                : Colors.grey.withValues(alpha:0.1),
          ),
        ),
        child: TextFormField(
          inputFormatters: inputFormatters  ,
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          enabled: enabled,
          onTap: onTap,
          style: TextStyle(
            color: enabled ? const Color(0xFF374151) : Colors.grey.shade500,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: enabled ? const Color(0xFF9CA3AF) : Colors.grey.shade400,
              fontSize: 14,
            ),
            prefixText: prefixText,
            suffixText: suffixText,
            suffixIcon: suffixIcon,
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