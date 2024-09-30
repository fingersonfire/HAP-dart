import 'dart:io';

import 'package:hap_dart/utils/bonjour/linux.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'utils/bonjour/src/actions/broadcast.dart';
import 'utils/bonjour/src/service.dart';

class AccessoryServer {
  AccessoryServer({
    required this.deviceId,
    required this.modelName,
    this.protocolVersion,
  });

  final String deviceId;
  final String modelName;
  final String? protocolVersion;

  late AvahiBonjourBroadcast broadcast;

  Future<void> startServer() async {
    final int port = 3030;

    BonjourService service = BonjourService(
      name: modelName,
      type: '_hap._tcp',
      port: port,
      attributes: {
        // Current configuration number.
        'c#': '1',
        // Pairing Feature flags.
        'ff': '',
        // Device ID must be formatted as ”XX:XX:XX:XX:XX:XX”, where ”XX” is a hexadecimal string representing a byte. Required. This value is also used as the accessory's Pairing Identifier.
        'id': deviceId,
        // Model name of the accessory (e.g. ”Device1,1”). Required.
        'md': modelName,
        // Protocol version string ”X.Y”. Required if value is not ”1.0”.
        'pv': protocolVersion ?? '1.0',
        // Current state number. Required. This must have a value of ”1”.
        's#': '1',
        // Status flags: Required.
        'sf': '1',
        // Accessory Category Identifier. Required. Indicates the category that best describes the primary function of the accessory.
        'ci': '3',
      },
    );

    broadcast = BonjourLinux.createBroadcast(service);

    await broadcast.ready;
    broadcast.start();

    final Router router = registerRouter();

    await serve(
      router.call,
      InternetAddress.anyIPv4, // Allows external connections
      port,
    );
  }

  static Router registerRouter() {
    final Router router = Router();

    router.post('/pair-setup', (Request request) {
      print(request.toString());
      return Response(400);
    });

    router.post('/pair-verify', (Request request) {
      print(request.toString());
      return Response(400);
    });

    router.post('/pairings', (Request request) {
      print(request.toString());
      return Response(400);
    });

    router.post('/secure-message', (Request request) {
      print(request.toString());
      return Response(400);
    });

    return router;
  }
}
