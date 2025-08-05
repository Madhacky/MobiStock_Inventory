import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  isdark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: isdark ? Colors.black : Colors.white,
              size: 20,
            ),
            onPressed: () => Get.back(),
            padding: const EdgeInsets.all(8),
          ),
        ),
        const Spacer(),
        Text(
          title,
          style: TextStyle(
            color: isdark ? Colors.black : Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        actionItem ?? SizedBox.shrink(),
      ],
    ),
  );
}

SliverAppBar buildStyledSliverAppBar({
  required String title,
  required bool isDark,
  required VoidCallback onRefresh,
}) {
  return SliverAppBar(
    expandedHeight: 80.0,
    floating: true,
    pinned: true,
    snap: false,
    backgroundColor: isDark ? Colors.black : Colors.grey[50],
    elevation: 0,
    automaticallyImplyLeading: false,
    leading: Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color:
                !isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: !isDark ? Colors.black : Colors.white,
            size: 22,
          ),
          onPressed: () => Get.back(),
          padding: const EdgeInsets.all(8),
        ),
      ),
    ),
    flexibleSpace: FlexibleSpaceBar(
      title: Container(
        //padding: const EdgeInsets.only(top: 8, left: 0, right: 0),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.black : Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Spacer(),

            // Refresh Action
            IconButton(
              onPressed: onRefresh,
              icon: Icon(
                Icons.refresh,
                color: const Color(0xFF6C5CE7),
                size: 25,
              ),
              tooltip: 'Refresh',
            ),
          ],
        ),
      ),
    ),
  );
}
