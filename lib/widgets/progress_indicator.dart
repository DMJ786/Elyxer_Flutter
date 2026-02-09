/// Progress Indicator Widget
/// Shows 4-step progress with animated transitions
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';
import '../models/verification_models.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final List<ProgressStep> steps;
  final int currentStep;

  const ProgressIndicatorWidget({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive icon size: 15% of screen width, clamped between 48-70px
    final iconSize = (screenWidth * 0.15).clamp(48.0, 70.0);

    return SizedBox(
      height: iconSize,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildStepsWithBars(context),
      ),
    );
  }

  List<Widget> _buildStepsWithBars(BuildContext context) {
    final widgets = <Widget>[];

    for (int i = 0; i < steps.length; i++) {
      // Add step icon
      widgets.add(_buildStepIcon(steps[i], i, context));

      // Add progress bar between steps (except after last step)
      if (i < steps.length - 1) {
        widgets.add(_buildProgressBar(i, context));
      }
    }

    return widgets;
  }

  Widget _buildStepIcon(ProgressStep step, int index, BuildContext context) {
    final isActive = index == currentStep;

    // Responsive sizing based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final activeSize = (screenWidth * 0.15).clamp(48.0, 70.0);
    final inactiveSize = (screenWidth * 0.10).clamp(32.0, 50.0);
    final containerSize = activeSize;
    final iconSize = isActive ? activeSize : inactiveSize;

    return SizedBox(
      width: containerSize,
      height: containerSize,
      child: Center(
        child: SizedBox(
          width: iconSize,
          height: iconSize,
          child: SvgPicture.asset(
            _getIconAssetPath(step.icon, step.status),
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(int index, BuildContext context) {
    final isCompleted = steps[index].status == StepStatus.completed;
    final isInProgress =
        steps[index].status == StepStatus.completed &&
        index + 1 < steps.length &&
        steps[index + 1].status == StepStatus.inProgress;

    // Responsive bar width: 8% of screen width, clamped between 20-40px
    final screenWidth = MediaQuery.of(context).size.width;
    final barWidth = (screenWidth * 0.08).clamp(20.0, 40.0);

    return Container(
      width: barWidth,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.brandDark
            : isInProgress
                ? AppColors.brandLight
                : AppColors.interactive100,
      ),
    );
  }

  String _getIconAssetPath(StepIcon icon, StepStatus status) {
    final statusFolder = switch (status) {
      StepStatus.completed => 'Completed',
      StepStatus.inProgress => 'Inprogress',
      StepStatus.incomplete => 'Incomplete',
    };

    final iconFolder = switch (icon) {
      StepIcon.phone => 'PhonenumberIconContainer',
      StepIcon.account => 'AccountIconContainer',
      StepIcon.mail => 'MailIconContainer',
      StepIcon.complete => 'CompleteIconContainer',
    };

    return 'assets/images/$iconFolder/$statusFolder.svg';
  }
}
