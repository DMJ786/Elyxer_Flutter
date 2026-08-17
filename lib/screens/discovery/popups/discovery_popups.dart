/// Discovery popups: Send a Vibe, Send an Invite, Block, Report, their
/// confirmation dialogs, and the "sent" toasts.
///
/// All bottom sheets use the app's standard [showProfileStudioSheet] chrome
/// (cream bg, rounded top). Each returns a small result object; the screen
/// orchestrates the actual repository call + confirmation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/discovery_models.dart';
import '../../../theme/app_theme.dart';
import '../../profile_studio/widgets/profile_studio_widgets.dart';
import '../widgets/discovery_widgets.dart' show kVibeIconAsset;

const Color _goldMedium = Color(0xFFC29240);
const Color _pillFill = Color(0xFFFAF6EC);
const Color _reasonRed = Color(0xFFBD4A44);

// ===========================================================================
// Send a Vibe
// ===========================================================================

enum VibeSheetOutcome { sendVibe, switchToInvite }

class VibeSheetResult {
  const VibeSheetResult(this.outcome, {this.joinMeForOption});
  final VibeSheetOutcome outcome;
  final String? joinMeForOption;
}

Future<VibeSheetResult?> showSendVibeSheet(
  BuildContext context, {
  required VibeContext vibeContext,
  List<String> joinMeForOptions = const <String>[],
  String? labelOverride,
}) {
  return showProfileStudioSheet<VibeSheetResult>(
    context: context,
    child: _SendVibeSheet(
      vibeContext: vibeContext,
      joinMeForOptions: joinMeForOptions,
      labelOverride: labelOverride,
    ),
  );
}

class _SendVibeSheet extends StatefulWidget {
  const _SendVibeSheet({
    required this.vibeContext,
    required this.joinMeForOptions,
    this.labelOverride,
  });

  final VibeContext vibeContext;
  final List<String> joinMeForOptions;

  /// Overrides the bold subtitle noun (e.g. "Moments"). Defaults to the
  /// context's own label.
  final String? labelOverride;

  @override
  State<_SendVibeSheet> createState() => _SendVibeSheetState();
}

class _SendVibeSheetState extends State<_SendVibeSheet> {
  String? _selectedOption;

