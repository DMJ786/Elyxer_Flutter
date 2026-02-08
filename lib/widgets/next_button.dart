/// Next Button Widget
/// Circular button with arrow icon - positioned at bottom right
///
/// ## Bug Fix (PR #2): SVG Asset Switching
///
/// Problem: Flutter's widget reconciliation was caching SvgPicture.asset
/// widgets. When _assetPath changed, Flutter didn't rebuild because the
/// widget type was the same, causing wrong SVG to display.
///
/// Solution: Added `key: ValueKey(_assetPath)` to force widget rebuild.
///
/// ## Troubleshooting
/// If the button still shows wrong state after this fix:
/// 1. Do a FULL RESTART (not hot reload) - press 'R' in terminal or restart app
/// 2. Run `flutter clean && flutter pub get`
/// 3. Delete build folder and rebuild
///
/// Set `NextButton.enableDebugLogs = true` to see asset switching logs.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NextButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isDisabled;

  /// Enable debug logging to verify SVG asset switching
  /// Set to true to see which asset is being loaded in debug console
  static bool enableDebugLogs = kDebugMode;

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

  void _logAssetChange(String context) {
    if (NextButton.enableDebugLogs) {
      debugPrint('[NextButton] $context: $_assetPath');
      debugPrint('  - isDisabled: ${widget.isDisabled}');
      debugPrint('  - onPressed: ${widget.onPressed != null ? "provided" : "null"}');
      debugPrint('  - _isPressed: $_isPressed');
    }
  }

  @override
  void didUpdateWidget(NextButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDisabled != widget.isDisabled ||
        (oldWidget.onPressed == null) != (widget.onPressed == null)) {
      _logAssetChange('Props changed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.isDisabled || widget.onPressed == null;
    final String currentAsset = _assetPath;

    _logAssetChange('Building');

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) {
        setState(() => _isPressed = true);
        _logAssetChange('Tap down');
      },
      onTapUp: isDisabled
          ? null
          : (_) {
              setState(() => _isPressed = false);
              _logAssetChange('Tap up');
              widget.onPressed?.call();
            },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _logAssetChange('Tap cancel');
      },
      // ValueKey forces Flutter to rebuild the widget when asset path changes.
      // Without this, Flutter's widget reconciliation caches the SvgPicture
      // and doesn't recognize that the asset path has changed, causing the
      // button to display the wrong state (e.g., showing Default.svg when
      // it should show Disabled.svg).
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive sizing: 14% of screen width, min 44px, max 64px
          final screenWidth = MediaQuery.of(context).size.width;
          final size = (screenWidth * 0.14).clamp(44.0, 64.0);

          return SvgPicture.asset(
            currentAsset,
            key: ValueKey(currentAsset),
            width: size,
            height: size,
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }
}
