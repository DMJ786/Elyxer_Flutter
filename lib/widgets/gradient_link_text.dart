/// Gradient Link Text Widget
/// Reusable gold gradient underlined text link
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientLinkText extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const GradientLinkText({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ShaderMask(
        shaderCallback: (bounds) => AppColors.brandGradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            decoration: TextDecoration.underline,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
