/// OTP Input Widget
/// 6-digit OTP input with individual boxes
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class OTPInput extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final bool hasError;

  const OTPInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.hasError = false,
  });

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    _updateControllersFromValue();
  }

  @override
  void didUpdateWidget(OTPInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _updateControllersFromValue();
    }
  }

  void _updateControllersFromValue() {
    for (int i = 0; i < 6; i++) {
      _controllers[i].text = i < widget.value.length ? widget.value[i] : '';
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleTextChanged(String text, int index) {
    if (text.isEmpty) {
      // Backspace - move to previous box
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    } else {
      // Digit entered - move to next box
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last box - unfocus
        _focusNodes[index].unfocus();
      }
    }

    // Build complete OTP code
    final code = _controllers.map((c) => c.text).join();
    widget.onChanged(code);
  }

  Color _getBorderColor(int index) {
    if (widget.hasError) return AppColors.error;
    if (_focusNodes[index].hasFocus) return AppColors.focus;
    if (_controllers[index].text.isNotEmpty) return AppColors.interactive200;
    return AppColors.interactive100;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.x1),
          child: _buildOTPBox(index),
        );
      }),
    );
  }

  Widget _buildOTPBox(int index) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: _getBorderColor(index),
          width: 2,
        ),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.interactive500,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (text) => _handleTextChanged(text, index),
      ),
    );
  }
}
