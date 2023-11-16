import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wstore/wstore.dart';

enum WStoreStatus {
  init, // По умолчанию
  loading, // Загружается
  loaded, // Загружено
  error, // Ошибка
}

class WStoreStatusBuilder<T extends WStore> extends StatelessWidget {
  final WStoreStatus Function(T store) watch;
  final T? store;
  final Widget Function(BuildContext context, WStoreStatus status) builder;
  final Widget Function(BuildContext context)? builderInit;
  final Widget Function(BuildContext context)? builderLoading;
  final Widget Function(BuildContext context)? builderLoaded;
  final Widget Function(BuildContext context)? builderError;
  final void Function(BuildContext context)? onStatusInit;
  final void Function(BuildContext context)? onStatusLoading;
  final void Function(BuildContext context)? onStatusLoaded;
  final void Function(BuildContext context)? onStatusError;

  const WStoreStatusBuilder({
    super.key,
    required this.watch,
    this.store,
    required this.builder,
    this.builderInit,
    this.builderLoading,
    this.builderLoaded,
    this.builderError,
    this.onStatusInit,
    this.onStatusLoading,
    this.onStatusLoaded,
    this.onStatusError,
  });

  @override
  Widget build(BuildContext context) {
    final store = this.store ?? WStoreWidget.store<T>(context);
    return WStoreConsumer(
      builder: (context, _) => _statusBuilder(context, watch(store)),
      onChange: (context) => _statusChange(context, watch(store)),
      watch: () => [watch(store)],
      store: store,
    );
  }

  Widget _statusBuilder(BuildContext context, final WStoreStatus status) {
    return switch (status) {
      WStoreStatus.init =>
        builderInit?.call(context) ?? builder(context, status),
      WStoreStatus.loading =>
        builderLoading?.call(context) ?? builder(context, status),
      WStoreStatus.loaded =>
        builderLoaded?.call(context) ?? builder(context, status),
      WStoreStatus.error =>
        builderError?.call(context) ?? builder(context, status),
    };
  }

  void _statusChange(BuildContext context, final WStoreStatus status) {
    switch (status) {
      case WStoreStatus.init:
        onStatusInit?.call(context);
      case WStoreStatus.loading:
        onStatusLoading?.call(context);
      case WStoreStatus.loaded:
        onStatusLoaded?.call(context);
      case WStoreStatus.error:
        onStatusError?.call(context);
    }
  }
}

class GStore {
  late final StreamController<bool> _controllerObservers;
  late final Stream<bool> _streamObservers;

  GStore() {
    _controllerObservers = StreamController.broadcast();
    _streamObservers = _controllerObservers.stream;
  }

  void setStore(void Function() fn) {
    final Object? result = fn() as dynamic;
    assert(
        () {
      if (result is Future) return false;
      return true;
    }(),
    'setStore() callback argument returned a Future. '
        'Maybe it is marked as "async"? Instead of performing asynchronous '
        'work inside a call to setStore(), first execute the work '
        '(without updating the store), and then synchronously '
        'update the store inside a call to setStore().',
    );
    // Notifying watchers that the store has been updated
    _controllerObservers.add(true);
  }

  Stream<T> observe<T>(T Function() getValue) async*{
    T value = getValue();
    yield value;
    await for (final _ in _streamObservers) {
      T newValue = getValue();
      if (newValue != value) {
        value = newValue;
        yield value;
      }
    }
  }
}

extension WStoreComputedGStore on WStore {
  @protected
  V computedFromStore<T extends GStore, V>({
    required V Function(T) getValue,
    required T store,
    required String keyName,
  }) {
    // ignore: invalid_use_of_protected_member
    return computedFromStream<V>(
      stream: store.observe(() => getValue(store)),
      initialData: getValue(store),
      keyName: keyName,
    );
  }
}
