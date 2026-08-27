/// Presentational building blocks for the Interests screen.
library;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/discovery_models.dart';
import '../../../models/interest_models.dart';
import '../../../theme/app_theme.dart';
import '../../discovery/widgets/discovery_widgets.dart' show kVibeIconAsset;

const Color _goldMedium = Color(0xFFC29240);
const Color _pillFill = Color(0xFFFAF6EC);

IconData _vibeContextIcon(VibeContext c) {
  switch (c) {
    case VibeContext.picture:
      return Icons.photo_camera_outlined;
    case VibeContext.myStory:
      return Icons.menu_book_outlined;
    case VibeContext.narrative:
      return Icons.format_quote;
    case VibeContext.interests:
      return Icons.interests_outlined;
    case VibeContext.joinMeFor:
      return Icons.event_outlined;
  }
}

/// Vibes | Invites toggle (active tab = gold gradient).
class InterestsTabToggle extends StatelessWidget {
  const InterestsTabToggle({
    super.key,
    required this.tab,
    required this.onChanged,
  });

  final InterestsTab tab;
  final ValueChanged<InterestsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3, vertical: AppSpacing.x1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.round),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _TabButton(
              label: 'Vibes',
              active: tab == InterestsTab.vibes,
              iconAsset: kVibeIconAsset,
              onTap: () => onChanged(InterestsTab.vibes),
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'Invites',
              active: tab == InterestsTab.invites,
              icon: Icons.send,
              onTap: () => onChanged(InterestsTab.invites),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
    this.icon,
    this.iconAsset,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData? icon;
  final String? iconAsset;

  @override
  Widget build(BuildContext context) {
    final Color fg = active ? Colors.white : AppColors.interactive300;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.round),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          gradient: active ? AppColors.brandGradient : null,
          borderRadius: BorderRadius.circular(AppRadius.round),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (iconAsset != null)
              SvgPicture.asset(iconAsset!,
                  width: 16,
                  colorFilter: ColorFilter.mode(fg, BlendMode.srcIn))
            else if (icon != null)
              Icon(icon, size: 16, color: fg),
            const SizedBox(width: AppSpacing.x1),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Vibes 5" outline count pill.
class InterestCountChip extends StatelessWidget {
  const InterestCountChip({super.key, required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4, vertical: AppSpacing.x1),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.interactive200),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ShaderMask(
            shaderCallback: (Rect b) => AppColors.brandGradient.createShader(b),
            child: Text(
              '$label ',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            '$count',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.interactive300,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared card chrome (avatar + name + trailing) used by both card types.
class _InterestCardShell extends StatelessWidget {
  const _InterestCardShell({
    required this.profile,
    required this.trailing,
    required this.subtitle,
    required this.body,
    required this.onTap,
  });

  final DiscoveryProfile profile;
  final Widget trailing;
  final Widget subtitle;
  final Widget body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.interactive200),
        boxShadow: <BoxShadow>[
          BoxShadow(color: AppColors.interactive100, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.interactive50,
                backgroundImage: profile.photos.isNotEmpty
                    ? NetworkImage(profile.photos.first)
                    : null,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Text(
                  profile.name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.interactive500,
                    letterSpacing: 1,
                  ),
                ),
              ),
              trailing,
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          subtitle,
          const SizedBox(height: AppSpacing.x3),
          body,
          const SizedBox(height: AppSpacing.x2),
          InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              height: 40,
              alignment: Alignment.center,
              child: Text(
                'Tap to view profile & respond',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _goldMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A received-vibe card.
class ReceivedVibeCard extends StatelessWidget {
  const ReceivedVibeCard({super.key, required this.vibe, required this.onTap});

  final ReceivedVibe vibe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _InterestCardShell(
      profile: vibe.from,
      onTap: onTap,
      trailing: Icon(_vibeContextIcon(vibe.context),
          size: 20, color: _goldMedium),
      subtitle: Text.rich(
        TextSpan(
          text: 'Vibed on your ',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.interactive300,
          ),
          children: <InlineSpan>[
            TextSpan(
              text: vibe.context.label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.brandDark,
              ),
            ),
          ],
        ),
      ),
      body: _VibeContentPreview(vibe: vibe),
    );
  }
}

class _VibeContentPreview extends StatelessWidget {
  const _VibeContentPreview({required this.vibe});

  final ReceivedVibe vibe;

  @override
  Widget build(BuildContext context) {
    final DiscoveryProfile p = vibe.from;
    switch (vibe.context) {
      case VibeContext.picture:
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: SizedBox(
            height: 134,
            width: double.infinity,
            child: p.photos.isNotEmpty
                ? Image.network(p.photos.first, fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        Container(color: AppColors.interactive50))
                : Container(color: AppColors.interactive50),
          ),
        );
      case VibeContext.interests:
        return _borderedBox(
          Wrap(
            spacing: AppSpacing.x3,
            runSpacing: AppSpacing.x2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              for (int i = 0; i < p.interests.length; i++) ...<Widget>[
                Text(p.interests[i],
                    style: GoogleFonts.inter(
                        fontSize: 16, color: AppColors.interactive400)),
                if (i != p.interests.length - 1)
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                        color: _goldMedium, shape: BoxShape.circle),
                  ),
              ],
            ],
          ),
        );
      case VibeContext.narrative:
        return _borderedBox(
          Row(
            children: <Widget>[
              for (int i = 0; i < p.narratives.length && i < 2; i++) ...<Widget>[
                if (i != 0) const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    p.narratives[i].title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.interactive400,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      case VibeContext.joinMeFor:
        final String text = vibe.joinMeForOption ??
            (p.joinMeFor.isNotEmpty ? p.joinMeFor.first : '');
        return _borderedBox(
          Text(text,
              style: GoogleFonts.inter(
                  fontSize: 16, color: AppColors.interactive400)),
        );
      case VibeContext.myStory:
        return _borderedBox(
          Text(
            '"${p.myStory}"',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 16,
              height: 24 / 16,
              color: AppColors.interactive400,
            ),
          ),
        );
    }
  }

  Widget _borderedBox(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.large)),
        border: Border(left: BorderSide(color: _goldMedium, width: 2)),
      ),
      child: child,
    );
  }
}