  bool get _isJoinMeFor => widget.vibeContext.isJoinMeFor;
  bool get _canSend => !_isJoinMeFor || _selectedOption != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.x5,
        right: AppSpacing.x5,
        top: AppSpacing.x4,
        bottom: AppSpacing.x6 + MediaQuery.viewInsetsOf(context).bottom,
      ),
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
              child: SvgPicture.asset(
                kVibeIconAsset,
                width: 30,
                colorFilter: const ColorFilter.mode(
                  AppColors.brandDark,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          Text(
            'Send a Vibe',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.interactive400,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          if (_isJoinMeFor) ...<Widget>[
            Text(
              'Pick which Join Me For you vibe with',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.interactive400,
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            for (final String option in widget.joinMeForOptions)
              _RadioRow(
                label: option,
                selected: _selectedOption == option,
                onTap: () => setState(() => _selectedOption = option),
              ),
            const SizedBox(height: AppSpacing.x4),
          ] else ...<Widget>[
            Text.rich(
              TextSpan(
                text: 'Let them know you vibe with their ',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.interactive400,
                ),
                children: <InlineSpan>[
                  TextSpan(
                    text: widget.labelOverride ?? widget.vibeContext.label,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.interactive400,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.x6),
          ],
          Row(
            children: <Widget>[
              Expanded(child: _CancelButton()),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _GradientButton(
                  label: 'Send Vibe',
                  iconAsset: kVibeIconAsset,
                  enabled: _canSend,
                  onTap: () => Navigator.of(context).pop(
                    VibeSheetResult(
                      VibeSheetOutcome.sendVibe,
                      joinMeForOption: _selectedOption,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x6),
          Row(
            children: <Widget>[
              const Expanded(child: Divider(color: AppColors.interactive100)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
                child: Text(
                  'OR',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.interactive300,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: AppColors.interactive100)),
            ],
          ),
          const SizedBox(height: AppSpacing.x6),
          InkWell(
            onTap: () => Navigator.of(context).pop(
              const VibeSheetResult(VibeSheetOutcome.switchToInvite),
            ),
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x6, vertical: AppSpacing.x6),
              decoration: BoxDecoration(
                color: _pillFill,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(
                  color: AppColors.brandLight.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(Icons.send, size: 16, color: AppColors.interactive400),
                      const SizedBox(width: AppSpacing.x2),
                      Text(
                        'Send an Invite',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.interactive400,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(Icons.north_east, size: 16, color: _goldMedium),
                      const SizedBox(width: AppSpacing.x2),
                      Text(
                        'Stand Out More',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _goldMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Send an Invite
// ===========================================================================

class InviteSheetResult {
  const InviteSheetResult(this.type, {this.note});
  final InviteType type;
  final String? note;
}

Future<InviteSheetResult?> showSendInviteSheet(BuildContext context) {
  return showProfileStudioSheet<InviteSheetResult>(
    context: context,
    child: const _SendInviteSheet(),
  );
}

class _SendInviteSheet extends StatefulWidget {
  const _SendInviteSheet();

  @override
  State<_SendInviteSheet> createState() => _SendInviteSheetState();
}

class _SendInviteSheetState extends State<_SendInviteSheet> {
  InviteType? _selected;
  final TextEditingController _noteController = TextEditingController();
  static const int _wordLimit = 20;

  int get _wordCount {
    final String text = _noteController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).length;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.x5,
        right: AppSpacing.x5,
        top: AppSpacing.x4,
        bottom: AppSpacing.x6 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.send, size: 20, color: _goldMedium),
                const SizedBox(width: AppSpacing.x3),
                Text(
                  'Send an Invite',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.interactive400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              'Choose your invite type',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.interactive300,
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              alignment: WrapAlignment.center,
              children: <Widget>[
                for (final InviteType type in InviteType.values)
                  _InviteCard(
                    type: type,
                    selected: _selected == type,
                    onTap: () => setState(() => _selected = type),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.x4),
            Container(
              padding: const EdgeInsets.all(AppSpacing.x3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(color: AppColors.interactive100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextField(
                    controller: _noteController,
                    maxLines: 2,
                    onChanged: (_) => setState(() {}),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.interactive400,
                    ),
                    decoration: nakedInput(
                      hintText: 'Say something nice... (optional)',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.interactive300,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  WordLimitCounter(current: _wordCount, limit: _wordLimit),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            Row(
              children: <Widget>[
                Expanded(child: _CancelButton()),
                const SizedBox(width: AppSpacing.x4),
                Expanded(
                  child: _GradientButton(
                    label: 'Send Invite',
                    icon: Icons.send,
                    enabled: _selected != null && _wordCount <= _wordLimit,
                    onTap: () => Navigator.of(context).pop(
                      InviteSheetResult(
                        _selected!,
                        note: _noteController.text,
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
  }
}

class _InviteCard extends StatelessWidget {
  const _InviteCard({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final InviteType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        width: 86,
        height: 96,
        padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.x2, horizontal: AppSpacing.x1),
        decoration: BoxDecoration(
          color: selected ? _pillFill : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(
            color: selected ? _goldMedium : AppColors.interactive200,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: _pillFill,
                shape: BoxShape.circle,
              ),
              child: Icon(type.icon, size: 18, color: _goldMedium),
            ),
            const SizedBox(height: AppSpacing.x1),
            Flexible(
              child: Text(
                type.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.15,
                  color: AppColors.interactive300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// Block / Report (shared reason sheet)
// ===========================================================================

class ReasonSheetResult {
  const ReasonSheetResult(this.index, {this.details});
  final int index;
  final String? details;
}

Future<ReasonSheetResult?> showBlockSheet(BuildContext context) {
  return showProfileStudioSheet<ReasonSheetResult>(
    context: context,
    child: _ReasonSheet(
      icon: Icons.block,
      title: 'Block',
      subtitle: "This person won't be able to see your profile or send you messages",
      question: 'Why are you blocking?',
      reasons: <String>[for (final BlockReason r in BlockReason.values) r.label],
      actionLabel: 'Block',
    ),
  );
}

Future<ReasonSheetResult?> showReportSheet(BuildContext context) {
  return showProfileStudioSheet<ReasonSheetResult>(
    context: context,
    child: _ReasonSheet(
      icon: Icons.flag_outlined,
      title: 'Report',
      subtitle: 'Your report stays completely anonymous',
      question: "What's the issue?",
      reasons: <String>[for (final ReportReason r in ReportReason.values) r.label],
      actionLabel: 'Report',
    ),
  );
}

class _ReasonSheet extends StatefulWidget {
  const _ReasonSheet({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.question,
    required this.reasons,
    required this.actionLabel,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String question;
  final List<String> reasons;
  final String actionLabel;

  @override
  State<_ReasonSheet> createState() => _ReasonSheetState();
}

class _ReasonSheetState extends State<_ReasonSheet> {
  int? _selected;
  final TextEditingController _detailsController = TextEditingController();

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.x5,
        right: AppSpacing.x5,
        top: AppSpacing.x4,
        bottom: AppSpacing.x5 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _reasonRed.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(widget.icon, size: 18, color: _reasonRed),
                ),
                const SizedBox(width: AppSpacing.x4),
                Text(
                  widget.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.interactive400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              widget.subtitle,
              style: GoogleFonts.inter(
                fontSize: 16,
                height: 24 / 16,
                color: AppColors.interactive300,
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              widget.question,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.interactive400,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            for (int i = 0; i < widget.reasons.length; i++)
              _ReasonRow(
                label: widget.reasons[i],
                selected: _selected == i,
                onTap: () => setState(() => _selected = i),
              ),
            const SizedBox(height: AppSpacing.x3),
            Text(
              'Additional Details',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.interactive300,
              ),
            ),
            const SizedBox(height: AppSpacing.x3),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x4, vertical: AppSpacing.x4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(color: AppColors.interactive100),
              ),
              child: TextField(
                controller: _detailsController,
                maxLines: 2,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.interactive400,
                ),
                decoration: nakedInput(
                  hintText: 'Tell us more about why you\'re ${widget.actionLabel.toLowerCase()}ing...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppColors.interactive300,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            Row(
              children: <Widget>[
                Expanded(child: _CancelButton()),
                const SizedBox(width: AppSpacing.x4),
                Expanded(
                  child: _SolidButton(
                    label: widget.actionLabel,
                    color: _reasonRed,
                    enabled: _selected != null,
                    onTap: () => Navigator.of(context).pop(
                      ReasonSheetResult(
                        _selected!,
                        details: _detailsController.text.trim().isEmpty
                            ? null
                            : _detailsController.text.trim(),
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
  }
}

class _ReasonRow extends StatelessWidget {
  const _ReasonRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: AppSpacing.x2),
        padding: const EdgeInsets.all(AppSpacing.x4),
        decoration: BoxDecoration(
          color: selected ? _reasonRed.withValues(alpha: 0.2) : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: AppColors.interactive100),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              selected ? Icons.cancel : Icons.cancel_outlined,
              size: 16,
              color: _reasonRed,
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.interactive400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Radio row used by the Join-Me-For vibe variant.
class _RadioRow extends StatelessWidget {
  const _RadioRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: AppSpacing.x3),
        padding: const EdgeInsets.all(AppSpacing.x4),
        decoration: BoxDecoration(
          color: selected ? _pillFill : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(
            color: selected ? _goldMedium : AppColors.interactive100,
          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              size: 20,
              color: selected ? _goldMedium : AppColors.interactive200,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.interactive400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// Confirmation dialogs
// ===========================================================================

Future<void> showBlockedDialog(BuildContext context) {
  return _showConfirmDialog(
    context,
    title: 'Blocked',
    body:
        'The profile has been blocked. Our team will look into the details promptly and take appropriate action if required.',
  );
}

Future<void> showReportSubmittedDialog(BuildContext context) {
  return _showConfirmDialog(
    context,
    title: 'Report Submitted',
    body:
        'Thank you for letting us know. Our team will look into the details promptly and take appropriate action.',
  );
}

Future<void> _showConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext ctx) {
      return Dialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(AppSpacing.x5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _goldMedium, width: 2),
                    ),
                    child: const Icon(Icons.check, size: 24, color: _goldMedium),
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
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 16 / 14,
                      color: AppColors.interactive300,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: AppSpacing.x2,
              right: AppSpacing.x2,
              child: IconButton(
                onPressed: () => Navigator.of(ctx).pop(),
                icon: const Icon(Icons.close, size: 20),
                color: AppColors.interactive400,
              ),
            ),
          ],
        ),
      );
    },
  );
}

// ===========================================================================
// Toasts
// ===========================================================================

void showVibeSentToast(BuildContext context) =>
    _showPillToast(context, icon: Icons.favorite, title: 'Vibe sent', subtitle: "They'll hear it");

void showInviteSentToast(BuildContext context) =>
    _showPillToast(context, icon: Icons.send, title: 'Invite sent', subtitle: 'Awaiting reply');

void _showPillToast(
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
        margin: const EdgeInsets.symmetric(
            horizontal: 80, vertical: AppSpacing.x6),
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
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.interactive500,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.interactive300,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
}

// ===========================================================================
// Shared buttons
// ===========================================================================

class _CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => Navigator.of(context).maybePop(),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 48),
        side: const BorderSide(color: AppColors.interactive300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
      child: Text(
        'Cancel',
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.interactive300,
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.iconAsset,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  /// SVG asset shown (white) instead of [icon] when provided.
  final String? iconAsset;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Ink(
            decoration: BoxDecoration(
              gradient: enabled ? AppColors.brandGradient : null,
              color: enabled ? null : AppColors.interactive100,
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (iconAsset != null) ...<Widget>[
                  SvgPicture.asset(
                    iconAsset!,
                    width: 16,
                    colorFilter: ColorFilter.mode(
                      enabled ? Colors.white : AppColors.interactive300,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                ] else if (icon != null) ...<Widget>[
                  Icon(icon, size: 16,
                      color: enabled ? Colors.white : AppColors.interactive300),
                  const SizedBox(width: AppSpacing.x2),
                ],
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: enabled ? Colors.white : AppColors.interactive300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SolidButton extends StatelessWidget {
  const _SolidButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Material(
        color: enabled ? color : AppColors.interactive100,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: enabled ? Colors.white : AppColors.interactive300,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
