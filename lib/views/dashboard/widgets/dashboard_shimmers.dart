import 'package:flutter/material.dart';
import 'package:mobistock/controllers/dashboard_controller.dart';
import 'package:shimmer/shimmer.dart';

Widget buildSalesSummaryShimmer(DashboardController controller) {
  return Column(
    children: [
      // Summary Items Shimmer
      ...List.generate(3, (index) => _buildShimmerSummaryItem(controller)),
      
      SizedBox(height: 8),
      
      // Payment Breakdown Title Shimmer
      Align(
        alignment: Alignment.centerLeft,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 120,
            height: controller.isSmallScreen ? 11 : 12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
      
      SizedBox(height: 4),
      
      // Payment Items Shimmer
      ...List.generate(
        controller.isSmallScreen ? 3 : 4,
        (index) => _buildShimmerPaymentItem(controller),
      ),
    ],
  );
}

Widget _buildShimmerSummaryItem(DashboardController controller) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        // Label Shimmer
        Expanded(
          flex: 3,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: controller.isSmallScreen ? 10 : 11,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        
        SizedBox(width: 8),
        
        // Value Shimmer
        Expanded(
          flex: 2,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: controller.isSmallScreen ? 10 : 11,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildShimmerPaymentItem(DashboardController controller) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 1),
    child: Row(
      children: [
        // Payment Method Shimmer
        Expanded(
          flex: 2,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: controller.isSmallScreen ? 10 : 11,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        
        SizedBox(width: 8),
        
        // Amount and Percentage Shimmer
        Expanded(
          flex: 3,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: controller.isSmallScreen ? 10 : 11,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

//top todays sales card shimmer
class TodaysSalesStatsShimmer extends StatelessWidget {
  final bool isSmallScreen;
  final double screenWidth;
  final int itemCount;

  const TodaysSalesStatsShimmer({
    Key? key,
    required this.isSmallScreen,
    required this.screenWidth,
    this.itemCount = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 12,
        childAspectRatio: isSmallScreen ? 3.8 : 4.2,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => _buildShimmerCard(),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: Duration(milliseconds: 1500),
        child: Row(
          children: [
            // Icon shimmer
            Container(
              width: isSmallScreen ? 36 : 40,
              height: isSmallScreen ? 36 : 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(width: 16),
            // Text content shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title shimmer
                  Container(
                    height: isSmallScreen ? 12 : 14,
                    width: double.infinity * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 8),
                  // Value shimmer
                  Container(
                    height: isSmallScreen ? 20 : 24,
                    width: double.infinity * 0.4,
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
    );
  }
}