// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selfie_validator_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(selfieValidatorService)
const selfieValidatorServiceProvider = SelfieValidatorServiceProvider._();

final class SelfieValidatorServiceProvider
    extends
        $FunctionalProvider<
          SelfieValidatorService,
          SelfieValidatorService,
          SelfieValidatorService
        >
    with $Provider<SelfieValidatorService> {
  const SelfieValidatorServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selfieValidatorServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selfieValidatorServiceHash();

  @$internal
  @override
  $ProviderElement<SelfieValidatorService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SelfieValidatorService create(Ref ref) {
    return selfieValidatorService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SelfieValidatorService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SelfieValidatorService>(value),
    );
  }
}

String _$selfieValidatorServiceHash() =>
    r'c3e3360467f8973001dd2d8b74e0aa1224757631';
