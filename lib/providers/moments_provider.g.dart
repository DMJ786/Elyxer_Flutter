// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moments_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(momentsRepository)
const momentsRepositoryProvider = MomentsRepositoryProvider._();

final class MomentsRepositoryProvider
    extends
        $FunctionalProvider<
          MomentsRepository,
          MomentsRepository,
          MomentsRepository
        >
    with $Provider<MomentsRepository> {
  const MomentsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'momentsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$momentsRepositoryHash();

  @$internal
  @override
  $ProviderElement<MomentsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MomentsRepository create(Ref ref) {
    return momentsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MomentsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MomentsRepository>(value),
    );
  }
}

String _$momentsRepositoryHash() => r'90bfb649f96e65014ca7fa8ba398207b751a822c';

@ProviderFor(MomentsFeed)
const momentsFeedProvider = MomentsFeedProvider._();

final class MomentsFeedProvider
    extends $AsyncNotifierProvider<MomentsFeed, List<Moment>> {
  const MomentsFeedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'momentsFeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$momentsFeedHash();

  @$internal
  @override
  MomentsFeed create() => MomentsFeed();
}

String _$momentsFeedHash() => r'6d5a813a0fb96c10092d1b8fe4d287dde12a5d3d';

abstract class _$MomentsFeed extends $AsyncNotifier<List<Moment>> {
  FutureOr<List<Moment>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Moment>>, List<Moment>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Moment>>, List<Moment>>,
              AsyncValue<List<Moment>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
