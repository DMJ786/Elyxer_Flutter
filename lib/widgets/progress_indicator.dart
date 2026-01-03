/// Progress Indicator Widget
/// Shows 4-step progress with animated transitions
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';
import '../models/verification_models.dart';

class CustomProgressIndicator extends StatelessWidget {
  final int currentStep;

  const CustomProgressIndicator({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    // Generate steps based on current step
    final steps = List.generate(4, (index) {
      return ProgressStep(
        id: index.toString(),
        icon: _getStepIcon(index),
        status: index < currentStep
            ? StepStatus.completed
            : index == currentStep
                ? StepStatus.inProgress
                : StepStatus.incomplete,
      );
    });

    return ProgressIndicatorWidget(
      steps: steps,
      currentStep: currentStep,
    );
  }

  StepIcon _getStepIcon(int index) {
    switch (index) {
      case 0:
        return StepIcon.phone;
      case 1:
        return StepIcon.account;
      case 2:
        return StepIcon.mail;
      case 3:
        return StepIcon.complete;
      default:
        return StepIcon.phone;
    }
  }
}

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final stepCount = steps.length;
          
          // Calculate responsive sizing
          final activeSize = 60.0;
          final inactiveSize = 40.0;
          final spacing = AppSpacing.x1;
          
          // Total width needed for icons
          final totalIconWidth = activeSize + (inactiveSize * (stepCount - 1));
          // Remaining width for bars and spacing
          final remainingWidth = availableWidth - totalIconWidth - (spacing * 2 * (stepCount - 1));
          // Calculate bar width to fit perfectly with some margin
          final barWidth = (remainingWidth / (stepCount - 1)) - 2; // Subtract 2px safety margin
          
          return Column(
            children: [
              // Step indicators and bars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildStepsWithBars(barWidth.clamp(20.0, 50.0)),
              ),
              const SizedBox(height: 8),
              // Progress dot indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(steps.length, (index) {
                  final isActive = index == currentStep;
                  final iconSize = isActive ? activeSize : inactiveSize;
                  final clampedBarWidth = barWidth.clamp(20.0, 50.0);
                  
                  return Row(
                    children: [
                      // Centered dot under each step
                      SizedBox(
                        width: iconSize,
                        child: Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: isActive 
                                  ? AppColors.brandDark 
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      // Add spacing for progress bar between steps
                      if (index < steps.length - 1)
                        SizedBox(
                          width: clampedBarWidth + (spacing * 2),
                        ),
                    ],
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildStepsWithBars(double barWidth) {
    final widgets = <Widget>[];

    for (int i = 0; i < steps.length; i++) {
      // Add step icon
      widgets.add(_buildStepIcon(steps[i], i));

      // Add progress bar between steps (except after last step)
      if (i < steps.length - 1) {
        widgets.add(_buildProgressBar(i, barWidth));
      }
    }

    return widgets;
  }

  Widget _buildStepIcon(ProgressStep step, int index) {
    final isActive = index == currentStep;
    final size = isActive ? 60.0 : 40.0;

    // Get SVG asset path based on step icon and status
    final svgPath = _getSvgPath(step.icon, step.status);

    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        svgPath,
        fit: BoxFit.contain,
      ),
    );
  }

  String _getSvgPath(StepIcon icon, StepStatus status) {
    // Map icon to folder name
    final folderName = _getIconFolder(icon);
    
    // Map status to filename
    final fileName = _getStatusFileName(icon, status);
    
    return 'assets/images/$folderName/$fileName';
  }

  String _getIconFolder(StepIcon icon) {
    switch (icon) {
      case StepIcon.phone:
        return 'PhonenumberIconContainer';
      case StepIcon.account:
        return 'AccountIconContainer';
      case StepIcon.mail:
        return 'MailIconContainer';
      case StepIcon.complete:
        return 'CompleteIconContainer';
    }
  }

  String _getStatusFileName(StepIcon icon, StepStatus status) {
    // All SVG files now use consistent naming
    switch (status) {
      case StepStatus.completed:
        return 'Completed.svg';
      case StepStatus.inProgress:
        return 'Inprogress.svg';
      case StepStatus.incomplete:
        return 'Incomplete.svg';
    }
  }

  Widget _buildProgressBar(int index, double barWidth) {
    // Connector is completed if it's before the current step
    final completed = index < currentStep;
    
    // Connector should animate NOW if we just moved to the next step
    // (i.e., the connector at index == currentStep - 1)
    final animateNow = (index == currentStep - 1 && currentStep > 0);

    return AnimatedConnectorBar(
      key: ValueKey('bar-$index-$currentStep'), // Force rebuild on step change
      width: barWidth,
      completed: completed,
      animateNow: animateNow,
    );
  }
}

/// Animated Connector Bar Widget
/// Animates the horizontal progress bar between steps
class AnimatedConnectorBar extends StatefulWidget {
  final double width;
  final bool completed;
  final bool animateNow;

  const AnimatedConnectorBar({
    super.key,
    required this.width,
    required this.completed,
    required this.animateNow,
  });

  @override
  State<AnimatedConnectorBar> createState() => _AnimatedConnectorBarState();
}

class _AnimatedConnectorBarState extends State<AnimatedConnectorBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fillAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    // Set initial state based on completed status
    if (widget.completed && !widget.animateNow) {
      // Already completed from previous steps
      _controller.value = 1.0;
    } else if (widget.animateNow) {
      // Should animate now
      _controller.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(AnimatedConnectorBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Trigger animation when animateNow becomes true
    if (!oldWidget.animateNow && widget.animateNow) {
      _controller.forward(from: 0.0);
    } else if (widget.completed && !widget.animateNow && _controller.value != 1.0) {
      // Instantly show as completed if already passed
      _controller.value = 1.0;
    } else if (!widget.completed) {
      // Reset if not completed
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.x1),
      child: Stack(
        children: [
          // Background line (always visible - grey)
          Container(
            width: widget.width,
            height: 2,
            decoration: const BoxDecoration(
              color: AppColors.interactive100,
            ),
          ),
          // Animated foreground fill (gold)
          AnimatedBuilder(
            animation: _fillAnimation,
            builder: (context, child) {
              final fillWidth = widget.completed || widget.animateNow
                  ? widget.width * _fillAnimation.value
                  : 0.0;
              
              return Container(
                width: fillWidth,
                height: 2,
                decoration: const BoxDecoration(
                  color: AppColors.brandDark,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
