// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interests_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(interestsRepository)
const interestsRepositoryProvider = InterestsRepositoryProvider._();

final class InterestsRepositoryProvider
    extends
        $FunctionalProvider<
          InterestsRepository,
          InterestsRepository,
          InterestsRepository
        >
    with $Provider<InterestsRepository> {
  const InterestsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interestsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interestsRepositoryHash();

  @$internal
  @override
  $ProviderElement<InterestsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InterestsRepository create(Ref ref) {
    return interestsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InterestsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InterestsRepository>(value),
    );
  }
}

String _$interestsRepositoryHash() =>
    r'92fcbb524effe0b864fed0687e076afe2cb93a9c';

@ProviderFor(Interests)
const interestsProvider = InterestsProvider._();

final class InterestsProvider
    extends $AsyncNotifierProvider<Interests, InterestsState> {
  const InterestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interestsHash();

  @$internal
  @override
  Interests create() => Interests();
}

String _$interestsHash() => r'7364f418a77dde51ff836c0710322abcce9f683a';

abstract class _$Interests extends $AsyncNotifier<InterestsState> {
  FutureOr<InterestsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<InterestsState>, InterestsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<InterestsState>, InterestsState>,
              AsyncValue<InterestsState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
