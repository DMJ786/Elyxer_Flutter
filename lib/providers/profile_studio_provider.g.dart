// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_studio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The active service impl. Uses the real BFF endpoint
/// (`POST /generateProfileStudio` on Cloud Functions) — Claude Haiku 4.5
/// on Vertex AI Model Garden generates the profile.
///
/// For local dev without the emulator, override this provider with
/// `MockProfileStudioService()` in tests via a ProviderScope override.

@ProviderFor(profileStudioService)
const profileStudioServiceProvider = ProfileStudioServiceProvider._();

/// The active service impl. Uses the real BFF endpoint
/// (`POST /generateProfileStudio` on Cloud Functions) — Claude Haiku 4.5
/// on Vertex AI Model Garden generates the profile.
///
/// For local dev without the emulator, override this provider with
/// `MockProfileStudioService()` in tests via a ProviderScope override.

final class ProfileStudioServiceProvider
    extends
        $FunctionalProvider<
          ProfileStudioService,
          ProfileStudioService,
          ProfileStudioService
        >
    with $Provider<ProfileStudioService> {
  /// The active service impl. Uses the real BFF endpoint
  /// (`POST /generateProfileStudio` on Cloud Functions) — Claude Haiku 4.5
  /// on Vertex AI Model Garden generates the profile.
  ///
  /// For local dev without the emulator, override this provider with
  /// `MockProfileStudioService()` in tests via a ProviderScope override.
  const ProfileStudioServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileStudioServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileStudioServiceHash();

  @$internal
  @override
  $ProviderElement<ProfileStudioService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileStudioService create(Ref ref) {
    return profileStudioService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileStudioService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileStudioService>(value),
    );
  }
}

String _$profileStudioServiceHash() =>
    r'2466be2528b968e452cfffff0b99eede2612e0ac';

/// Async state of the LLM generation call. `AsyncValue.data` after a
/// successful call — screens read this to know when to swap from the
/// loading state to the Refined screen.

@ProviderFor(ProfileStudioGeneration)
const profileStudioGenerationProvider = ProfileStudioGenerationProvider._();

/// Async state of the LLM generation call. `AsyncValue.data` after a
/// successful call — screens read this to know when to swap from the
/// loading state to the Refined screen.
final class ProfileStudioGenerationProvider
    extends
        $NotifierProvider<
          ProfileStudioGeneration,
          AsyncValue<ProfileStudioData?>
        > {
  /// Async state of the LLM generation call. `AsyncValue.data` after a
  /// successful call — screens read this to know when to swap from the
  /// loading state to the Refined screen.
  const ProfileStudioGenerationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileStudioGenerationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileStudioGenerationHash();

  @$internal
  @override
  ProfileStudioGeneration create() => ProfileStudioGeneration();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ProfileStudioData?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ProfileStudioData?>>(
        value,
      ),
    );
  }
}

String _$profileStudioGenerationHash() =>
    r'c459bb611458ea55fe8c69c23c69f08d23cf83cd';

/// Async state of the LLM generation call. `AsyncValue.data` after a
/// successful call — screens read this to know when to swap from the
/// loading state to the Refined screen.

abstract class _$ProfileStudioGeneration
    extends $Notifier<AsyncValue<ProfileStudioData?>> {
  AsyncValue<ProfileStudioData?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<ProfileStudioData?>,
              AsyncValue<ProfileStudioData?>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ProfileStudioData?>,
                AsyncValue<ProfileStudioData?>
              >,
              AsyncValue<ProfileStudioData?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

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
    r'985f26314acdce4583b51318587c1f3436661067';

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

String _$canCreateProfileHash() => r'334d417efb64e96d8bfe735bb709fb96ab74b5c7';
