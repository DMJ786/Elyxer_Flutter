/// Presentational building blocks for the Discovery screen.
///
/// Icons use Material glyphs matched to the design intent (the pixel-exact
/// brand SVGs — the heart "vibe" mark, verified badge — are a later polish
/// pass). Colours/spacing come from the design tokens; two design-specific
/// gold tints that aren't in [AppColors] are defined locally below.
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/discovery_models.dart';
import '../../../theme/app_theme.dart';

/// Brand SVG marks exported from Figma.
const String kVibeIconAsset = 'assets/images/discovery/vibe_icon.svg';
const String kBadgeIconAsset = 'assets/images/discovery/verified_badge.svg';

/// Design tokens local to Discovery (not in the global palette yet).
class _Gold {
  _Gold._();

  /// pillpromptfillcolor — soft cream-gold pill/vibe-button fill.
  static const Color pillFill = Color(0xFFFAF6EC);

  /// brand/primary/medium — section accents, borders, "Magic Search".
  static const Color medium = Color(0xFFC29240);

  /// 8% brand overlay — tinted "Join Me For" / intent rows.
  static const Color overlay8 = Color(0x149B631C);
}

/// The circular gold "Send a Vibe" heart button on every card & section.
class VibeButton extends StatelessWidget {
  const VibeButton({
    super.key,
    required this.onTap,
    this.size = 40,
    this.semanticLabel = 'Send a vibe',
  });

  final VoidCallback onTap;
  final double size;

  /// Screen-reader label — the button is icon-only (a heart mark).
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: _Gold.pillFill,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.brandDark, width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: SvgPicture.asset(
                kVibeIconAsset,
                width: size * 0.5,
                colorFilter: const ColorFilter.mode(
                  AppColors.brandDark,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A small round icon button (header filter / undo).
class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      tooltip: semanticLabel,
      icon: Icon(icon, size: 22, color: AppColors.interactive400),
      splashRadius: 22,
    );
  }
}

/// Top bar: Filter · Magic Search · Undo.
class DiscoveryHeader extends StatelessWidget {
  const DiscoveryHeader({
    super.key,
    required this.onFilter,
    required this.onMagicSearch,
    required this.onUndo,
    this.canUndo = false,
  });

  final VoidCallback onFilter;
  final VoidCallback onMagicSearch;
  final VoidCallback onUndo;
  final bool canUndo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.x5, AppSpacing.x2, AppSpacing.x5, AppSpacing.x2),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.interactive100,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _RoundIconButton(
            icon: Icons.tune,
            onTap: onFilter,
            semanticLabel: 'Filters',
          ),
          InkWell(
            onTap: onMagicSearch,
            borderRadius: BorderRadius.circular(AppRadius.round),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x3, vertical: AppSpacing.x3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.auto_awesome,
                      size: 20, color: AppColors.brandDark),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Magic Search',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      // brandDark meets AA (4.98:1); _Gold.medium fails (#63).
                      color: AppColors.brandDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _RoundIconButton(
            icon: Icons.undo,
            onTap: canUndo ? onUndo : () {},
            semanticLabel: 'Undo',
          ),
        ],
      ),
    );
  }
}

/// A full-width portrait photo card (rounded) with a Vibe button, and — for
/// the lead photo — the name/occupation/location overlay card.
class ProfilePhotoCard extends StatelessWidget {
  const ProfilePhotoCard({
    super.key,
    required this.imageUrl,
    required this.onVibe,
    this.profile,
  });

  final String imageUrl;
  final VoidCallback onVibe;

  /// When set, renders the name overlay card at the bottom (lead photo only).
  final DiscoveryProfile? profile;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: SizedBox(
        height: 510,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : Container(color: AppColors.interactive50),
              errorBuilder: (context, error, stack) => Container(
                color: AppColors.interactive50,
                child: const Icon(Icons.person,
                    size: 64, color: AppColors.interactive200),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: VibeButton(onTap: onVibe),
                  ),
                  const Spacer(),
                  if (profile != null) _NameCard(profile: profile!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NameCard extends StatelessWidget {
  const _NameCard({required this.profile});

  final DiscoveryProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.interactive100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '${profile.name}, ${profile.age}',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.interactive400,
                ),
              ),
              if (profile.verified) ...<Widget>[
                const SizedBox(width: AppSpacing.x3),
                SvgPicture.asset(kBadgeIconAsset, width: 20),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            profile.occupation,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.interactive400,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: <Widget>[
              const Icon(Icons.place, size: 14, color: AppColors.interactive300),
              const SizedBox(width: AppSpacing.x1),
              Text(
                profile.location,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.interactive300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shared white card with a 4px gold left-border + header row (icon · TITLE ·
/// optional Vibe button).
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.onVibe,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final VoidCallback? onVibe;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.x5, AppSpacing.x4, AppSpacing.x4, AppSpacing.x4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: const Border(
          left: BorderSide(color: _Gold.medium, width: 4),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: 16, color: AppColors.brandDark),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandDark,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (onVibe != null) VibeButton(onTap: onVibe!),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          child,
        ],
      ),
    );
  }
}

/// "MY STORY" section.
class MyStorySection extends StatelessWidget {
  const MyStorySection({super.key, required this.story, required this.onVibe});

