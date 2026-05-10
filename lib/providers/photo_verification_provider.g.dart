// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_verification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tracks the current step in the photo verification flow.
/// keepAlive: state persists if user navigates away and back.

@ProviderFor(CurrentPhotoVerificationStep)
const currentPhotoVerificationStepProvider =
    CurrentPhotoVerificationStepProvider._();

/// Tracks the current step in the photo verification flow.
/// keepAlive: state persists if user navigates away and back.
final class CurrentPhotoVerificationStepProvider
    extends
        $NotifierProvider<CurrentPhotoVerificationStep, PhotoVerificationStep> {
  /// Tracks the current step in the photo verification flow.
  /// keepAlive: state persists if user navigates away and back.
  const CurrentPhotoVerificationStepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPhotoVerificationStepProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPhotoVerificationStepHash();

  @$internal
  @override
  CurrentPhotoVerificationStep create() => CurrentPhotoVerificationStep();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoVerificationStep value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoVerificationStep>(value),
    );
  }
}

String _$currentPhotoVerificationStepHash() =>
    r'fefe041100b402941b3db423a73957405c85c8c7';

/// Tracks the current step in the photo verification flow.
/// keepAlive: state persists if user navigates away and back.

abstract class _$CurrentPhotoVerificationStep
    extends $Notifier<PhotoVerificationStep> {
  PhotoVerificationStep build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PhotoVerificationStep, PhotoVerificationStep>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PhotoVerificationStep, PhotoVerificationStep>,
              PhotoVerificationStep,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Holds mutable Module 5 data with typed mutators.

@ProviderFor(PhotoVerificationDataNotifier)
const photoVerificationDataProvider = PhotoVerificationDataNotifierProvider._();

/// Holds mutable Module 5 data with typed mutators.
final class PhotoVerificationDataNotifierProvider
    extends
        $NotifierProvider<
          PhotoVerificationDataNotifier,
          PhotoVerificationData
        > {
  /// Holds mutable Module 5 data with typed mutators.
  const PhotoVerificationDataNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoVerificationDataProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoVerificationDataNotifierHash();

  @$internal
  @override
  PhotoVerificationDataNotifier create() => PhotoVerificationDataNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoVerificationData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoVerificationData>(value),
    );
  }
}

String _$photoVerificationDataNotifierHash() =>
    r'd5ef132495091325159221bf4e29fec70b915f50';

/// Holds mutable Module 5 data with typed mutators.

abstract class _$PhotoVerificationDataNotifier
    extends $Notifier<PhotoVerificationData> {
  PhotoVerificationData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PhotoVerificationData, PhotoVerificationData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PhotoVerificationData, PhotoVerificationData>,
              PhotoVerificationData,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Computed: can the user proceed from the current step?
/// Mirrors canProceedOnboarding / canProceedOrientation.

@ProviderFor(canProceedPhotoVerification)
const canProceedPhotoVerificationProvider =
    CanProceedPhotoVerificationProvider._();

/// Computed: can the user proceed from the current step?
/// Mirrors canProceedOnboarding / canProceedOrientation.

final class CanProceedPhotoVerificationProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Computed: can the user proceed from the current step?
  /// Mirrors canProceedOnboarding / canProceedOrientation.
  const CanProceedPhotoVerificationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canProceedPhotoVerificationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canProceedPhotoVerificationHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canProceedPhotoVerification(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$canProceedPhotoVerificationHash() =>
    r'794441d205a975e392b7f87d17124b6f761dbf7e';
