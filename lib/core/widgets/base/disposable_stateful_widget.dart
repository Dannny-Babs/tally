import 'package:flutter/material.dart';
import 'dart:async';

abstract class DisposableStatefulWidget extends StatefulWidget {
  const DisposableStatefulWidget({super.key});
}

abstract class DisposableState<T extends DisposableStatefulWidget> extends State<T> {
  final List<ChangeNotifier> _notifiers = [];
  final List<StreamSubscription> _subscriptions = [];
  final List<Timer> _timers = [];

  @protected
  void registerNotifier(ChangeNotifier notifier) {
    _notifiers.add(notifier);
  }

  @protected
  void registerSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  @protected
  void registerTimer(Timer timer) {
    _timers.add(timer);
  }

  @override
  void dispose() {
    for (final notifier in _notifiers) {
      notifier.dispose();
    }
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    for (final timer in _timers) {
      timer.cancel();
    }
    super.dispose();
  }
} 