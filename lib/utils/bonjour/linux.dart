library bonsoir_linux;

import 'package:hap_dart/utils/bonjour/src/actions/broadcast.dart';
import 'package:hap_dart/utils/bonjour/src/service.dart';

class BonjourLinux {
  /// The Avahi package name.
  static const String avahi = 'org.freedesktop.Avahi';

  static AvahiBonjourBroadcast createBroadcast(BonjourService service) {
    return AvahiBonjourBroadcast(service: service);
  }
}
