// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The active repository impl. Mock today (no backend); becomes the BFF-backed
/// impl once AWS provisioning (#40) lands.

@ProviderFor(discoveryRepository)
const discoveryRepositoryProvider = DiscoveryRepositoryProvider._();

/// The active repository impl. Mock today (no backend); becomes the BFF-backed
/// impl once AWS provisioning (#40) lands.

final class DiscoveryRepositoryProvider
    extends
        $FunctionalProvider<
          DiscoveryRepository,
          DiscoveryRepository,
          DiscoveryRepository
        >
    with $Provider<DiscoveryRepository> {
  /// The active repository impl. Mock today (no backend); becomes the BFF-backed
  /// impl once AWS provisioning (#40) lands.
  const DiscoveryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discoveryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoveryRepositoryHash();

  @$internal
  @override
  $ProviderElement<DiscoveryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DiscoveryRepository create(Ref ref) {
    return discoveryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscoveryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscoveryRepository>(value),
    );
  }
}

String _$discoveryRepositoryHash() =>
    r'f6ef5338c315a007c016615e90a685c170ef0021';

/// Drives the browse deck and the actions taken on the current profile.
///
/// Vibe does NOT advance the deck (a user can vibe several sections of one
/// profile); Invite / Pass / Block / Report do.

@ProviderFor(DiscoveryDeck)
const discoveryDeckProvider = DiscoveryDeckProvider._();

/// Drives the browse deck and the actions taken on the current profile.
///
/// Vibe does NOT advance the deck (a user can vibe several sections of one
/// profile); Invite / Pass / Block / Report do.
final class DiscoveryDeckProvider
    extends $AsyncNotifierProvider<DiscoveryDeck, DiscoveryDeckState> {
  /// Drives the browse deck and the actions taken on the current profile.
  ///
  /// Vibe does NOT advance the deck (a user can vibe several sections of one
  /// profile); Invite / Pass / Block / Report do.
  const DiscoveryDeckProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discoveryDeckProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoveryDeckHash();

  @$internal
  @override
  DiscoveryDeck create() => DiscoveryDeck();
}

String _$discoveryDeckHash() => r'5f3b91daf57dcef458212f63ee9c782c07b9aec8';

/// Drives the browse deck and the actions taken on the current profile.
///
/// Vibe does NOT advance the deck (a user can vibe several sections of one
/// profile); Invite / Pass / Block / Report do.

abstract class _$DiscoveryDeck extends $AsyncNotifier<DiscoveryDeckState> {
  FutureOr<DiscoveryDeckState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<DiscoveryDeckState>, DiscoveryDeckState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DiscoveryDeckState>, DiscoveryDeckState>,
              AsyncValue<DiscoveryDeckState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