/// A received-invite card.
class ReceivedInviteCard extends StatelessWidget {
  const ReceivedInviteCard({
    super.key,
    required this.invite,
    required this.onTap,
  });

  final ReceivedInvite invite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _InterestCardShell(
      profile: invite.from,
      onTap: onTap,
      trailing: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3, vertical: AppSpacing.x1),
        decoration: BoxDecoration(
          color: _pillFill,
          borderRadius: BorderRadius.circular(AppRadius.round),
          border: Border.all(color: _goldMedium),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(invite.type.icon, size: 12, color: _goldMedium),
            const SizedBox(width: AppSpacing.x1),
            Text(
              invite.type.label.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF7A5C10),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      subtitle: Text.rich(
        TextSpan(
          text: 'Invited you for ',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.interactive300,
          ),
          children: <InlineSpan>[
            TextSpan(
              text: invite.type.label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.brandDark,
              ),
            ),
          ],
        ),
      ),
      body: invite.message == null
          ? const SizedBox.shrink()
          : Text(
              invite.message!,
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 20 / 14,
                color: AppColors.interactive400,
              ),
            ),
    );
  }
}

/// Blurs + locks a card for non-premium users (freemium gate).
class PaywallBlur extends StatelessWidget {
  const PaywallBlur({super.key, required this.child, required this.blurred});

  final Widget child;
  final bool blurred;

  @override
  Widget build(BuildContext context) {
    if (!blurred) return child;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Stack(
        children: <Widget>[
          child,
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: AppColors.cream.withValues(alpha: 0.3),
                alignment: Alignment.center,
                child: const Icon(Icons.lock_outline,
                    color: _goldMedium, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom "unlock" CTA for free users.
class UnlockBanner extends StatelessWidget {
  const UnlockBanner({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.round),
      child: Container(
        width: double.infinity,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: BorderRadius.circular(AppRadius.round),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.lock_open, size: 16, color: Colors.white),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'Unlock to see everyone',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state per tab.
class InterestsEmptyState extends StatelessWidget {
  const InterestsEmptyState({super.key, required this.tab, required this.onEditProfile});

  final InterestsTab tab;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    final bool isVibes = tab == InterestsTab.vibes;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(isVibes ? Icons.favorite_border : Icons.send_outlined,
                size: 48, color: AppColors.interactive200),
            const SizedBox(height: AppSpacing.x4),
            Text(
              isVibes ? 'No vibes yet' : 'No invites yet',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.interactive500,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              'A complete profile stands out. Add candid photos and enrich '
              'your profile to get discovered.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.interactive300,
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            SizedBox(
              width: 160,
              height: 44,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
                child: TextButton(
                  onPressed: onEditProfile,
                  child: Text(
                    'Edit profile',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
