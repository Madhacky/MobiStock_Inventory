import 'package:flutter/material.dart';
import 'package:smartbecho/controllers/dashboard_controller.dart';
import 'package:smartbecho/utils/shimmer_responsive_utils.dart';
import 'package:shimmer/shimmer.dart';



Widget buildSalesSummaryShimmer(BuildContext context, DashboardController controller) {
  return Column(
    children: [
      // Two metric cards in a row (Total Sales and Transactions)
      _buildSummaryCardShimmer(
        context: context,
        controller: controller,
        child: Row(
          children: [
            Expanded(
              child: _buildShimmerMetricCard(context: context, controller: controller),
            ),
            SizedBox(width: ShimmerResponsiveUtils.getResponsiveMargin(context) * 3),
            Expanded(
              child: _buildShimmerMetricCard(context: context, controller: controller),
            ),
          ],
        ),
      ),
      SizedBox(height: ShimmerResponsiveUtils.getResponsiveMargin(context) * 3),

      // Full-width metric card (Smartphones Sold)
      _buildSummaryCardShimmer(
        context: context,
        controller: controller,
        child: _buildShimmerMetricCard(
          context: context, 
          controller: controller, 
          isFullWidth: true
        ),
      ),
      const SizedBox(height: 20),

      // Payment breakdown section
_buildSummaryCardShimmer(
  context: context,
  controller: controller,
  child: Container(
    padding: EdgeInsets.all(ShimmerResponsiveUtils.getResponsivePadding(context)),
    decoration: BoxDecoration(
      color: Colors.grey.shade50.withOpacity(0.7),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade200, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Payment Methods title shimmer
        Row(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: ShimmerResponsiveUtils.isSmallScreen(context) ? 16 : 18,
                height: ShimmerResponsiveUtils.isSmallScreen(context) ? 16 : 18,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // FIXED: Use Expanded to prevent overflow
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  // FIXED: Remove fixed width, let Expanded handle it
                  // width: ShimmerResponsiveUtils.getScreenWidth(context) * 0.3,
                  height: ShimmerResponsiveUtils.getResponsiveFontSize(context, baseSize: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ShimmerResponsiveUtils.getResponsiveMargin(context) * 3),
        // Payment items shimmer
        ...List.generate(
          ShimmerResponsiveUtils.isSmallScreen(context) ? 3 : 4,
          (index) => _buildShimmerPaymentItem(context, controller),
        ),
      ],
    ),
  ),
),
    ],
  );
}

Widget _buildSummaryCardShimmer({
  required BuildContext context,
  required DashboardController controller,
  required Widget child,
}) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: ShimmerResponsiveUtils.getResponsiveMargin(context),
      vertical: ShimmerResponsiveUtils.getResponsiveMargin(context) * 1.5,
    ),
    padding: EdgeInsets.all(ShimmerResponsiveUtils.getResponsivePadding(context)),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, Colors.blue.shade50.withOpacity(0.3)],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Colors.blue.shade100.withOpacity(0.5),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.shade100.withOpacity(0.2),
          blurRadius: 20,
          offset: const Offset(0, 8),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.8),
          blurRadius: 10,
          offset: const Offset(0, -2),
          spreadRadius: 0,
        ),
      ],
    ),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: ShimmerResponsiveUtils.getResponsiveFontSize(context, baseSize: 18),
                  width: ShimmerResponsiveUtils.getScreenWidth(context) * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    ),
  );
}

