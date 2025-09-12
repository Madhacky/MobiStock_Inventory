import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/auth%20controllers/auth_controller.dart';
import 'package:smartbecho/controllers/dashboard_controller.dart';
import 'package:smartbecho/controllers/user_prefs_controller.dart';
import 'package:smartbecho/models/dashboard_models/sales_summary_model.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/utils/animated_text.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/utils/generic_charts.dart';
import 'package:smartbecho/views/dashboard/charts/switchable_chart.dart';
import 'package:smartbecho/views/dashboard/widgets/dashboard_shimmers.dart';
import 'package:smartbecho/views/dashboard/widgets/drawer.dart';
import 'package:smartbecho/views/dashboard/widgets/error_cards.dart';
import 'package:smartbecho/views/dashboard/widgets/user_pref_dailog.dart';

class InventoryDashboard extends StatefulWidget {
  const InventoryDashboard({Key? key}) : super(key: key);

  @override
  State<InventoryDashboard> createState() => _InventoryDashboardState();
}

class _InventoryDashboardState extends State<InventoryDashboard>
    with TickerProviderStateMixin {
  final DashboardController controller = Get.find<DashboardController>();
  final AuthController authController = Get.find<AuthController>();
  final UserPrefsController userPrefsController =
      Get.find<UserPrefsController>();

  late AnimationController _chartAnimationController;
  late AnimationController _cardAnimationController;

  @override
  void initState() {
    super.initState();
    _chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _startAnimations();
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _cardAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _chartAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _chartAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        drawer: ModernAppDrawer(),
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: AnimatedBuilder(
            animation: controller.animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: controller.fadeAnimation,
                child: SlideTransition(
                  position: controller.slideAnimation,
                  child: Column(
                    children: [
                      _buildWhiteAppBar(),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: controller.refreshDashboardData,
                          backgroundColor: Colors.white,
                          color: const Color(0xFF6366F1),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Obx(() {
                              if (controller.isAllDataLoading.value) {
                                return _buildLoadingContent();
                              }

                              if (controller.hasGlobalError.value) {
                                return _buildErrorContent();
                              }

                              return _buildMainContent();
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: _buildEnhancedFAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildWelcomeSection(),
        const SizedBox(height: 28),
        const DashboardKPICardsShimmer(),
        const SizedBox(height: 32),
        const FinancialOverviewShimmer(),
        const SizedBox(height: 32),

        _buildAnalyticsDashboard(),
        const SizedBox(height: 32),
        const DashboardChartShimmer(title: "Revenue Analytics"),
        const SizedBox(height: 24),
        const DashboardChartShimmer(
          title: "Customer Distribution",
          height: 390,
        ),
        const SizedBox(height: 24),
        const DashboardChartShimmer(title: "Dues Overview", height: 350),
        const SizedBox(height: 24),
        const DashboardChartShimmer(title: "Sales Performance", height: 300),

        const SizedBox(height: 32),
        const CustomerAnalyticsShimmer(),
        const SizedBox(height: 32),
        const QuickActionsGridShimmer(),
        const SizedBox(height: 120),
      ],
    );
  }

  Widget _buildErrorContent() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to Load Dashboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.globalErrorMessage.value,
              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.refreshDashboardData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildWelcomeSection(),
        const SizedBox(height: 28),
        _buildAnimatedKPICards(),
        const SizedBox(height: 32),
        _buildFinancialOverview(),

        const SizedBox(height: 32),
        _buildAdvancedChartsSection(),
        const SizedBox(height: 32),
        _buildAnalyticsDashboard(),

        const SizedBox(height: 32),
        _buildCustomerAnalytics(),
        const SizedBox(height: 32),
        _buildQuickActionsGrid(),
        const SizedBox(height: 120),
      ],
    );
  }

  Widget _buildWhiteAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Builder(
        builder:
            (context) => Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Icon(
                          Icons.menu_rounded,
                          color: Color(0xFF1E293B),
                          size: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Obx(
                          () => Text(
                            AppConfig.shopName.value.isNotEmpty
                                ? AppConfig.shopName.value
                                : "Smart Becho",
                            style: const TextStyle(
                              color: Color(0xFF1E293B),
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _buildAppBarIcon(
                          Icons.notifications_rounded,
                          () {},
                          hasNotification: true,
                        ),
                        const SizedBox(width: 12),
                        _buildAppBarIcon(
                          Icons.person_rounded,
                          () => Get.toNamed(AppRoutes.profile),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Quick stats bar
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: _buildQuickStat(
                          "Today's Revenue",
                          "₹${controller.todaysSalesAmount}",
                          const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickStat(
                          "Units Sold",
                          "${controller.todaysUnitsSold}",
                          const Color(0xFF6366F1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickStat(
                          "Available Stock",
                          "${controller.availableStock}",
                          const Color(0xFFF59E0B),
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

  Widget _buildQuickStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarIcon(
    IconData icon,
    VoidCallback onTap, {
    bool hasNotification = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Icon(icon, color: const Color(0xFF64748B), size: 20),
          ),
          if (hasNotification)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA855F7)],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.4),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Icon(
                  Icons.waving_hand,
                  color: Colors.amber,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getCurrentDate(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedKPICards() {
    return AnimatedBuilder(
      animation: _cardAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _cardAnimationController.value)),
          child: Opacity(
            opacity: _cardAnimationController.value,
            child: Obx(
              () => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildEnhancedKPICard(
                          "Opening Balance",
                          "₹${controller.monthlyRevenueAmount}",
                          Icons.trending_up_rounded,
                          const Color(0xFF10B981),
                          "+12.5%",
                          true,
                          0,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildEnhancedKPICard(
                          "Closing Balance",
                          "₹${controller.currentBalance}",
                          Icons.account_balance_wallet_rounded,
                          const Color(0xFF6366F1),
                          "Current",
                          false,
                          0.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildEnhancedKPICard(
                          "Total Customers",
                          "${controller.totalCustomers}",
                          Icons.people_rounded,
                          const Color(0xFF8B5CF6),
                          "${controller.newCustomersThisMonth} new",
                          true,
                          0.2,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildEnhancedKPICard(
                          "Withdrawal",
                          "₹${controller.ledgerAnalytics.value?.withdrawals.toString()}",
                          Icons.check_circle_rounded,
                          const Color(0xFFF59E0B),
                          "${controller.collectedPercentage.toStringAsFixed(1)}%",
                          true,
                          0.3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedKPICard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
    bool isPositive,
    double delay,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withOpacity(0.15), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      isPositive
                          ? const Color(0xFF10B981).withOpacity(0.15)
                          : color.withOpacity(0.15),
                      isPositive
                          ? const Color(0xFF10B981).withOpacity(0.05)
                          : color.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isPositive
                            ? const Color(0xFF10B981).withOpacity(0.3)
                            : color.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isPositive ? const Color(0xFF10B981) : color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                "Analytics Dashboard",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Icon(
                Icons.analytics_rounded,
                color: Color(0xFF6366F1),
                size: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "Comprehensive business insights and performance metrics",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

Widget _buildAdvancedChartsSection() {
  return SizedBox(
    height: 400, // Enough to fit your tallest chart
    width: 450,
    child: PageView(
      controller: PageController(viewportFraction: 0.95), // show part of next card for peek effect
      padEnds: false, // don't add padding at the ends of the list
      children: [
        _buildAnimatedChartCard(
          title: "Revenue Analytics",
          subtitle: "Monthly performance overview with trends",
          child: _buildEnhancedRevenueChart(),
          height: 340,
          gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        _buildAnimatedChartCard(
          title: "Customer Distribution",
          subtitle: "Repeated vs New Customers",
          child: _buildEnhancedCustomerChart(),
          height: 390,
          gradient: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        ),
        _buildAnimatedChartCard(
          title: "Dues Overview",
          subtitle: "Collection status",
          child: _buildEnhancedDuesChart(),
          height: 350,
          gradient: const [Color(0xFF10B981), Color(0xFF34D399)],
        ),
        // add more if needed
      ],
    ),
  );
}

Widget _buildAnimatedChartCard({
  required String title,
  required String subtitle,
  required Widget child,
  required double height,
  required List<Color> gradient,
}) {
  // You can integrate animation here if needed, or keep it simple
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: _buildAdvancedChartCard(
      title: title,
      subtitle: subtitle,
      child: child,
      height: height,
      width: 350, // fixed width for carousel cards
      gradient: gradient,
    ),
  );
}


  Widget _buildAdvancedChartCard({
    required String title,
    required String subtitle,
    required Widget child,
    double? height,
    double? width,

    List<Color>? gradient,
  }) {
    return Container(
      height: height ?? 350,
      width: width??350,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Gradient background for header
          if (gradient != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 80,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient.map((c) => c.withOpacity(0.05)).toList(),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (gradient != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: gradient),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          _getChartIcon(title),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    if (gradient != null) const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.more_horiz,
                        color: Color(0xFF64748B),
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getChartIcon(String title) {
    switch (title) {
      case "Revenue Analytics":
        return Icons.show_chart_rounded;
      case "Dues Overview":
        return Icons.pie_chart_rounded;
      case "Customer Distribution":
        return Icons.donut_large_rounded;
      case "Sales Performance":
        return Icons.trending_up_rounded;
      default:
        return Icons.analytics_rounded;
    }
  }

  Widget _buildEnhancedRevenueChart() {
    return SizedBox(
      height: 220,
      child: CustomPaint(
        painter: EnhancedRevenueChartPainter(),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildEnhancedDuesChart() {
    return Obx(
      () => SizedBox(
        height: 180,
        child: CustomPaint(
          painter: EnhancedDuesChartPainter(
            collected: double.tryParse(controller.collectedDues) ?? 0,
            remaining: double.tryParse(controller.remainingDues) ?? 0,
            collectedPercentage: controller.collectedPercentage,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }

  Widget _buildEnhancedCustomerChart() {
    return SizedBox(
      height: 250,
      child: Obx(
        () => Column(
          children: [
            Expanded(
              child: CustomPaint(
                painter: EnhancedCustomerChartPainter(
                  customerStats: controller.customerStats.value,
                ),
                size: Size.infinite,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCustomerLegendItem(
                  "Repeated Customers",
                  const Color(0xFF10B981),
                  controller.customerStats.value,
                ),
                _buildCustomerLegendItem(
                  "New Customers",
                  const Color(0xFF3B82F6),
                  controller.customerStats.value,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesPerformanceChart() {
    return SizedBox(
      height: 200,
      child: CustomPaint(
        painter: SalesPerformanceChartPainter(),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildCustomerLegendItem(
    String label,
    Color color,
    CustomerStatsModel? customerStatsModel,
  ) {
    // Get the count based on label
    int count = 0;
    if (customerStatsModel != null) {
      if (label.contains("Repeated")) {
        count = customerStatsModel.repeatedCustomers;
      } else if (label.contains("New")) {
        count = customerStatsModel.newCustomersThisMonth;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFinancialOverview() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF334155), Color(0xFF475569)],
        ),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.4),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Financial Overview",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Current month performance metrics",
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Obx(
            () => Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildEnhancedFinancialMetric(
                        "Monthly Revenue",
                        "₹${controller.monthlyRevenueAmount}",
                        Icons.trending_up_rounded,
                        const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildEnhancedFinancialMetric(
                        "Total Dues Balance",
                        "₹${(double.parse(controller.collectedDues) + double.parse(controller.remainingDues))}",
                        Icons.account_balance_rounded,
                        const Color(0xFF06B6D4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildEnhancedFinancialMetric(
                        "Collected Dues",
                        "₹${controller.collectedDues}",
                        Icons.check_circle_rounded,
                        const Color(0xFF8B5CF6),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildEnhancedFinancialMetric(
                        "Pending Dues",
                        "₹${controller.remainingDues}",
                        Icons.schedule_rounded,
                        const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedFinancialMetric(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerAnalytics() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.people_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Customer Analytics",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Customer base insights and engagement metrics",
                      style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Obx(
            () => SizedBox(
              height: 200,
              child: CustomPaint(
                painter: CustomerAnalyticsChartPainter(
                  totalCustomers: controller.totalCustomers,
                  repeatedCustomers: controller.repeatedCustomers,
                  newCustomers: controller.newCustomersThisMonth,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: _buildCustomerStat(
                    "Total Customers",
                    "${controller.totalCustomers}",
                    const Color(0xFF8B5CF6),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCustomerStat(
                    "Repeat Customers",
                    "${controller.repeatedCustomers}",
                    const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCustomerStat(
                    "New This Month",
                    "${controller.newCustomersThisMonth}",
                    const Color(0xFF06B6D4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.person_rounded, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Icon(
                Icons.apps_rounded,
                color: Color(0xFF6366F1),
                size: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "Streamline your workflow with instant access to key features",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 24),
        Obx(
          () => GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 6,
              mainAxisSpacing: 10,
              childAspectRatio: 1.4,
            ),
            itemCount: controller.quickActions.length.clamp(0, 6),
            itemBuilder:
                (context, index) =>
                    _buildEnhancedActionCard(controller.quickActions[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedActionCard(QuickActionButton action) {
    return GestureDetector(
      onTap: () => controller.handleQuickAction(action),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: action.colors,
            stops: const [0.0, 1.0],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: action.colors[0].withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(action.icon, color: Colors.white, size: 24),
            ),
            const Spacer(),
            Text(
              action.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  "Tap to open",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedFAB() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA855F7)],
        ),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.5),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addNewItem),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 36),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning!";
    if (hour < 17) return "Good Afternoon!";
    return "Good Evening!";
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${months[now.month - 1]} ${now.day}, ${now.year}";
  }
}

// Enhanced Revenue Chart Painter
class EnhancedRevenueChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background grid
    final gridPaint =
        Paint()
          ..color = Colors.grey.withOpacity(0.1)
          ..strokeWidth = 1;

    // Draw grid lines
    for (int i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Main chart line
    final paint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    // Area fill
    final fillPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [
              const Color(0xFF6366F1).withOpacity(0.3),
              const Color(0xFF8B5CF6).withOpacity(0.1),
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    // Data points for revenue trend
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.15, size.height * 0.7),
      Offset(size.width * 0.3, size.height * 0.5),
      Offset(size.width * 0.45, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.75, size.height * 0.4),
      Offset(size.width, size.height * 0.2),
    ];

    // Create smooth curve
    path.moveTo(points[0].dx, points[0].dy);
    fillPath.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      final cp1 = Offset(
        points[i - 1].dx + (points[i].dx - points[i - 1].dx) * 0.4,
        points[i - 1].dy,
      );
      final cp2 = Offset(
        points[i].dx - (points[i].dx - points[i - 1].dx) * 0.4,
        points[i].dy,
      );
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i].dx, points[i].dy);
      fillPath.cubicTo(
        cp1.dx,
        cp1.dy,
        cp2.dx,
        cp2.dy,
        points[i].dx,
        points[i].dy,
      );
    }

    // Complete fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    // Draw fill and line
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw data points
    final pointPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final pointBorderPaint =
        Paint()
          ..color = const Color(0xFF6366F1)
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

    for (final point in points) {
      canvas.drawCircle(point, 6, pointBorderPaint);
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Enhanced Dues Chart Painter
class EnhancedDuesChartPainter extends CustomPainter {
  final double collected;
  final double remaining;
  final double collectedPercentage;

  EnhancedDuesChartPainter({
    required this.collected,
    required this.remaining,
    required this.collectedPercentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Background circle
    final backgroundPaint =
        Paint()
          ..color = Colors.grey.withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Collected dues arc
    final collectedPaint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF34D399)],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20
          ..strokeCap = StrokeCap.round;

    final collectedAngle = (collectedPercentage / 100) * 2 * 3.14159;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      collectedAngle,
      false,
      collectedPaint,
    );

    // Center text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${collectedPercentage.toStringAsFixed(1)}%\nCollected',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Enhanced Customer Chart Painter
class EnhancedCustomerChartPainter extends CustomPainter {
  final CustomerStatsModel? customerStats;

  EnhancedCustomerChartPainter({this.customerStats});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Default values if customerStats is null
    final repeatedCustomers = customerStats?.repeatedCustomers ?? 0;
    final newCustomers = customerStats?.newCustomersThisMonth ?? 0;
    final totalCustomers = repeatedCustomers + newCustomers;

    // Prevent division by zero
    if (totalCustomers == 0) {
      _drawEmptyState(canvas, size, center, radius);
      return;
    }

    // Calculate percentages
    final repeatedPercentage = (repeatedCustomers / totalCustomers) * 100;
    final newPercentage = (newCustomers / totalCustomers) * 100;

    // Customer data
    final customerData = [
      {
        'name': 'Repeated Customers',
        'value': repeatedPercentage,
        'count': repeatedCustomers,
        'color': const Color(0xFF10B981),
      },
      {
        'name': 'New Customers',
        'value': newPercentage,
        'count': newCustomers,
        'color': const Color(0xFF3B82F6),
      },
    ];

    double startAngle = -3.14159 / 2; // Start from top

    for (final data in customerData) {
      final percentage = data['value'] as double;
      if (percentage > 0) {
        final sweepAngle = percentage / 100 * 2 * 3.14159;

        final paint =
            Paint()
              ..color = data['color'] as Color
              ..style = PaintingStyle.fill;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          true,
          paint,
        );

        // Add stroke between segments
        final strokePaint =
            Paint()
              ..color = Colors.white
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          true,
          strokePaint,
        );

        startAngle += sweepAngle;
      }
    }

    // Inner circle for donut effect
    final innerPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.6, innerPaint);

    // Center text showing total customers
    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$totalCustomers\n',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const TextSpan(
            text: 'Total\nCustomers',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  void _drawEmptyState(Canvas canvas, Size size, Offset center, double radius) {
    // Draw empty circle
    final emptyPaint =
        Paint()
          ..color = const Color(0xFFE5E7EB)
          ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, emptyPaint);

    // Inner circle
    final innerPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.6, innerPaint);

    // No data text
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'No Data\nAvailable',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9CA3AF),
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is EnhancedCustomerChartPainter &&
        oldDelegate.customerStats != customerStats;
  }
}

// Sales Performance Chart Painter
class SalesPerformanceChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background gradient
    final backgroundPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [
              const Color(0xFF8B5CF6).withOpacity(0.1),
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Bar chart data (example daily sales)
    final barData = [0.3, 0.7, 0.5, 0.8, 0.6, 0.9, 0.4];
    final barWidth = size.width / (barData.length * 2);

    for (int i = 0; i < barData.length; i++) {
      final barHeight = size.height * barData[i];
      final x = (i * 2 + 1) * barWidth;

      // Gradient for bars
      final barPaint =
          Paint()
            ..shader = const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(
              Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight),
            );

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight),
        const Radius.circular(8),
      );

      canvas.drawRRect(rect, barPaint);

      // Highlight effect on top
      final highlightPaint =
          Paint()
            ..color = Colors.white.withOpacity(0.3)
            ..style = PaintingStyle.fill;

      final highlightRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, size.height - barHeight, barWidth, 8),
        const Radius.circular(8),
      );

      canvas.drawRRect(highlightRect, highlightPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Customer Analytics Chart Painter
class CustomerAnalyticsChartPainter extends CustomPainter {
  final int totalCustomers;
  final int repeatedCustomers;
  final int newCustomers;

  CustomerAnalyticsChartPainter({
    required this.totalCustomers,
    required this.repeatedCustomers,
    required this.newCustomers,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create a simple bar chart showing customer analytics
    final barWidth = size.width / 4;
    final maxValue = totalCustomers.toDouble();

    if (maxValue == 0) return;

    // Total customers bar
    final totalHeight = (totalCustomers / maxValue) * size.height * 0.8;
    final totalPaint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
            Rect.fromLTWH(
              barWidth * 0.5,
              size.height - totalHeight,
              barWidth,
              totalHeight,
            ),
          );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          barWidth * 0.5,
          size.height - totalHeight,
          barWidth,
          totalHeight,
        ),
        const Radius.circular(12),
      ),
      totalPaint,
    );

    // Repeated customers bar
    final repeatHeight = (repeatedCustomers / maxValue) * size.height * 0.8;
    final repeatPaint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF34D399)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
            Rect.fromLTWH(
              barWidth * 1.7,
              size.height - repeatHeight,
              barWidth,
              repeatHeight,
            ),
          );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          barWidth * 1.7,
          size.height - repeatHeight,
          barWidth,
          repeatHeight,
        ),
        const Radius.circular(12),
      ),
      repeatPaint,
    );

    // New customers bar
    final newHeight = (newCustomers / maxValue) * size.height * 0.8;
    final newPaint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
            Rect.fromLTWH(
              barWidth * 2.9,
              size.height - newHeight,
              barWidth,
              newHeight,
            ),
          );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          barWidth * 2.9,
          size.height - newHeight,
          barWidth,
          newHeight,
        ),
        const Radius.circular(12),
      ),
      newPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Monthly Revenue Chart Painter with Real Data
class MonthlyRevenueChartPainter extends CustomPainter {
  final Map<String, double> revenueData;

  MonthlyRevenueChartPainter({required this.revenueData});

  @override
  void paint(Canvas canvas, Size size) {
    if (revenueData.isEmpty) return;

    final entries = revenueData.entries.toList();
    final maxValue = entries
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);
    final minValue = entries
        .map((e) => e.value)
        .reduce((a, b) => a < b ? a : b);
    final valueRange = maxValue - minValue;

    if (valueRange == 0) return;

    // Background grid
    final gridPaint =
        Paint()
          ..color = Colors.grey.withOpacity(0.1)
          ..strokeWidth = 1;

    for (int i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Create path for line chart
    final path = Path();
    final fillPath = Path();
    final points = <Offset>[];

    for (int i = 0; i < entries.length; i++) {
      final x = (size.width / (entries.length - 1)) * i;
      final normalizedValue = (entries[i].value - minValue) / valueRange;
      final y = size.height * (1 - normalizedValue * 0.8);
      points.add(Offset(x, y));
    }

    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      fillPath.moveTo(points[0].dx, points[0].dy);

      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
        fillPath.lineTo(points[i].dx, points[i].dy);
      }

      // Complete fill path
      fillPath.lineTo(size.width, size.height);
      fillPath.lineTo(0, size.height);
      fillPath.close();

      // Draw area fill
      final fillPaint =
          Paint()
            ..shader = LinearGradient(
              colors: [
                const Color(0xFF6366F1).withOpacity(0.3),
                const Color(0xFF8B5CF6).withOpacity(0.1),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
            ..style = PaintingStyle.fill;

      canvas.drawPath(fillPath, fillPaint);

      // Draw line
      final linePaint =
          Paint()
            ..shader = const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
            ..strokeWidth = 3
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;

      canvas.drawPath(path, linePaint);

      // Draw points
      final pointPaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill;

      final pointBorderPaint =
          Paint()
            ..color = const Color(0xFF6366F1)
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke;

      for (final point in points) {
        canvas.drawCircle(point, 5, pointBorderPaint);
        canvas.drawCircle(point, 3, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is MonthlyRevenueChartPainter &&
        oldDelegate.revenueData != revenueData;
  }
}

// Top Selling Models Chart Painter
class TopSellingModelsChartPainter extends CustomPainter {
  final Map<String, double> modelData;

  TopSellingModelsChartPainter({required this.modelData});

  @override
  void paint(Canvas canvas, Size size) {
    if (modelData.isEmpty) return;

    final entries =
        modelData.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    final maxValue = entries.first.value;
    if (maxValue == 0) return;

    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
    ];

    final barHeight = size.height / entries.length;

    for (int i = 0; i < entries.length && i < 5; i++) {
      final entry = entries[i];
      final barWidth = (entry.value / maxValue) * size.width * 0.8;
      final y = i * barHeight + barHeight * 0.2;

      final barPaint =
          Paint()
            ..shader = LinearGradient(
              colors: [
                colors[i % colors.length],
                colors[i % colors.length].withOpacity(0.7),
              ],
            ).createShader(Rect.fromLTWH(0, y, barWidth, barHeight * 0.6))
            ..style = PaintingStyle.fill;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, y, barWidth, barHeight * 0.6),
        const Radius.circular(8),
      );

      canvas.drawRRect(rect, barPaint);

      // Draw label
      final textPainter = TextPainter(
        text: TextSpan(
          text: entry.key,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(barWidth + 8, y + (barHeight * 0.6 - textPainter.height) / 2),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is TopSellingModelsChartPainter &&
        oldDelegate.modelData != modelData;
  }
}
