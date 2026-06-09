// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_picker_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(photoPickerService)
const photoPickerServiceProvider = PhotoPickerServiceProvider._();

final class PhotoPickerServiceProvider
    extends
        $FunctionalProvider<
          PhotoPickerService,
          PhotoPickerService,
          PhotoPickerService
        >
    with $Provider<PhotoPickerService> {
  const PhotoPickerServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoPickerServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoPickerServiceHash();

  @$internal
  @override
  $ProviderElement<PhotoPickerService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PhotoPickerService create(Ref ref) {
    return photoPickerService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoPickerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoPickerService>(value),
    );
  }
}

String _$photoPickerServiceHash() =>
    r'9658adbb2c1fa3fd937db6561ba4871a85e5d185';
