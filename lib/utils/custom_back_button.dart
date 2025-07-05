import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/utils/app_colors.dart';

Widget customBackButton({required bool isdark}) {
  return Container(
    decoration: BoxDecoration(
      color: AppTheme.backgroundLight.withOpacity(0.2),
      shape: BoxShape.circle,
      border: Border.all(
        color:
            isdark
                ? AppTheme.backgroundDark.withOpacity(0.3)
                : AppTheme.backgroundLight.withOpacity(0.3),
        width: 1,
      ),
    ),
    child: IconButton(
      icon: Icon(
        Icons.arrow_back_ios_rounded,
        color: isdark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
        size: 20,
      ),
      onPressed: () => Get.back(),
      padding: const EdgeInsets.all(8),
    ),
  );
}
