/// Profile Studio · Layer 5 — Refined Profile (includes L6 ProfileToneSelection).
///
/// Scrollable refined profile with Natural / Elegant tone tabs and edit
/// affordances for My Story, Interests, Narratives (×2), and Join Me For.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/profile_studio_models.dart';
import '../../providers/profile_studio_provider.dart';
import '../../theme/app_theme.dart';
import 'edit_sheets/interests_edit_sheet.dart';
import 'edit_sheets/join_me_for_edit_sheet.dart';
import 'edit_sheets/my_story_edit_sheet.dart';
import 'edit_sheets/narrative_edit_sheet.dart';
import 'widgets/profile_studio_widgets.dart';

class ProfileRefinedScreen extends ConsumerWidget {
  const ProfileRefinedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileStudioData data =
        ref.watch(profileStudioDataProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _Header(),
            const SizedBox(height: AppSpacing.x4),
            Center(
              child: _ToneTabs(
                tone: data.tone,
                onChanged: (ProfileTone t) => ref
                    .read(profileStudioDataProvider.notifier)
                    .setTone(t),
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              data.tone.subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.interactive300,
                height: 16 / 16,
              ),
            ),
            if (data.tone == ProfileTone.elegant) ...<Widget>[
              const SizedBox(height: AppSpacing.x2),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x3,
                    vertical: AppSpacing.x1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brandLight.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(AppRadius.round),
                  ),
                  child: Text(
                    'Elegant · preview',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.brandDark,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x5,
                  vertical: AppSpacing.x4,
                ),
                children: <Widget>[
                  _MyStorySection(data: data),
                  const SizedBox(height: AppSpacing.x6),
                  _InterestsSection(data: data),
                  const SizedBox(height: AppSpacing.x6),
                  _NarrativesSection(narratives: data.narratives),
                  const SizedBox(height: AppSpacing.x6),
                  _JoinMeForSection(items: data.joinMeFor),
                  const SizedBox(height: AppSpacing.x6),
                  _BottomActions(),
                  const SizedBox(height: AppSpacing.x8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x4,
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => ref
                .read(currentProfileStudioStepProvider.notifier)
                .goTo(ProfileStudioStep.inspiration),
            icon: const Icon(Icons.arrow_back, size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: 'Your profile, ',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.interactive500,
                      height: 32 / 28,
                    ),
                  ),
                  TextSpan(
                    text: 'Refined',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: AppColors.brandDark,
                      height: 32 / 28,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _ToneTabs extends StatelessWidget {
  const _ToneTabs({required this.tone, required this.onChanged});

  final ProfileTone tone;
  final ValueChanged<ProfileTone> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.round),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.interactive300.withValues(alpha: 0.5),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final ProfileTone t in ProfileTone.values)
            _ToneTab(
              tone: t,
              selected: t == tone,
              onTap: () => onChanged(t),
            ),
        ],
      ),
    );
  }
}

class _ToneTab extends StatelessWidget {
  const _ToneTab({
    required this.tone,
    required this.selected,
    required this.onTap,
  });

  final ProfileTone tone;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final IconData icon = tone == ProfileTone.natural
        ? Icons.spa_outlined
        : Icons.workspace_premium_outlined;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 146,
        height: 36,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.brandGradient : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.round),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 16,
              color: selected ? Colors.white : AppColors.interactive300,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              tone.displayName,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : AppColors.interactive300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sections ───────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.onEdit,
    required this.child,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onEdit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.interactive100),
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.brandDark.withValues(alpha: 0.08),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: 16, color: const Color(0xFFC29240)),
              const SizedBox(width: AppSpacing.x2),
              Text(
                title,
                style: GoogleFonts.getFont(
                  'PT Serif',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFC29240),
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              if (onEdit != null)
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 14,
                    color: Color(0xFFC29240),
                  ),
                  label: Text(
                    'Edit',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14,
                      color: const Color(0xFFC29240),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          child,
        ],
      ),
    );
  }
}

class _MyStorySection extends ConsumerWidget {
  const _MyStorySection({required this.data});
  final ProfileStudioData data;

