/// Profile Studio · Layer 1 — Intro
///
/// Static intro: 3-step gradient chip row + three descriptor cards + gradient
/// CTA that advances to the Inspiration Input step.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/profile_studio_models.dart';
import '../../providers/profile_studio_provider.dart';
import '../../theme/app_theme.dart';
import 'widgets/profile_studio_widgets.dart';

class ProfileStudioIntroScreen extends ConsumerWidget {
  const ProfileStudioIntroScreen({super.key});

  static const List<_IntroStep> _steps = <_IntroStep>[
    _IntroStep(1, 'You write'),
    _IntroStep(2, 'We shape'),
    _IntroStep(3, 'We curate'),
  ];

  static const List<_StepCard> _cards = <_StepCard>[
    _StepCard(
      icon: Icons.edit_outlined,
      title: 'Your Story, in your words',
      subtitle: 'Interests • Work • Weekends • Passions',
    ),
    _StepCard(
      icon: Icons.dashboard_outlined,
      title: 'A profile that reads naturally',
      subtitle: 'We turn your words into a structured story',
    ),
    _StepCard(
      icon: Icons.auto_awesome_outlined,
      title: 'Connecting to people who get you',
      subtitle: 'Discover people who resonate with your world',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 40),
              Text(
                'PROFILE STUDIO',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2.4,
                  color: const Color(0xFF7A5C10),
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: 'Craft the story ',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.interactive500,
                        height: 32 / 28,
                      ),
                    ),
                    TextSpan(
                      text: 'that represents you',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: AppColors.brandDark,
                        height: 32 / 28,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Go beyond the bio. Build a profile worth reading.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.interactive300,
                  height: 16 / 14,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              const _StepsIndicator(steps: _steps),
              const SizedBox(height: AppSpacing.x4),
              for (int i = 0; i < _cards.length; i++) ...<Widget>[
                _cards[i],
                if (i < _cards.length - 1)
                  const SizedBox(height: AppSpacing.x4),
              ],
              const Spacer(),
              GradientCta(
                label: 'Create My Profile',
                onPressed: () {
                  ref
                      .read(currentProfileStudioStepProvider.notifier)
                      .goTo(ProfileStudioStep.inspiration);
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroStep {
  const _IntroStep(this.number, this.label);
  final int number;
  final String label;
}

class _StepsIndicator extends StatelessWidget {
  const _StepsIndicator({required this.steps});
  final List<_IntroStep> steps;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < steps.length; i++) {
      children.add(_StepChip(step: steps[i]));
      if (i < steps.length - 1) {
        children.add(
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.x1),
              child: Divider(
                color: AppColors.interactive100,
                thickness: 1,
                height: 1,
              ),
            ),
          ),
        );
      }
    }
    return SizedBox(
      width: 347,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}

class _StepChip extends StatelessWidget {
  const _StepChip({required this.step});
  final _IntroStep step;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            gradient: AppColors.brandGradient,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '${step.number}',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 16 / 16,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          step.label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.interactive300,
            height: 16 / 12,
          ),
        ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.interactive100),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.brandLight.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Icon(icon, size: 24, color: AppColors.brandDark),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.interactive500,
                    height: 32 / 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.interactive300,
                    height: 16 / 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
