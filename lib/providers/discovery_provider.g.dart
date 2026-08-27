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

String _$discoveryDeckHash() => r'143b5fca44887e452872a8688ca537bc8421ee82';

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

/// The applied Discovery filters. keepAlive so a filter survives leaving and
/// returning to the Discover tab; the deck provider watches this.

@ProviderFor(DiscoveryFilterState)
const discoveryFilterStateProvider = DiscoveryFilterStateProvider._();

/// The applied Discovery filters. keepAlive so a filter survives leaving and
/// returning to the Discover tab; the deck provider watches this.
final class DiscoveryFilterStateProvider
    extends $NotifierProvider<DiscoveryFilterState, DiscoveryFilters> {
  /// The applied Discovery filters. keepAlive so a filter survives leaving and
  /// returning to the Discover tab; the deck provider watches this.
  const DiscoveryFilterStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discoveryFilterStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoveryFilterStateHash();

  @$internal
  @override
  DiscoveryFilterState create() => DiscoveryFilterState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscoveryFilters value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscoveryFilters>(value),
    );
  }
}

String _$discoveryFilterStateHash() =>
    r'dc72a31e0aac68c43dcdc788e6433fd6f217478e';

/// The applied Discovery filters. keepAlive so a filter survives leaving and
/// returning to the Discover tab; the deck provider watches this.

abstract class _$DiscoveryFilterState extends $Notifier<DiscoveryFilters> {
  DiscoveryFilters build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DiscoveryFilters, DiscoveryFilters>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiscoveryFilters, DiscoveryFilters>,
              DiscoveryFilters,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// The distinct intent values across the deck — the filter sheet's options.

@ProviderFor(discoveryIntentOptions)
const discoveryIntentOptionsProvider = DiscoveryIntentOptionsProvider._();

/// The distinct intent values across the deck — the filter sheet's options.

final class DiscoveryIntentOptionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// The distinct intent values across the deck — the filter sheet's options.
  const DiscoveryIntentOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discoveryIntentOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoveryIntentOptionsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return discoveryIntentOptions(ref);
  }
}

String _$discoveryIntentOptionsHash() =>
    r'37ef9f12b6c96ad77f776c90e406ea6ed10e9f40';
