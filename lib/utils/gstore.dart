import 'dart:async';

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
