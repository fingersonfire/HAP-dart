import 'dart:async';

import 'package:dbus/dbus.dart';
import 'package:hap_dart/utils/bonjour/src/action.dart';
import 'package:hap_dart/utils/bonjour/src/error.dart';
import 'package:hap_dart/utils/bonjour/src/events/event.dart';
import 'package:meta/meta.dart';

/// Base implementation for [BonsoirAction] on Linux.
abstract class AvahiBonsoirAction<T extends BonsoirEvent>
    extends BonsoirAction<T> {
  /// A string describing the current action.
  final String action;

  /// The log messages map.
  final Map<String, String> logMessages;

  /// The DBus client instance.
  final DBusClient busClient;

  /// The current stream controller instance.
  final StreamController<T> _controller = StreamController<T>();

  /// Contains the subscriptions instances.
  final List<StreamSubscription> _subscriptions = [];

  /// Whether the action has been stopped.
  bool _isStopped = false;

  /// Creates a new Avahi bonsoir action instance.
  AvahiBonsoirAction({
    required this.action,
    required this.logMessages,
    DBusClient? busClient,
  }) : busClient = busClient ?? DBusClient.system();

  @override
  Stream<T>? get eventStream => _controller.stream;

  @override
  bool get isReady => !isStopped;

  @override
  bool get isStopped => _isStopped;

  /// Triggered when an event occurs.
  void onEvent(T event, {String? message, List parameters = const []}) {
    message ??= logMessages[event.type];
    _controller.add(event);
  }

  /// Triggered when an error occurs.
  void onError({String? message, List parameters = const [], Object? details}) {
    message ??= logMessages['${action}Error']!;
    message = _format(message, parameters);
    _controller.addError(BonsoirLinuxError(message, details));
  }

  @override
  @mustCallSuper
  Future<void> start() async {
    assert(isReady,
        '''AvahiBonsoirDiscovery should be ready to start in order to call this method.
You must wait until this instance is ready by calling "await AvahiBonsoirDiscovery.ready".
If you have previously called "AvahiBonsoirDiscovery.stop()" on this instance, you have to create a new instance of this class.''');
  }

  @override
  @mustCallSuper
  Future<void> stop() async {
    cancelSubscriptions();
    _controller.close();
    _isStopped = true;
  }

  /// Registers a subscription.
  void registerSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
    subscription.onDone(() => _subscriptions.remove(subscription));
  }

  /// Cancels all subscriptions.
  void cancelSubscriptions() {
    for (StreamSubscription subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  /// Formats a given [message] with the [parameters].
  String _format(String message, List parameters) {
    String result = message;
    for (dynamic parameter in parameters) {
      result = result.replaceFirst('%s', parameter.toString());
    }
    return result;
  }
}
