import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/bottom_navigation_screen.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';

Widget buildCustomAppBar(
  String title, {
  required bool isdark,
  Widget? actionItem,
  void Function()? onPressed,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,

        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
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
              onPressed:
                  onPressed ??
                  () {
                    Get.back();
                  },
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
    titleSpacing: 0, // Remove default spacing
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
          // onPressed: () => Get.back(),
          // onPressed: () => Get.toNamed(AppRoutes.dashboard),
          onPressed: () {
            final bottomNavController = Get.find<BottomNavigationController>();
            bottomNavController.setIndex(0); // Dashboard tab index
          },
          padding: const EdgeInsets.all(8),
        ),
      ),
    ),
    title: Text(
      title,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    ),
    centerTitle: true, // Center the title
    actions: [
      IconButton(
        onPressed: onRefresh,
        icon: Icon(Icons.refresh, color: const Color(0xFF6C5CE7), size: 25),
        tooltip: 'Refresh',
      ),
      SizedBox(width: 8), // Add some padding on the right
    ],
  );
}

class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isdark;
  final Widget? actionItem;
  final VoidCallback? onPressed;

  const BuildAppBar({
    super.key,
    required this.title,
    this.isdark = false,
    this.actionItem,
    this.onPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 200),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: AppBar(
          toolbarHeight: 300,
          centerTitle: true,
          backgroundColor: AppColors.primaryLight,
          title: Text(
            title,
            style: TextStyle(color: isdark ? Colors.black : Colors.white),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              padding: const EdgeInsets.all(8),
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: isdark ? Colors.black : Colors.white,
                size: 20,
              ),
              onPressed:
                  onPressed ??
                  () {
                    Get.back();
                  },
            ),
          ),
          actions: [actionItem ?? SizedBox.shrink()],
        ),
      ),
    );
  }
}

class BuildFormAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isdark;
  final Widget? actionItem;
  final VoidCallback? onPressed;
  final String? subtitle;
  final IconData icon;
  final Color? iconBgColor;

  const BuildFormAppBar({
    super.key,
    required this.title,
    this.isdark = false,
    this.actionItem,
    this.onPressed,
    this.subtitle = '',
    required this.icon,
    this.iconBgColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 200),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: AppBar(
          backgroundColor: AppColors.primaryLight,
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              padding: const EdgeInsets.all(8),
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: isdark ? Colors.black : Colors.white,
                size: 20,
              ),
              onPressed:
                  onPressed ??
                  () {
                    Get.back();
                  },
            ),
          ),
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 45.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconBgColor ?? Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppStyles.custom(
                          color: const Color(0xFFFFFFFF),
                          size: 16,
                          weight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subtitle ?? '',
                        style: TextStyle(
                          color: Color(0xFFCCD6EA),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [actionItem ?? SizedBox.shrink()],
        ),
      ),
    );
  }
}
