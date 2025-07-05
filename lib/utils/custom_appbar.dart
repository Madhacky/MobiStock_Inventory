import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';

Widget buildCustomAppBar(
  String title, {
  required bool isdark,
  Widget? actionItem,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
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
              color:
                  isdark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
              size: 20,
            ),
            onPressed: () => Get.back(),
            padding: const EdgeInsets.all(8),
          ),
        ),
        const Spacer(),
        Text(
          title,
          style: AppStyles.custom(
            color: isdark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
            size: 20,
            weight: FontWeight.w600,
          ),
        ),
        Spacer(),
        actionItem ?? SizedBox.shrink(),
      ],
    ),
  );
}
