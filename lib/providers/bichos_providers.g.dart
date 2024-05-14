// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bichos_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$animalsPagingHash() => r'b3c0949b8cfe90f504c90a339458d2ab606f989b';

/// See also [animalsPaging].
@ProviderFor(animalsPaging)
final animalsPagingProvider =
    AutoDisposeProvider<PagingController<int, Animal>>.internal(
  animalsPaging,
  name: r'animalsPagingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$animalsPagingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AnimalsPagingRef
    = AutoDisposeProviderRef<PagingController<int, Animal>>;
String _$animalsListHash() => r'8d65b639771671535e4efc02a3c378e7bb29a125';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [animalsList].
@ProviderFor(animalsList)
const animalsListProvider = AnimalsListFamily();

/// See also [animalsList].
class AnimalsListFamily extends Family<AsyncValue<void>> {
  /// See also [animalsList].
  const AnimalsListFamily();

  /// See also [animalsList].
  AnimalsListProvider call(
    int pageKey,
  ) {
    return AnimalsListProvider(
      pageKey,
    );
  }

  @override
  AnimalsListProvider getProviderOverride(
    covariant AnimalsListProvider provider,
  ) {
    return call(
      provider.pageKey,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'animalsListProvider';
}

/// See also [animalsList].
class AnimalsListProvider extends AutoDisposeFutureProvider<void> {
  /// See also [animalsList].
  AnimalsListProvider(
    int pageKey,
  ) : this._internal(
          (ref) => animalsList(
            ref as AnimalsListRef,
            pageKey,
          ),
          from: animalsListProvider,
          name: r'animalsListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$animalsListHash,
          dependencies: AnimalsListFamily._dependencies,
          allTransitiveDependencies:
              AnimalsListFamily._allTransitiveDependencies,
          pageKey: pageKey,
        );

  AnimalsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageKey,
  }) : super.internal();

  final int pageKey;

  @override
  Override overrideWith(
    FutureOr<void> Function(AnimalsListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AnimalsListProvider._internal(
        (ref) => create(ref as AnimalsListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pageKey: pageKey,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _AnimalsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AnimalsListProvider && other.pageKey == pageKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AnimalsListRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `pageKey` of this provider.
  int get pageKey;
}

class _AnimalsListProviderElement extends AutoDisposeFutureProviderElement<void>
    with AnimalsListRef {
  _AnimalsListProviderElement(super.provider);

  @override
  int get pageKey => (origin as AnimalsListProvider).pageKey;
}

String _$fileListHash() => r'b16aff264fe790d81dd8454e04d74173295c8f59';

/// See also [fileList].
@ProviderFor(fileList)
final fileListProvider = AutoDisposeFutureProvider<List<String>>.internal(
  fileList,
  name: r'fileListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$fileListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FileListRef = AutoDisposeFutureProviderRef<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
