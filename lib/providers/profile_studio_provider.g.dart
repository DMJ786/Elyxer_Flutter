// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_studio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentProfileStudioStep)
const currentProfileStudioStepProvider = CurrentProfileStudioStepProvider._();

final class CurrentProfileStudioStepProvider
    extends $NotifierProvider<CurrentProfileStudioStep, ProfileStudioStep> {
  const CurrentProfileStudioStepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentProfileStudioStepProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentProfileStudioStepHash();

  @$internal
  @override
  CurrentProfileStudioStep create() => CurrentProfileStudioStep();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileStudioStep value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileStudioStep>(value),
    );
  }
}

String _$currentProfileStudioStepHash() =>
    r'339260e060767c570859733c5a2d86403cccd33b';

abstract class _$CurrentProfileStudioStep extends $Notifier<ProfileStudioStep> {
  ProfileStudioStep build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ProfileStudioStep, ProfileStudioStep>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProfileStudioStep, ProfileStudioStep>,
              ProfileStudioStep,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ProfileStudioDataNotifier)
const profileStudioDataProvider = ProfileStudioDataNotifierProvider._();

final class ProfileStudioDataNotifierProvider
    extends $NotifierProvider<ProfileStudioDataNotifier, ProfileStudioData> {
  const ProfileStudioDataNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileStudioDataProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileStudioDataNotifierHash();

  @$internal
  @override
  ProfileStudioDataNotifier create() => ProfileStudioDataNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileStudioData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileStudioData>(value),
    );
  }
}

String _$profileStudioDataNotifierHash() =>
    r'098eab999dd4738c39e9f75b6ab5e16aff889a08';

abstract class _$ProfileStudioDataNotifier
    extends $Notifier<ProfileStudioData> {
  ProfileStudioData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ProfileStudioData, ProfileStudioData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProfileStudioData, ProfileStudioData>,
              ProfileStudioData,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// True when the inspiration input has enough content to enable Create My Profile.

@ProviderFor(canCreateProfile)
const canCreateProfileProvider = CanCreateProfileProvider._();

/// True when the inspiration input has enough content to enable Create My Profile.

final class CanCreateProfileProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// True when the inspiration input has enough content to enable Create My Profile.
  const CanCreateProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canCreateProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canCreateProfileHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canCreateProfile(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$canCreateProfileHash() => r'99b188e1009bcf7b1980eb43e4ab508820acc324';
