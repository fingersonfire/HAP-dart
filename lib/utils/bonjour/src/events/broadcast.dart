import 'package:hap_dart/utils/bonjour/src/events/event.dart';
import 'package:hap_dart/utils/bonjour/src/events/types/broadcast.dart';

/// A Bonsoir broadcast event.
class BonsoirBroadcastEvent extends BonsoirEvent<BonsoirBroadcastEventType> {
  /// Creates a new Bonsoir broadcast event.
  const BonsoirBroadcastEvent({
    required super.type,
    super.service,
  });
}
