// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photos_verification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tracks the current step in the photos verification flow.
/// keepAlive: state persists if user navigates away and back.

@ProviderFor(CurrentPhotosVerificationStep)
const currentPhotosVerificationStepProvider =
    CurrentPhotosVerificationStepProvider._();

/// Tracks the current step in the photos verification flow.
/// keepAlive: state persists if user navigates away and back.
final class CurrentPhotosVerificationStepProvider
    extends
        $NotifierProvider<
          CurrentPhotosVerificationStep,
          PhotosVerificationStep
        > {
  /// Tracks the current step in the photos verification flow.
  /// keepAlive: state persists if user navigates away and back.
  const CurrentPhotosVerificationStepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPhotosVerificationStepProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPhotosVerificationStepHash();

  @$internal
  @override
  CurrentPhotosVerificationStep create() => CurrentPhotosVerificationStep();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotosVerificationStep value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotosVerificationStep>(value),
    );
  }
}

String _$currentPhotosVerificationStepHash() =>
    r'9f1a4573b163e3bd5b89e7799a528cce4d407493';

/// Tracks the current step in the photos verification flow.
/// keepAlive: state persists if user navigates away and back.

abstract class _$CurrentPhotosVerificationStep
    extends $Notifier<PhotosVerificationStep> {
  PhotosVerificationStep build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<PhotosVerificationStep, PhotosVerificationStep>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PhotosVerificationStep, PhotosVerificationStep>,
              PhotosVerificationStep,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Holds mutable Module 5 data with typed mutators.

@ProviderFor(PhotosVerificationDataNotifier)
const photosVerificationDataProvider =
    PhotosVerificationDataNotifierProvider._();

/// Holds mutable Module 5 data with typed mutators.
final class PhotosVerificationDataNotifierProvider
    extends
        $NotifierProvider<
          PhotosVerificationDataNotifier,
          PhotosVerificationData
        > {
  /// Holds mutable Module 5 data with typed mutators.
  const PhotosVerificationDataNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photosVerificationDataProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photosVerificationDataNotifierHash();

  @$internal
  @override
  PhotosVerificationDataNotifier create() => PhotosVerificationDataNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotosVerificationData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotosVerificationData>(value),
    );
  }
}

String _$photosVerificationDataNotifierHash() =>
    r'07fa1e12746b2b8c2cb16acc0b84dff6527df22b';

/// Holds mutable Module 5 data with typed mutators.

abstract class _$PhotosVerificationDataNotifier
    extends $Notifier<PhotosVerificationData> {
  PhotosVerificationData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<PhotosVerificationData, PhotosVerificationData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PhotosVerificationData, PhotosVerificationData>,
              PhotosVerificationData,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Computed: can the user proceed from the current step?
/// Mirrors canProceedOnboarding / canProceedOrientation.

@ProviderFor(canProceedPhotosVerification)
const canProceedPhotosVerificationProvider =
    CanProceedPhotosVerificationProvider._();

/// Computed: can the user proceed from the current step?
/// Mirrors canProceedOnboarding / canProceedOrientation.

final class CanProceedPhotosVerificationProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Computed: can the user proceed from the current step?
  /// Mirrors canProceedOnboarding / canProceedOrientation.
  const CanProceedPhotosVerificationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canProceedPhotosVerificationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canProceedPhotosVerificationHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canProceedPhotosVerification(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$canProceedPhotosVerificationHash() =>
    r'08f527402a7ad65f9d2f422380a3bbf69ef49c5b';
