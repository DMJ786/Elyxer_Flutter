/// Profile Studio · Layers 2-4 — Inspiration Input.
///
/// Consolidates Figma's Empty / Typed / Inspiration-Used states into a single
/// screen driven by [InspirationInputState] from the provider.
///
/// Note: Figma still uses a static absolute-positioned carousel (C2 blocker in
/// the design review). We replace it with a real horizontally-scrollable
/// PageView so this ships as a usable component even before the designer
/// re-specs the interaction.
library;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/profile_studio_models.dart';
import '../../providers/profile_studio_provider.dart';
import '../../theme/app_theme.dart';
import 'widgets/profile_studio_widgets.dart';

class InspirationInputScreen extends HookConsumerWidget {
  const InspirationInputScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileStudioData data =
        ref.watch(profileStudioDataProvider);
    final bool canProceed = ref.watch(canCreateProfileProvider);

    final TextEditingController controller = useTextEditingController(
      text: switch (data.inspiration) {
        InspirationInputEmpty() => '',
        InspirationInputTyped(:final String text) => text,
        InspirationInputUsed(:final String text) => text,
      },
    );

    useEffect(() {
      void listener() {
        final String value = controller.text;
        if (value.isEmpty) {
          ref
              .read(profileStudioDataProvider.notifier)
              .clearInspiration();
        } else if (data.inspiration is! InspirationInputUsed) {
          ref
              .read(profileStudioDataProvider.notifier)
              .typeInspiration(value);
        }
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, <Object?>[controller]);

    final int currentWords = countWords(controller.text);
    final int wordLimit = switch (data.inspiration) {
      InspirationInputUsed(:final int wordLimit) => wordLimit,
      _ => WordLimits.inspirationInput,
    };

    final PageController pageController =
        usePageController(viewportFraction: 0.9);
    final ValueNotifier<int> carouselIndex = useState<int>(0);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: AppSpacing.x8),
              const Center(
                child: ProfileStudioTitle(
                  subtitle: 'Your words will be shaped into your story.',
                ),
              ),
              const SizedBox(height: AppSpacing.x6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: controller.text.isEmpty
                        ? null
                        : () {
                            controller.clear();
                            ref
                                .read(profileStudioDataProvider.notifier)
                                .clearInspiration();
                          },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(60, 32),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x3,
                        vertical: AppSpacing.x1,
                      ),
                      side: const BorderSide(
                          color: AppColors.interactive200),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.round),
                      ),
                    ),
                    child: Text(
                      'Clear',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.interactive400,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x1),
              _InputField(
                controller: controller,
                currentWords: currentWords,
                wordLimit: wordLimit,
                isUsed: data.inspiration is InspirationInputUsed,
              ),
              const SizedBox(height: AppSpacing.x6),
              _InspirationHeader(),
              const SizedBox(height: AppSpacing.x2),
              SizedBox(
                height: 174,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (int i) => carouselIndex.value = i,
                  itemCount: InspirationSuggestion.all.length,
                  itemBuilder: (BuildContext ctx, int i) {
                    final InspirationSuggestion s =
                        InspirationSuggestion.all[i];
                    final bool selected = data.inspiration
                            is InspirationInputUsed &&
                        (data.inspiration as InspirationInputUsed)
                                .suggestionId ==
                            s.id;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _SuggestionCard(
                        suggestion: s,
                        selected: selected,
                        onTap: () {
                          ref
                              .read(profileStudioDataProvider
                                  .notifier)
                              .useInspiration(s);
                          controller.text = s.text;
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              _CarouselDots(
                count: InspirationSuggestion.all.length,
                active: carouselIndex.value,
              ),
              const Spacer(),
              GradientCta(
                label: 'Create My Profile',
                onPressed: () {
                  if (!canProceed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Add a few words of inspiration first.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  ref
                      .read(currentProfileStudioStepProvider.notifier)
                      .goTo(ProfileStudioStep.refined);
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.currentWords,
    required this.wordLimit,
    required this.isUsed,
  });

  final TextEditingController controller;
  final int currentWords;
  final int wordLimit;
  final bool isUsed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: AppColors.brandLight.withValues(alpha: 0.5),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: AppColors.interactive400,
                height: 24 / 16,
              ),
              decoration: nakedInput(
                hintText: isUsed
                    ? null
                    : 'Early mornings, quiet bookshops, and someone who thinks Sunday should last all week…',
                hintStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: AppColors.interactive200,
                  height: 24 / 16,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              WordLimitCounter(current: currentWords, limit: wordLimit),
              Icon(
                Icons.edit_outlined,
                size: 16,
                color: AppColors.brandDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InspirationHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'INPUT INSPIRATIONS',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFC29240),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Center(
          child: Text(
            'Tap an inspiration or write in your own words',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.interactive300,
              height: 16 / 16,
            ),
          ),
        ),
      ],
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.suggestion,
    required this.selected,
    required this.onTap,
  });

  final InspirationSuggestion suggestion;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Figma spec: subtle brown tint over cream — expressed as SOLID color
    // (composited manually) so Flutter web's boxShadow blur can't bleed
    // through a semi-transparent fill and wash the card grey.
    // 3% brown over cream = ~#FDF9EE (default), 8% = ~#F8ECD0 (selected).
    final Color fill = selected
        ? const Color(0xFFF8ECD0)
        : const Color(0xFFFDF9EE);
    final Color stripe =
        selected ? AppColors.brandDark : const Color(0xFFC29240);

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Material(
          color: fill,
          borderRadius: BorderRadius.circular(AppRadius.large),
          elevation: 1,
          shadowColor: selected
              ? AppColors.brandLight.withValues(alpha: 0.5)
              : Colors.black.withValues(alpha: 0.08),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.large),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.large),
                border: selected
                    ? Border.all(color: const Color(0xFFC29240))
                    : null,
              ),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x4 + 3,
                AppSpacing.x4,
                AppSpacing.x4,
                AppSpacing.x4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    suggestion.text,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: AppColors.interactive400,
                      height: 24 / 16,
                    ),
                  ),
                  Wrap(
                    spacing: AppSpacing.x3,
                    runSpacing: AppSpacing.x2,
                    children: <Widget>[
                      for (final String tag in suggestion.tags) _TagChip(tag),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // 3px gold left stripe overlaid on top of the card (clipped by
        // the Material's rounded corners via ClipRRect wrapper below).
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppRadius.large),
              bottomLeft: Radius.circular(AppRadius.large),
            ),
            child: Container(width: 3, color: stripe),
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.round),
        border: Border.all(color: AppColors.brandLight.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.brandDark,
          height: 16 / 12,
        ),
      ),
    );
  }
}

class _CarouselDots extends StatelessWidget {
  const _CarouselDots({required this.count, required this.active});
  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: i == active ? 14 : 5,
            height: 5,
            decoration: BoxDecoration(
              color: i == active
                  ? AppColors.brandDark
                  : AppColors.interactive200,
              borderRadius: BorderRadius.circular(AppRadius.round),
            ),
          ),
      ],
    );
  }
}
