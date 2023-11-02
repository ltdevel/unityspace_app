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
  final Widget Function(BuildContext context) builder;
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
      WStoreStatus.init => builder(context),
      WStoreStatus.loading => builderLoading?.call(context) ?? builder(context),
      WStoreStatus.loaded => builderLoaded?.call(context) ?? builder(context),
      WStoreStatus.error => builderError?.call(context) ?? builder(context),
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
