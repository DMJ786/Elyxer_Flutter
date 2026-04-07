// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Current onboarding step provider (Module 1: Age, Gender, Pronoun)

@ProviderFor(CurrentOnboardingStep)
const currentOnboardingStepProvider = CurrentOnboardingStepProvider._();

/// Current onboarding step provider (Module 1: Age, Gender, Pronoun)
final class CurrentOnboardingStepProvider
    extends $NotifierProvider<CurrentOnboardingStep, OnboardingStep> {
  /// Current onboarding step provider (Module 1: Age, Gender, Pronoun)
  const CurrentOnboardingStepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentOnboardingStepProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentOnboardingStepHash();

  @$internal
  @override
  CurrentOnboardingStep create() => CurrentOnboardingStep();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingStep value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingStep>(value),
    );
  }
}

String _$currentOnboardingStepHash() =>
    r'27de89ac5ce244cee1143036fcfc4713cabd97bb';

/// Current onboarding step provider (Module 1: Age, Gender, Pronoun)

abstract class _$CurrentOnboardingStep extends $Notifier<OnboardingStep> {
  OnboardingStep build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<OnboardingStep, OnboardingStep>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnboardingStep, OnboardingStep>,
              OnboardingStep,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Current orientation step provider (Module 2: Sexual Orientation, Dating Preference, Dating Goals)

@ProviderFor(CurrentOrientationStep)
const currentOrientationStepProvider = CurrentOrientationStepProvider._();

/// Current orientation step provider (Module 2: Sexual Orientation, Dating Preference, Dating Goals)
final class CurrentOrientationStepProvider
    extends $NotifierProvider<CurrentOrientationStep, OrientationStep> {
  /// Current orientation step provider (Module 2: Sexual Orientation, Dating Preference, Dating Goals)
  const CurrentOrientationStepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentOrientationStepProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentOrientationStepHash();

  @$internal
  @override
  CurrentOrientationStep create() => CurrentOrientationStep();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrientationStep value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrientationStep>(value),
    );
  }
}

String _$currentOrientationStepHash() =>
    r'52327c7cbb56c67ad5b15f9c81e8724ff69056ba';

/// Current orientation step provider (Module 2: Sexual Orientation, Dating Preference, Dating Goals)

abstract class _$CurrentOrientationStep extends $Notifier<OrientationStep> {
  OrientationStep build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<OrientationStep, OrientationStep>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OrientationStep, OrientationStep>,
              OrientationStep,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Current Background step provider

@ProviderFor(CurrentBackgroundStep)
const currentBackgroundStepProvider = CurrentBackgroundStepProvider._();

/// Current Background step provider
final class CurrentBackgroundStepProvider
    extends $NotifierProvider<CurrentBackgroundStep, BackgroundStep> {
  /// Current Background step provider
  const CurrentBackgroundStepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentBackgroundStepProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentBackgroundStepHash();

  @$internal
  @override
  CurrentBackgroundStep create() => CurrentBackgroundStep();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackgroundStep value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BackgroundStep>(value),
    );
  }
}

String _$currentBackgroundStepHash() =>
    r'0f6ae4caf51b7f30067cd44873feadc9139916d6';

/// Current Background step provider

abstract class _$CurrentBackgroundStep extends $Notifier<BackgroundStep> {
  BackgroundStep build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BackgroundStep, BackgroundStep>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BackgroundStep, BackgroundStep>,
              BackgroundStep,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Onboarding data provider

@ProviderFor(OnboardingDataNotifier)
const onboardingDataProvider = OnboardingDataNotifierProvider._();

/// Onboarding data provider
final class OnboardingDataNotifierProvider
    extends $NotifierProvider<OnboardingDataNotifier, OnboardingData> {
  /// Onboarding data provider
  const OnboardingDataNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingDataProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingDataNotifierHash();

  @$internal
  @override
  OnboardingDataNotifier create() => OnboardingDataNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingData>(value),
    );
  }
}

String _$onboardingDataNotifierHash() =>
    r'0c9315a1a15165e1d167908b5fb7b5a36c9595a3';

/// Onboarding data provider

abstract class _$OnboardingDataNotifier extends $Notifier<OnboardingData> {
  OnboardingData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<OnboardingData, OnboardingData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnboardingData, OnboardingData>,
              OnboardingData,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Computed provider: Can proceed with current onboarding step

@ProviderFor(canProceedOnboarding)
const canProceedOnboardingProvider = CanProceedOnboardingProvider._();

/// Computed provider: Can proceed with current onboarding step

final class CanProceedOnboardingProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Computed provider: Can proceed with current onboarding step
  const CanProceedOnboardingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canProceedOnboardingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canProceedOnboardingHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canProceedOnboarding(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$canProceedOnboardingHash() =>
    r'3db1c1655d1d686d5091ec32221c33acfe14c836';

/// Computed provider: Can proceed with current orientation step

@ProviderFor(canProceedOrientation)
const canProceedOrientationProvider = CanProceedOrientationProvider._();

/// Computed provider: Can proceed with current orientation step

final class CanProceedOrientationProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Computed provider: Can proceed with current orientation step
  const CanProceedOrientationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canProceedOrientationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canProceedOrientationHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canProceedOrientation(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$canProceedOrientationHash() =>
    r'49377306046650e3c9008fdffbb03d58c9b9f59b';
