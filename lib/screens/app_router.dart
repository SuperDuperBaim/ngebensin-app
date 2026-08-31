import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../theme/colors.dart';
import '../widgets/main_bottom_nav_bar.dart';

// Screen imports
import 'splash_screen.dart';
import 'username_screen.dart';
import 'vehicle_screen.dart';
import 'home_screen.dart';
import 'station_screen.dart';
import 'fuel_screen.dart';
import 'unit_screen.dart';
import 'amount_screen.dart';
import 'success_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'help_screen.dart';
import 'manage_vehicles_screen.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    if (provider.isLoading) {
      return const _AppSkeletonLoadingScreen();
    }

    Widget screen;
    switch (provider.currentStep) {
      case AppStep.splash:
        screen = const SplashScreen();
        break;
      case AppStep.username:
        screen = const UsernameScreen();
        break;
      case AppStep.vehicle:
        screen = const VehicleScreen();
        break;
      case AppStep.home:
        screen = const HomeScreen();
        break;
      case AppStep.station:
        screen = const StationScreen();
        break;
      case AppStep.fuel:
        screen = const FuelScreen();
        break;
      case AppStep.unit:
        screen = const UnitScreen();
        break;
      case AppStep.amount:
        screen = const AmountScreen();
        break;
      case AppStep.success:
        screen = const SuccessScreen();
        break;
      case AppStep.history:
        screen = const HistoryScreen();
        break;
      case AppStep.settings:
        screen = const SettingsScreen();
        break;
      case AppStep.help:
        screen = const HelpScreen();
        break;
      case AppStep.manageVehicles:
        screen = const ManageVehiclesScreen();
        break;
    }

    final isGoingBack = provider.currentStep == AppStep.home ||
        provider.currentStep == AppStep.splash;

    final bool showBottomNav = provider.currentStep == AppStep.home ||
        provider.currentStep == AppStep.history ||
        provider.currentStep == AppStep.manageVehicles ||
        provider.currentStep == AppStep.help ||
        provider.currentStep == AppStep.settings;

    Widget mainContent = AnimatedSwitcher(
      duration: const Duration(milliseconds: 380),
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      transitionBuilder: (child, animation) {
        final isIncoming = child.key == ValueKey(provider.currentStep);
        final slideOffset = isGoingBack
            ? (isIncoming ? const Offset(-0.08, 0.0) : const Offset(0.08, 0.0))
            : (isIncoming ? const Offset(0.08, 0.0) : const Offset(-0.08, 0.0));

        return SlideTransition(
          position: Tween<Offset>(begin: slideOffset, end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic)),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: KeyedSubtree(key: ValueKey(provider.currentStep), child: screen),
    );

    if (showBottomNav) {
      return Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: mainContent,
        bottomNavigationBar: const MainBottomNavBar(),
        extendBody: true,
      );
    }

    return Container(
      color: AppColors.primaryDark,
      child: mainContent,
    );
  }
}

// ==========================================
// SKELETON LOADING SCREEN
// ==========================================
class _AppSkeletonLoadingScreen extends StatelessWidget {
  const _AppSkeletonLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            // Fake Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 80, height: 12, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6))),
                      const SizedBox(height: 6),
                      Container(width: 50, height: 10, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(5))),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 90, height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ],
              ),
            ),
            // Fake Cream Body
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary cards row
                      Row(
                        children: [
                          Expanded(child: _SkeletonBox(height: 88, radius: 20)),
                          const SizedBox(width: 12),
                          Expanded(child: _SkeletonBox(height: 88, radius: 20)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // CTA Button skeleton
                      const _SkeletonBox(height: 68, radius: 24),
                      const SizedBox(height: 24),
                      // Section header
                      const _SkeletonBox(height: 14, width: 130),
                      const SizedBox(height: 14),
                      // History item skeletons
                      const _SkeletonBox(height: 70, radius: 16),
                      const SizedBox(height: 10),
                      const _SkeletonBox(height: 70, radius: 16),
                      const SizedBox(height: 10),
                      const _SkeletonBox(height: 70, radius: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A shimmering skeleton placeholder box for loading states.
class _SkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  const _SkeletonBox({required this.height, this.width = double.infinity, this.radius = 12});

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.lerp(const Color(0xFFE8EDE4), const Color(0xFFD0DAC8), _anim.value)!,
              Color.lerp(const Color(0xFFD0DAC8), const Color(0xFFE8EDE4), _anim.value)!,
            ],
          ),
        ),
      ),
    );
  }
}