  static const String _naturalDefault =
      'I’m someone who brings the same focus to my personal life as I do my work. I value a balanced approach to everything, making sure there’s always room for genuine connection and growth.';
  static const String _elegantDefault =
      'A quiet grounding runs through my days — the discipline of good work, and the grace to make room for what lasts: honest company, patient conversation, and small, well-kept rituals.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String story = data.myStory.isNotEmpty
        ? data.myStory
        : (data.tone == ProfileTone.elegant ? _elegantDefault : _naturalDefault);
    return _SectionCard(
      icon: Icons.menu_book_outlined,
      title: 'MY STORY',
      onEdit: () => showProfileStudioSheet<void>(
        context: context,
        child: const MyStoryEditSheet(),
      ),
      child: Text(
        story,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontStyle: data.tone == ProfileTone.elegant
              ? FontStyle.italic
              : FontStyle.normal,
          color: AppColors.interactive400,
          height: 24 / 16,
        ),
      ),
    );
  }
}

class _InterestsSection extends ConsumerWidget {
  const _InterestsSection({required this.data});
  final ProfileStudioData data;

  static const List<String> _defaults = <String>[
    'Deep curiosity',
    'Steady growth',
    'Nature',
    'Deep Conversation',
    'Agriculture',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> chips =
        data.interests.isEmpty ? _defaults : data.interests;
    return _SectionCard(
      icon: Icons.grid_view_outlined,
      title: 'INTERESTS',
      onEdit: () => showProfileStudioSheet<void>(
        context: context,
        child: const InterestsEditSheet(),
      ),
      child: Wrap(
        spacing: AppSpacing.x3,
        runSpacing: AppSpacing.x2,
        children: <Widget>[
          for (final String chip in chips)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x4,
                vertical: AppSpacing.x2,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE8C97A)),
                borderRadius: BorderRadius.circular(AppRadius.round),
              ),
              child: Text(
                chip,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.brandDark,
                  height: 16 / 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NarrativesSection extends StatelessWidget {
  const _NarrativesSection({required this.narratives});
  final List<Narrative> narratives;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.auto_stories_outlined,
      title: 'NARRATIVES',
      onEdit: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < narratives.length; i++) ...<Widget>[
            _NarrativeRow(narrative: narratives[i]),
            if (i < narratives.length - 1) ...<Widget>[
              const SizedBox(height: AppSpacing.x3),
              const Divider(color: AppColors.interactive100, height: 1),
              const SizedBox(height: AppSpacing.x3),
            ],
          ],
        ],
      ),
    );
  }
}

class _NarrativeRow extends StatelessWidget {
  const _NarrativeRow({required this.narrative});
  final Narrative narrative;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                narrative.title.toUpperCase(),
                style: GoogleFonts.getFont(
                  'PT Serif',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.interactive500,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                narrative.content,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.interactive400,
                  height: 24 / 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        SizedBox(
          width: 48,
          height: 48,
          child: IconButton(
            onPressed: () => showProfileStudioSheet<void>(
              context: context,
              child: NarrativeEditSheet(narrativeId: narrative.id),
            ),
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.brandLight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              child: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: AppColors.brandDark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _JoinMeForSection extends StatelessWidget {
  const _JoinMeForSection({required this.items});
  final List<String> items;

  static const List<String> _defaults = <String>[
    'A long evening walk',
    'Grabbing a quiet coffee',
    'Checking out local art',
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> display = items.isEmpty ? _defaults : items;
    return _SectionCard(
      icon: Icons.local_activity_outlined,
      title: 'JOIN ME FOR',
      onEdit: () => showProfileStudioSheet<void>(
        context: context,
        child: const JoinMeForEditSheet(),
      ),
      child: Column(
        children: <Widget>[
          for (final String item in display) ...<Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.x4),
              decoration: BoxDecoration(
                color: AppColors.brandDark.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: Text(
                item,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.interactive400,
                  height: 16 / 16,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _BottomActions extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: AppColors.brandDark),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.round),
            ),
          ),
          child: Text(
            'Preview Profile',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.brandDark,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        GradientCta(
          label: 'Complete My Profile',
          trailingArrow: false,
          onPressed: () {
            ref
                .read(currentProfileStudioStepProvider.notifier)
                .goTo(ProfileStudioStep.complete);
          },
        ),
      ],
    );
  }
}
