/// Interests popups: mutual-connection accept dialogs + response toasts.
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../discovery/widgets/discovery_widgets.dart' show kVibeIconAsset;

const Color _goldMedium = Color(0xFFC29240);
const Color _pillFill = Color(0xFFFAF6EC);

/// "Mutual Vibe!" — shown after vibing back. Returns true if "Chat Now".
Future<bool?> showMutualVibeDialog(BuildContext context, String name) {
  return _showConnectDialog(
    context,
    iconSvg: kVibeIconAsset,
    title: 'Mutual Vibe!',
    body: 'You and $name are now connected! Start a conversation now or later.',
  );
}

/// "Invite Accepted!" — shown after accepting an invite. Returns true if "Chat Now".
Future<bool?> showInviteAcceptedDialog(BuildContext context, String name) {
  return _showConnectDialog(
    context,
    icon: Icons.send,
    title: 'Invite Accepted!',
    body: 'You and $name are now connected! Start a conversation now or later.',
  );
}

Future<bool?> _showConnectDialog(
  BuildContext context, {
  IconData? icon,
  String? iconSvg,
  required String title,
  required String body,
}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext ctx) {
      return Dialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: _pillFill,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: iconSvg != null
                      ? SvgPicture.asset(iconSvg,
                          width: 28,
                          colorFilter: const ColorFilter.mode(
                              AppColors.brandDark, BlendMode.srcIn))
                      : Icon(icon, size: 26, color: AppColors.brandDark),
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.interactive500,
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              Text(
                body,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 20 / 14,
                  color: AppColors.interactive300,
                ),
              ),
              const SizedBox(height: AppSpacing.x5),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        side: const BorderSide(color: AppColors.interactive300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                        ),
                      ),
                      child: Text(
                        'Later',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.interactive300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => Navigator.of(ctx).pop(true),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: AppColors.brandGradient,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.medium),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Icon(Icons.chat_bubble_outline,
                                    size: 16, color: Colors.white),
                                const SizedBox(width: AppSpacing.x2),
                                Text(
                                  'Chat Now',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showPassedToast(BuildContext context, String name) =>
    _pillToast(context, icon: Icons.close, title: 'Passed', subtitle: 'You passed on $name');

void showConnectionSavedToast(BuildContext context, String name) =>
    _pillToast(context,
        icon: Icons.check, title: 'Connection saved', subtitle: 'You can chat with $name anytime');

void showDeclinedToast(BuildContext context, String name) =>
    _pillToast(context, icon: Icons.close, title: 'Declined', subtitle: 'You declined $name');

void _pillToast(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        elevation: 6,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.round),
          side: const BorderSide(color: _goldMedium),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 60, vertical: AppSpacing.x6),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4, vertical: AppSpacing.x2),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 18, color: AppColors.brandDark),
            const SizedBox(width: AppSpacing.x3),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.interactive500)),
                Text(subtitle,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.interactive300)),
              ],
            ),
          ],
        ),
      ),
    );
}
