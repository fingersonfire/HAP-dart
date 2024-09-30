import 'dart:async';

import 'package:dbus/dbus.dart';
import 'package:hap_dart/utils/bonjour/linux.dart';
import 'package:hap_dart/utils/bonjour/src/actions/action.dart';
import 'package:hap_dart/utils/bonjour/src/avahi/constants.dart';
import 'package:hap_dart/utils/bonjour/src/avahi/entry_group.dart';
import 'package:hap_dart/utils/bonjour/src/avahi/server.dart';
import 'package:hap_dart/utils/bonjour/src/events/broadcast.dart';
import 'package:hap_dart/utils/bonjour/src/events/types/broadcast.dart';
import 'package:hap_dart/utils/bonjour/src/resolved_service.dart';
import 'package:hap_dart/utils/bonjour/src/service.dart';

/// Broadcasts a given [service] on the network.
class AvahiBonjourBroadcast extends AvahiBonsoirAction<BonsoirBroadcastEvent> {
  /// The service to broadcast.
  BonjourService service;

  /// The Avahi server instance.
  AvahiServer? _server;

  /// The Avahi entry group.
  AvahiEntryGroup? _entryGroup;

  /// Creates a new Avahi Bonsoir broadcast instance.
  AvahiBonjourBroadcast({
    required this.service,
  }) : super(
          action: 'broadcast',
          logMessages: BonsoirPlatformInterfaceLogMessages.broadcastMessages,
        );

  @override
  Future<void> get ready async {
    if (_entryGroup == null) {
      _server = AvahiServer(busClient, BonjourLinux.avahi, DBusObjectPath('/'));
      _entryGroup = AvahiEntryGroup(busClient, BonjourLinux.avahi,
          DBusObjectPath(await _server!.callEntryGroupNew()));
      await _sendServiceToAvahi();
    }
  }

  @override
  Future<void> start() async {
    await super.start();
    registerSubscription(_entryGroup!.stateChanged.listen(_onEntryGroupEvent));
    await _entryGroup!.callCommit();
  }

  /// Triggered when an entry group event occurs.
  Future<void> _onEntryGroupEvent(AvahiEntryGroupStateChanged event) async {
    switch (event.state.toAvahiEntryGroupState()) {
      case AvahiEntryGroupState.AVAHI_ENTRY_GROUP_UNCOMMITTED:
      case AvahiEntryGroupState.AVAHI_ENTRY_GROUP_REGISTERING:
        break;
      case AvahiEntryGroupState.AVAHI_ENTRY_GROUP_ESTABLISHED:
        onEvent(
          BonsoirBroadcastEvent(
              type: BonsoirBroadcastEventType.broadcastStarted,
              service: service),
          parameters: [service.description],
        );
        break;
      case AvahiEntryGroupState.AVAHI_ENTRY_GROUP_COLLISION:
        String newName =
            await _server!.callGetAlternativeServiceName(service.name);
        await _entryGroup!.callReset();
        String name = service.name;
        service = service.copyWith(name: newName);
        onEvent(
          BonsoirBroadcastEvent(
              type: BonsoirBroadcastEventType.broadcastNameAlreadyExists,
              service: service),
          parameters: [service.description, name],
        );
        _sendServiceToAvahi();
        break;
      case AvahiEntryGroupState.AVAHI_ENTRY_GROUP_FAILURE:
        onError(details: event.error);
        break;
      default:
        onEvent(
          const BonsoirBroadcastEvent(type: BonsoirBroadcastEventType.unknown),
          message:
              'Bonsoir broadcast has received a unknown state with value ${event.state}.',
        );
    }
  }

  /// Sends the current service to Avahi.
  Future<void> _sendServiceToAvahi() async {
    String host = '';
    if (service is ResolvedBonsoirService) {
      host = (service as ResolvedBonsoirService).host ?? '';
    }
    await _entryGroup!.callAddService(
      interface: AvahiIfIndexUnspecified,
      protocol: AvahiProtocolUnspecified,
      flags: 0,
      name: service.name,
      type: service.type,
      domain: '',
      host: host,
      port: service.port,
      txt: service.txtRecord,
    );
  }

  @override
  Future<void> stop() async {
    cancelSubscriptions();
    await _entryGroup!.callFree();
    onEvent(
      const BonsoirBroadcastEvent(
          type: BonsoirBroadcastEventType.broadcastStopped),
      parameters: [service.description],
    );
    super.stop();
  }
}

/// Contains a set of messages that can be logged by the native platform interface.
/// This ensure a consistency across platforms.
class BonsoirPlatformInterfaceLogMessages {
  /// Contains all broadcast messages.
  static final Map<String, String> broadcastMessages = {
    BonsoirBroadcastEventType.broadcastStarted.id:
        'Bonsoir service broadcast started : %s.',
    BonsoirBroadcastEventType.broadcastNameAlreadyExists.id:
        'Trying to broadcast a service with a name that already exists : %s (old name was %s).',
    BonsoirBroadcastEventType.broadcastStopped.id:
        'Bonsoir service broadcast stopped : %s.',
    'broadcastInitialized': 'Bonsoir service broadcast initialized : %s.',
    'broadcastError': 'Bonsoir service failed to broadcast : %s (error : %s).',
  };
}
