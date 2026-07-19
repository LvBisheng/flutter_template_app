// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson6_annotation.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 【函数式 Provider】
/// 运行 build_runner 后会生成 annotationTitleProvider。

@ProviderFor(annotationTitle)
const annotationTitleProvider = AnnotationTitleProvider._();

/// 【函数式 Provider】
/// 运行 build_runner 后会生成 annotationTitleProvider。

final class AnnotationTitleProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// 【函数式 Provider】
  /// 运行 build_runner 后会生成 annotationTitleProvider。
  const AnnotationTitleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'annotationTitleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$annotationTitleHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return annotationTitle(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$annotationTitleHash() => r'1bcba20bbfb3ac2f4a6ca33304762eee4a4fb0c0';

/// 【Family Provider】
/// 函数带参数时，生成的 Provider 会自动变成 family。

@ProviderFor(annotationGreeting)
const annotationGreetingProvider = AnnotationGreetingFamily._();

/// 【Family Provider】
/// 函数带参数时，生成的 Provider 会自动变成 family。

final class AnnotationGreetingProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// 【Family Provider】
  /// 函数带参数时，生成的 Provider 会自动变成 family。
  const AnnotationGreetingProvider._({
    required AnnotationGreetingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'annotationGreetingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$annotationGreetingHash();

  @override
  String toString() {
    return r'annotationGreetingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as String;
    return annotationGreeting(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AnnotationGreetingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$annotationGreetingHash() =>
    r'dc78b0dab9dddfcf5c1ebebab697c57fa3be81ec';

/// 【Family Provider】
/// 函数带参数时，生成的 Provider 会自动变成 family。

final class AnnotationGreetingFamily extends $Family
    with $FunctionalFamilyOverride<String, String> {
  const AnnotationGreetingFamily._()
    : super(
        retry: null,
        name: r'annotationGreetingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 【Family Provider】
  /// 函数带参数时，生成的 Provider 会自动变成 family。

  AnnotationGreetingProvider call(String name) =>
      AnnotationGreetingProvider._(argument: name, from: this);

  @override
  String toString() => r'annotationGreetingProvider';
}

/// 【NotifierProvider】
/// 运行 build_runner 后会生成 annotationCounterProvider。

@ProviderFor(AnnotationCounter)
const annotationCounterProvider = AnnotationCounterProvider._();

/// 【NotifierProvider】
/// 运行 build_runner 后会生成 annotationCounterProvider。
final class AnnotationCounterProvider
    extends $NotifierProvider<AnnotationCounter, int> {
  /// 【NotifierProvider】
  /// 运行 build_runner 后会生成 annotationCounterProvider。
  const AnnotationCounterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'annotationCounterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$annotationCounterHash();

  @$internal
  @override
  AnnotationCounter create() => AnnotationCounter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$annotationCounterHash() => r'3f90feff2632ae1da31db79806d844d6c5177c88';

/// 【NotifierProvider】
/// 运行 build_runner 后会生成 annotationCounterProvider。

abstract class _$AnnotationCounter extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
