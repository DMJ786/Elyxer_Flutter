/// Next Button Widget
/// Circular button with arrow icon - positioned at bottom right
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

class NextButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isDisabled;

  const NextButton({
    super.key,
    required this.onPressed,
    this.isDisabled = false,
  });

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  bool _isPressed = false;

  String get _assetPath {
    if (widget.isDisabled || widget.onPressed == null) {
      return 'assets/images/NextButton/Disabled.svg';
    } else if (_isPressed) {
      return 'assets/images/NextButton/Pressed.svg';
    } else {
      return 'assets/images/NextButton/Default.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.isDisabled || widget.onPressed == null;
    
    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
      onTapUp: isDisabled
          ? null
          : (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            },
      onTapCancel: () => setState(() => _isPressed = false),
      // ValueKey forces Flutter to rebuild the widget when asset path changes.
      // Without this, Flutter's widget reconciliation caches the SvgPicture
      // and doesn't recognize that the asset path has changed, causing the
      // button to display the wrong state (e.g., showing Default.svg when
      // it should show Disabled.svg).
      child: SvgPicture.asset(
        _assetPath,
        key: ValueKey(_assetPath),
        width: 54,
        height: 54,
        fit: BoxFit.contain,
      ),
    );
  }
}