Widget _buildShimmerMetricCard({
  required BuildContext context,
  required DashboardController controller,
  bool isFullWidth = false,
}) {
  return Container(
    padding: EdgeInsets.all(ShimmerResponsiveUtils.getResponsivePadding(context)),
    decoration: BoxDecoration(
      color: Colors.grey.shade50.withOpacity(0.7),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade200, width: 1),
    ),
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title shimmer
                Container(
                  height: ShimmerResponsiveUtils.getResponsiveFontSize(context, baseSize: 14),
                  constraints: BoxConstraints(
                    maxWidth: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: ShimmerResponsiveUtils.getResponsiveMargin(context) * 2),
                // Value shimmer - FIXED: Remove explicit width since it's inside Expanded
                Container(
                  height: ShimmerResponsiveUtils.getResponsiveFontSize(context, baseSize: 20),
                  // Removed: width: double.infinity * 0.7,
                  constraints: BoxConstraints(
                    maxWidth: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildShimmerPaymentItem(BuildContext context, DashboardController controller) {
  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: ShimmerResponsiveUtils.getResponsiveMargin(context)
    ),
    child: Row(
      children: [
        // Payment Method shimmer
        Expanded(
          flex: 2,
          child: Container(
            height: ShimmerResponsiveUtils.getResponsiveFontSize(context, baseSize: 14),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Amount shimmer
        Expanded(
          flex: 3,
          child: Container(
            height: ShimmerResponsiveUtils.getResponsiveFontSize(context, baseSize: 14),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    ),
  );
}

// Responsive Today's Sales Stats Shimmer
class TodaysSalesStatsShimmer extends StatelessWidget {
  final int itemCount;

  const TodaysSalesStatsShimmer({
    Key? key,
    this.itemCount = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = ShimmerResponsiveUtils.getScreenWidth(context);
    final isSmallScreen = ShimmerResponsiveUtils.isSmallScreen(context);
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: ShimmerResponsiveUtils.getResponsiveMargin(context) * 3,
        childAspectRatio: _getResponsiveAspectRatio(context),
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => _buildShimmerCard(context),
    );
  }

  double _getResponsiveAspectRatio(BuildContext context) {
    if (ShimmerResponsiveUtils.isSmallScreen(context)) return 3.5;
    if (ShimmerResponsiveUtils.isMediumScreen(context)) return 3.8;
    return 4.2;
  }

  Widget _buildShimmerCard(BuildContext context) {
    final screenWidth = ShimmerResponsiveUtils.getScreenWidth(context);
    final isSmallScreen = ShimmerResponsiveUtils.isSmallScreen(context);
    
    return Container(
      padding: EdgeInsets.all(ShimmerResponsiveUtils.getResponsivePadding(context)),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: const Duration(milliseconds: 1500),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon shimmer
              Container(
                width: ShimmerResponsiveUtils.getResponsiveIconSize(context),
                height: ShimmerResponsiveUtils.getResponsiveIconSize(context),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(width: ShimmerResponsiveUtils.getResponsivePadding(context) * 0.8),
              // Text content shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title shimmer
                    Container(
                      height: ShimmerResponsiveUtils.getResponsiveFontSize(context, baseSize: 14),
                      constraints: BoxConstraints(
                        maxWidth: double.infinity,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: ShimmerResponsiveUtils.getResponsiveMargin(context) * 2),
                    // Value shimmer
                    Container(
                      height: ShimmerResponsiveUtils.getResponsiveFontSize(context, baseSize: 20),
                      width: double.infinity * 0.6,
                      constraints: BoxConstraints(
                        maxWidth: double.infinity,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Responsive Generic Bar Chart Shimmer
class GenericBarChartShimmer extends StatelessWidget {
  final String title;

  const GenericBarChartShimmer({
    Key? key,
    required this.title,
  }) : super(key: key);

  Color get primaryColor => const Color(0xFF6C5CE7);
  Color get primaryLight => const Color(0xFFA29BFE);

  @override
  Widget build(BuildContext context) {
    final screenWidth = ShimmerResponsiveUtils.getScreenWidth(context);
    final isSmallScreen = ShimmerResponsiveUtils.isSmallScreen(context);
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ShimmerResponsiveUtils.getResponsiveMargin(context),
        vertical: ShimmerResponsiveUtils.getResponsiveMargin(context) * 1.5,
      ),
      padding: EdgeInsets.all(ShimmerResponsiveUtils.getResponsivePadding(context)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, primaryLight.withOpacity(0.2)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryLight.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primaryLight.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: ShimmerResponsiveUtils.getResponsiveFontSize(context, baseSize: 18),
                    width: screenWidth * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: _getResponsiveChartHeight(context),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;
                  final barCount = _getResponsiveBarCount(context);
                  final barWidth = (availableWidth / barCount) * 0.5; // 50% of available space per bar
                  
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                      barCount,
                      (index) => Container(
                        width: barWidth.clamp(8.0, 20.0), // Clamp bar width between 8-20px
                        height: _getBarHeight(context, index),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final barCount = _getResponsiveBarCount(context);
                final labelWidth = (availableWidth / barCount) * 0.7; // 70% of available space per label
                
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    barCount,
                    (index) => Container(
                      width: labelWidth.clamp(20.0, 50.0), // Clamp label width between 20-50px
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  double _getResponsiveChartHeight(BuildContext context) {
    final screenHeight = ShimmerResponsiveUtils.getScreenHeight(context);
    if (ShimmerResponsiveUtils.isSmallScreen(context)) return screenHeight * 0.25;
    if (ShimmerResponsiveUtils.isMediumScreen(context)) return screenHeight * 0.28;
    return screenHeight * 0.3;
  }

  int _getResponsiveBarCount(BuildContext context) {
    if (ShimmerResponsiveUtils.isSmallScreen(context)) return 6;
    if (ShimmerResponsiveUtils.isMediumScreen(context)) return 7;
    return 8;
  }

  double _getResponsiveBarWidth(BuildContext context) {
    final screenWidth = ShimmerResponsiveUtils.getScreenWidth(context);
    final barCount = _getResponsiveBarCount(context);
    final availableWidth = screenWidth - (ShimmerResponsiveUtils.getResponsivePadding(context) * 4);
    return (availableWidth / barCount) * 0.6; // 60% of available space per bar
  }

  double _getResponsiveLabelWidth(BuildContext context) {
    final screenWidth = ShimmerResponsiveUtils.getScreenWidth(context);
    if (ShimmerResponsiveUtils.isSmallScreen(context)) return screenWidth * 0.08;
    if (ShimmerResponsiveUtils.isMediumScreen(context)) return screenWidth * 0.09;
    return screenWidth * 0.1;
  }

  double _getBarHeight(BuildContext context, int index) {
    final chartHeight = _getResponsiveChartHeight(context);
    final heights = [0.1, 0.15, 0.2, 0.08, 0.7, 0.85, 0.6, 0.05, 0.3, 0.4];
    return chartHeight * (heights[index % heights.length]);
  }
}