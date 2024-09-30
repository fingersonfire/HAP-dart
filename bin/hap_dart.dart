import 'package:hap_dart/server.dart';

Future<void> main(List<String> arguments) async {
  final AccessoryServer accessory = AccessoryServer(
    deviceId: '1A:2B:3C:4D:5E:FF',
    modelName: 'Deo Fan',
  );

  await accessory.startServer();
}
