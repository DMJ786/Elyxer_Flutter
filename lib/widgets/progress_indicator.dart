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
    // Find which step is currently in progress for the dot position
    final inProgressIndex = steps.indexWhere((step) => step.status == StepStatus.inProgress);
    final dotPosition = inProgressIndex >= 0 ? inProgressIndex : currentStep;
    
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
                (dotPosition * 107.667), // Spacing: 60px icon + 47.667px bar
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
    // Icon is active if it's in progress status
    final isActive = step.status == StepStatus.inProgress;
    final size = isActive ? 60.0 : 40.0;

    return SizedBox(
      width: 60.0,
      height: 60.0,
      child: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            _getIconAssetPath(step.icon, step.status),
            width: size,
            height: size,
            fit: BoxFit.contain,
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
      width: 30.0,
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
