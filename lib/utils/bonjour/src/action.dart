import 'dart:async';

import 'package:hap_dart/utils/bonjour/src/events/event.dart';
import 'package:hap_dart/utils/bonjour/src/service.dart';

/// This class serves as the stream source for the implementations to override.
abstract class BonsoirAction<T extends BonsoirEvent> {
  /// The event stream.
  /// Subscribe to it to receive this instance updates.
  Stream<T>? get eventStream;

  /// The ready getter, that returns when the platform is ready for the operation requested.
  /// Await this method to know when the plugin will be ready.
  Future<void> get ready;

  /// This starts the required action (eg. discovery, or broadcast).
  Future<void> start();

  /// This stops the action (eg. stops discovery or broadcast).
  Future<void> stop();

  /// This returns whether the platform is ready for this action.
  bool get isReady;

  /// This returns whether the platform has discarded this action.
  bool get isStopped;
}

/// An action that is capable of resolving a service.
mixin ServiceResolver {
  /// Allows to resolve a service.
  Future<void> resolveService(BonjourService service);
}