  final String story;
  final VoidCallback onVibe;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.menu_book_outlined,
      title: 'MY STORY',
      onVibe: onVibe,
      child: Text(
        story,
        style: GoogleFonts.inter(
          fontSize: 16,
          height: 24 / 16,
          color: AppColors.interactive400,
        ),
      ),
    );
  }
}

/// "INTERESTS" section — words separated by dots, wrapping.
class InterestsSection extends StatelessWidget {
  const InterestsSection({
    super.key,
    required this.interests,
    required this.onVibe,
  });

  final List<String> interests;
  final VoidCallback onVibe;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.interests_outlined,
      title: 'INTERESTS',
      onVibe: onVibe,
      child: Wrap(
        spacing: AppSpacing.x3,
        runSpacing: AppSpacing.x2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          for (int i = 0; i < interests.length; i++) ...<Widget>[
            Text(
              interests[i],
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.interactive400,
              ),
            ),
            if (i != interests.length - 1)
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: _Gold.medium,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// "NARRATIVES" section — titled short stories with dividers.
class NarrativesSection extends StatelessWidget {
  const NarrativesSection({
    super.key,
    required this.narratives,
    required this.onVibe,
  });

  final List<ProfileNarrative> narratives;
  final VoidCallback onVibe;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.format_quote,
      title: 'NARRATIVES',
      onVibe: onVibe,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < narratives.length; i++) ...<Widget>[
            if (i != 0) ...<Widget>[
              const SizedBox(height: AppSpacing.x4),
              const Divider(height: 1, color: AppColors.interactive100),
              const SizedBox(height: AppSpacing.x4),
            ],
            Text(
              narratives[i].title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.interactive500,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              narratives[i].content,
              style: GoogleFonts.inter(
                fontSize: 16,
                height: 24 / 16,
                color: AppColors.interactive400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// "JOIN ME FOR" section — tinted option rows.
class JoinMeForSection extends StatelessWidget {
  const JoinMeForSection({
    super.key,
    required this.options,
    required this.onVibe,
  });

  final List<String> options;
  final VoidCallback onVibe;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.event_outlined,
      title: 'JOIN ME FOR',
      onVibe: onVibe,
      child: Column(
        children: <Widget>[
          for (final String option in options)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: AppSpacing.x3),
              padding: const EdgeInsets.all(AppSpacing.x4),
              decoration: BoxDecoration(
                color: _Gold.overlay8,
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: Text(
                option,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.interactive400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The tabbed About / Language / Intent card.
class AboutTabsCard extends StatefulWidget {
  const AboutTabsCard({super.key, required this.profile});

  final DiscoveryProfile profile;

  @override
  State<AboutTabsCard> createState() => _AboutTabsCardState();
}

class _AboutTabsCardState extends State<AboutTabsCard> {
  int _tab = 0;

  static const List<(IconData, String)> _tabs = <(IconData, String)>[
    (Icons.info_outline, 'ABOUT'),
    (Icons.translate, 'LANGUAGE'),
    (Icons.flag_outlined, 'INTENT'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.interactive50),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0x149B631C),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              for (int i = 0; i < _tabs.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _tab = i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.x3, horizontal: AppSpacing.x2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            _tabs[i].$1,
                            size: 16,
                            color: _tab == i
                                ? AppColors.brandDark
                                : AppColors.interactive300,
                          ),
                          const SizedBox(width: AppSpacing.x2),
                          Flexible(
                            child: Text(
                              _tabs[i].$2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _tab == i
                                    ? AppColors.brandDark
                                    : AppColors.interactive300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const Divider(height: 1, color: AppColors.interactive100),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: _tabContent(),
          ),
        ],
      ),
    );
  }

  Widget _tabContent() {
    switch (_tab) {
      case 1:
        return _LanguageContent(languages: widget.profile.languages);
      case 2:
        return _IntentContent(intents: widget.profile.intents);
      case 0:
      default:
        return _AboutContent(about: widget.profile.about);
    }
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent({required this.about});

  final ProfileAbout about;

  @override
  Widget build(BuildContext context) {
    final List<(IconData, String, String)> facts =
        <(IconData, String, String)>[
      (Icons.person_outline, 'GENDER', about.gender),
      (Icons.badge_outlined, 'PRONOUNS', about.pronouns),
      (Icons.favorite_border, 'ORIENTATION', about.orientation),
      (Icons.school_outlined, 'EDUCATION', about.education),
      (Icons.height, 'HEIGHT', about.height),
    ];
    return Wrap(
      spacing: AppSpacing.x3,
      runSpacing: AppSpacing.x3,
      children: <Widget>[
        for (final (IconData icon, String label, String value) in facts)
          SizedBox(
            width: (MediaQuery.sizeOf(context).width - 120) / 3,
            child: _FactTile(icon: icon, label: label, value: value),
          ),
      ],
    );
  }
}

class _FactTile extends StatelessWidget {
  const _FactTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.interactive100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 28, color: _Gold.medium),
          const SizedBox(height: AppSpacing.x2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.interactive400,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.interactive300,
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageContent extends StatelessWidget {
  const _LanguageContent({required this.languages});

  final List<String> languages;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: AppSpacing.x3,
        runSpacing: AppSpacing.x3,
        children: <Widget>[
          for (final String lang in languages)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x4, vertical: AppSpacing.x1),
              decoration: BoxDecoration(
                color: _Gold.pillFill,
                borderRadius: BorderRadius.circular(AppRadius.round),
                border: Border.all(color: _Gold.medium),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: _Gold.medium,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    lang,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF7A5C10),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _IntentContent extends StatelessWidget {
  const _IntentContent({required this.intents});

  final List<String> intents;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (final String intent in intents)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: AppSpacing.x3),
            padding: const EdgeInsets.all(AppSpacing.x4),
            decoration: BoxDecoration(
              color: _Gold.pillFill,
              borderRadius: BorderRadius.circular(AppRadius.large),
              border: Border.all(color: _Gold.overlay8),
            ),
            child: Text(
              intent,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.interactive400,
              ),
            ),
          ),
      ],
    );
  }
}

/// "SOMETHING WRONG?" + Report / Block outlined buttons.
class ReportBlockRow extends StatelessWidget {
  const ReportBlockRow({
    super.key,
    required this.onReport,
    required this.onBlock,
  });

  final VoidCallback onReport;
  final VoidCallback onBlock;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'SOMETHING WRONG?',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.interactive300,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: <Widget>[
            Expanded(
              child: _OutlineActionButton(
                icon: Icons.flag_outlined,
                label: 'REPORT',
                onTap: onReport,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _OutlineActionButton(
                icon: Icons.block,
                label: 'BLOCK',
                onTap: onBlock,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      // brandDark (4.98:1 on cream) meets WCAG AA; the lighter _Gold.medium
      // (2.79:1) fails for text — see the a11y pass (#63).
      icon: Icon(icon, size: 16, color: AppColors.brandDark),
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.brandDark,
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 48),
        side: const BorderSide(color: AppColors.brandDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.round),
        ),
      ),
    );
  }
}

/// The floating Pass (✕) / Invite (paper-plane) action buttons.
class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({
    super.key,
    required this.onPass,
    required this.onInvite,
  });

  final VoidCallback onPass;
  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _ActionCircle(
            onTap: onPass,
            gradient: false,
            semanticLabel: 'Pass',
            child: const Icon(Icons.close,
                size: 24, color: AppColors.interactive400),
          ),
          _ActionCircle(
            onTap: onInvite,
            gradient: true,
            semanticLabel: 'Send invite',
            child: const Icon(Icons.send, size: 22, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _ActionCircle extends StatelessWidget {
  const _ActionCircle({
    required this.onTap,
    required this.gradient,
    required this.child,
    required this.semanticLabel,
  });

  final VoidCallback onTap;
  final bool gradient;
  final Widget child;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: gradient ? null : Colors.white,
            gradient: gradient ? AppColors.brandGradient : null,
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 2.5,
              ),
            ],
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
