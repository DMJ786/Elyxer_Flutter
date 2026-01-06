/// Progress Indicator Widget
/// Shows 4-step progress with animated transitions
library;

import 'package:flutter/material.dart';
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
    return SizedBox(
      height: 78,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Step indicators and bars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildStepsWithBars(),
          ),
          // Progress dot indicator
          Positioned(
            top: 68,
            left: (MediaQuery.of(context).size.width - 40) / 2 - // Account for 20px padding on each side
                166.5 + // Center offset for first icon
                (currentStep * 107.667), // Spacing: 60px icon + 47.667px bar
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.brandDark,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStepsWithBars() {
    final widgets = <Widget>[];

    for (int i = 0; i < steps.length; i++) {
      // Add step icon
      widgets.add(_buildStepIcon(steps[i], i));

      // Add progress bar between steps (except after last step)
      if (i < steps.length - 1) {
        widgets.add(_buildProgressBar(i));
      }
    }

    return widgets;
  }

  Widget _buildStepIcon(ProgressStep step, int index) {
    final isActive = index == currentStep;
    final isCompleted = step.status == StepStatus.completed;
    final size = isActive ? 60.0 : 40.0;
    final iconSize = isActive ? 24.0 : 16.0;

    return SizedBox(
      width: 60.0,
      height: 60.0,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: (isCompleted || isActive) ? AppColors.brandGradient : null,
            color: (!isCompleted && !isActive) ? AppColors.interactive100 : null,
            shape: BoxShape.circle,
            boxShadow: isActive ? AppShadows.defaultShadow : null,
          ),
          child: Icon(
            _getIconData(step.icon),
            size: iconSize,
            color: (isCompleted || isActive) ? Colors.white : AppColors.interactive300,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(int index) {
    final isCompleted = steps[index].status == StepStatus.completed;
    final isInProgress =
        steps[index].status == StepStatus.completed &&
        index + 1 < steps.length &&
        steps[index + 1].status == StepStatus.inProgress;

    return Container(
      width: 39.667,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.x1),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.brandDark
            : isInProgress
                ? AppColors.brandLight
                : AppColors.interactive100,
      ),
    );
  }

  IconData _getIconData(StepIcon icon) {
    switch (icon) {
      case StepIcon.phone:
        return Icons.phone_outlined;
      case StepIcon.account:
        return Icons.person_outline;
      case StepIcon.mail:
        return Icons.mail_outline;
      case StepIcon.complete:
        return Icons.check;
    }
  }
}
