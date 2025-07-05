import 'package:flutter/material.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/shimmer_responsive_utils.dart';
import 'package:shimmer/shimmer.dart';



Widget _buildStatCardShimmer(BuildContext context) {
  final padding = ShimmerResponsiveUtils.getResponsivePadding(context);
  final margin = ShimmerResponsiveUtils.getResponsiveMargin(context);
  final iconSize = ShimmerResponsiveUtils.getResponsiveIconSize(context);
  final titleHeight = ShimmerResponsiveUtils.getResponsiveFontSize(context, baseSize: 12);
  final valueHeight = ShimmerResponsiveUtils.getResponsiveFontSize(context, baseSize: 20);
  final subtitleHeight = ShimmerResponsiveUtils.getResponsiveFontSize(context, baseSize: 10);

  return Shimmer.fromColors(
    baseColor: AppTheme.grey300,
    highlightColor: AppTheme.grey100,
    child: Container(
      width: ShimmerResponsiveUtils.isSmallScreen(context) ? 140 : 180,
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.only(right: margin * 4),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and icon row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: titleHeight,
                  color: AppTheme.grey300,
                ),
              ),
              SizedBox(width: margin * 2),
              Container(
                height: iconSize * 0.6,
                width: iconSize * 0.6,
                decoration: BoxDecoration(
                  color: AppTheme.grey300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          SizedBox(height: margin * 3),
          // Value section
          Container(
            height: valueHeight,
            width: ShimmerResponsiveUtils.getScreenWidth(context) * 0.3,
            color: AppTheme.grey300,
          ),
          SizedBox(height: margin),
          // Subtitle section
          Container(
            height: subtitleHeight,
            width: ShimmerResponsiveUtils.getScreenWidth(context) * 0.4,
            color: AppTheme.grey300,
          ),
        ],
      ),
    ),
  );
}
Widget buildShimmerStatList(BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(
      horizontal: ShimmerResponsiveUtils.getResponsivePadding(context),
    ),
    child: Row(
      children: List.generate(
        5,
        (_) => _buildStatCardShimmer(context),
      ),
    ),
  );
}
