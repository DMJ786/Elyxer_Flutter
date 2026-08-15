/// Placeholder for main-shell tabs whose modules aren't built yet
/// (Profile home, Moments, Interests). Keeps the bottom nav fully navigable.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.tab});

  final AppTab tab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  gradient: AppColors.brandGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(tab.icon, size: 32, color: Colors.white),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                tab.label,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.interactive500,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Coming soon',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.interactive300,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(active: tab),
    );
  }
}
