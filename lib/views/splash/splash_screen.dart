import 'package:flutter/material.dart';
import 'package:mobistock/services/jwt_validator.dart';
import 'package:mobistock/services/route_services.dart';
import 'package:mobistock/services/validate_user.dart';
import 'package:mobistock/utils/shared_preferences_helpers.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _rotateController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    // Create animations
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );

    // Start animations
    _startAnimations();

    // Auto navigate after 3 seconds with JWT token check
    Future.delayed(Duration(seconds: 3), () async {
      await _checkTokenAndNavigate();
    });
  }

  Future<void> _checkTokenAndNavigate() async {
    try {
      // First check if user has basic login status
      bool isLoggedIn = await ValidateUser.checkLoginStatus();
      
      if (!isLoggedIn) {
        RouteService.toLogin();
        return;
      }

      // Get JWT token using SharedPreferencesHelper
      final token = await SharedPreferencesHelper.getJwtToken();
      
      if (token == null || token.isEmpty) {
        // No token found, navigate to login
        RouteService.toLogin();
        return;
      }

      // Check if token is expired
      final isExpired = JwtHelper.isTokenExpired(token);
      
      if (isExpired) {
        // Token expired, clear login status and navigate to login
        print('JWT Token expired, redirecting to login');
        // Clear the expired token and login status
        await SharedPreferencesHelper.setIsLoggedIn(false);
        RouteService.toLogin();
      } else {
        // Token is valid, navigate to dashboard
        print('JWT Token is valid, navigating to dashboard');
        RouteService.toDashboard();
      }
    } catch (e) {
      print('Error checking token in splash screen: $e');
      // On error, navigate to login for safety
      RouteService.toLogin();
    }
  }

  void _startAnimations() async {
    // Start scale animation first
    _scaleController.forward();

    // Start fade animation after a short delay
    await Future.delayed(Duration(milliseconds: 300));
    _fadeController.forward();

    // Start pulse animation
    await Future.delayed(Duration(milliseconds: 500));
    _pulseController.repeat(reverse: true);

    // Start rotation animation
    await Future.delayed(Duration(milliseconds: 800));
    _rotateController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF9C27B0)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            ...List.generate(20, (index) => _buildFloatingParticle(index)),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo section
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.3),
                                      Colors.white.withOpacity(0.1),
                                      Colors.transparent,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.3),
                                      spreadRadius: 10,
                                      blurRadius: 30,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: AnimatedBuilder(
                                    animation: _rotateAnimation,
                                    builder: (context, child) {
                                      return Transform.rotate(
                                        angle: _rotateAnimation.value * 3.14159,
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white,
                                                Colors.white.withOpacity(0.8),
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.2,
                                                ),
                                                spreadRadius: 2,
                                                blurRadius: 15,
                                                offset: Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.inventory_2_rounded,
                                            size: 40,
                                            color: Color(0xFF667eea),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Animated app name
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _fadeController,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'MobiStock',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -1,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(0, 4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Inventory Management',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Loading indicator
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom version text
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Version 1.0.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    final random = (index * 0.1) % 1.0;
    final delay = Duration(milliseconds: (random * 2000).toInt());

    return Positioned(
      left: (random * MediaQuery.of(context).size.width * 0.8),
      top: (random * MediaQuery.of(context).size.height * 0.6) + 100,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              (random - 0.5) * 20 * _pulseAnimation.value,
              (random - 0.5) * 15 * _pulseAnimation.value,
            ),
            child: Container(
              width: 4 + (random * 8),
              height: 4 + (random * 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.3 + (random * 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}