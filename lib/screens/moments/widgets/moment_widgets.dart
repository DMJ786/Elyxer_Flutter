/// Presentational building blocks for the Moments feed + composer.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/moment_models.dart';
import '../../../theme/app_theme.dart';

const Color _goldMedium = Color(0xFFC29240);
const Color _pillFill = Color(0xFFFAF6EC);

/// Actions available from a moment's overflow menu.
enum MomentMenuAction { edit, delete, vibe, invite, report }

/// Gold mood pill ("Coffee & thoughts").
class MoodChip extends StatelessWidget {
  const MoodChip({super.key, required this.mood});

  final Mood mood;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3, vertical: AppSpacing.x1),
      decoration: BoxDecoration(
        color: _pillFill,
        borderRadius: BorderRadius.circular(AppRadius.round),
        border: Border.all(color: _goldMedium.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.eco_outlined, size: 12, color: _goldMedium),
          const SizedBox(width: AppSpacing.x1),
          Text(
            mood.label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.brandDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// "SHARE A MOMENT +" call-to-action row.
class ShareMomentBar extends StatelessWidget {
  const ShareMomentBar({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.round),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.round),
          border: Border.all(color: AppColors.interactive100),
          boxShadow: <BoxShadow>[
            BoxShadow(color: AppColors.interactive100, blurRadius: 2),
          ],
        ),
        child: Row(
          children: <Widget>[
            Text(
              'SHARE A MOMENT',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.interactive400,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                gradient: AppColors.brandGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single feed card.
class MomentCard extends StatelessWidget {
  const MomentCard({
    super.key,
    required this.moment,
    required this.onAction,
    this.onTapAuthor,
  });

  final Moment moment;
  final void Function(MomentMenuAction) onAction;
  final VoidCallback? onTapAuthor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.x4),
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.interactive100),
        boxShadow: <BoxShadow>[
          BoxShadow(color: AppColors.interactive100, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
                onTap: moment.isMine ? null : onTapAuthor,
                borderRadius: BorderRadius.circular(AppRadius.round),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.interactive50,
                      backgroundImage: moment.author.photos.isNotEmpty
                          ? NetworkImage(moment.author.photos.first)
                          : null,
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          moment.displayName,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.interactive500,
                          ),
                        ),
                        Text(
                          moment.timeLabel,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.interactive300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _MomentMenu(isMine: moment.isMine, onAction: onAction),
            ],
          ),
          if (moment.text != null) ...<Widget>[
            const SizedBox(height: AppSpacing.x3),
            Text(
              moment.text!,
              style: GoogleFonts.inter(
                fontSize: 15,
                height: 22 / 15,
                color: AppColors.interactive400,
              ),
            ),
          ],
          if (moment.imageBytes != null) ...<Widget>[
            const SizedBox(height: AppSpacing.x3),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: AspectRatio(
                aspectRatio: 4 / 5,
                child: Image.memory(moment.imageBytes!, fit: BoxFit.cover),
              ),
            ),
          ] else if (moment.imageUrl != null) ...<Widget>[
            const SizedBox(height: AppSpacing.x3),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: Container(
                width: double.infinity,
                color: AppColors.interactive50,
                constraints: const BoxConstraints(maxHeight: 340),
                child: Image.network(
                  moment.imageUrl!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) =>
                      Container(height: 160, color: AppColors.interactive50),
                ),
              ),
            ),
          ],
          if (moment.mood != null) ...<Widget>[
            const SizedBox(height: AppSpacing.x3),
            Align(
              alignment: Alignment.centerLeft,
              child: MoodChip(mood: moment.mood!),
            ),
          ],
        ],
      ),
    );
  }
}

class _MomentMenu extends StatelessWidget {
  const _MomentMenu({required this.isMine, required this.onAction});

  final bool isMine;
  final void Function(MomentMenuAction) onAction;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MomentMenuAction>(
      icon: const Icon(Icons.more_vert, color: AppColors.interactive300),
      onSelected: onAction,
      itemBuilder: (BuildContext context) => isMine
          ? const <PopupMenuEntry<MomentMenuAction>>[
              PopupMenuItem<MomentMenuAction>(
                value: MomentMenuAction.edit,
                child: Text('Edit'),
              ),
              PopupMenuItem<MomentMenuAction>(
                value: MomentMenuAction.delete,
                child: Text('Delete'),
              ),
            ]
          : const <PopupMenuEntry<MomentMenuAction>>[
              PopupMenuItem<MomentMenuAction>(
                value: MomentMenuAction.vibe,
                child: Text('Send a Vibe'),
              ),
              PopupMenuItem<MomentMenuAction>(
                value: MomentMenuAction.invite,
                child: Text('Send an Invite'),
              ),
              PopupMenuItem<MomentMenuAction>(
                value: MomentMenuAction.report,
                child: Text('Report'),
              ),
            ],
    );
  }
}

/// Empty feed state.
class MomentsEmptyState extends StatelessWidget {
  const MomentsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: _pillFill,
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: const Icon(Icons.auto_awesome, size: 28, color: _goldMedium),
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              "It's quiet in here...",
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.interactive500,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              'No new moments yet. Check back soon.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.interactive300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The "SELECT YOUR MOOD" 3-column grid used by the composer.
class MoodGrid extends StatelessWidget {
  const MoodGrid({super.key, required this.selected, required this.onSelect});

  final Mood? selected;
  final ValueChanged<Mood> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.x3,
      runSpacing: AppSpacing.x2,
      children: <Widget>[
        for (final Mood mood in Mood.values)
          _MoodTile(
            mood: mood,
            selected: selected == mood,
            onTap: () => onSelect(mood),
            width: (MediaQuery.sizeOf(context).width - 40 - 24) / 3,
          ),
      ],
    );
  }
}

class _MoodTile extends StatelessWidget {
  const _MoodTile({
    required this.mood,
    required this.selected,
    required this.onTap,
    required this.width,
  });

  final Mood mood;
  final bool selected;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Container(
        width: width,
        height: 49,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x2, vertical: AppSpacing.x2),
        decoration: BoxDecoration(
          color: selected ? _pillFill : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(
            color: selected ? _goldMedium : AppColors.interactive100,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.eco_outlined, size: 13, color: _goldMedium),
            const SizedBox(height: AppSpacing.x1),
            Flexible(
              child: Text(
                mood.label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
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
