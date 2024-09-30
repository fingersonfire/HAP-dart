A HomeKit Accessory Protocol (HAP) implementation in Dart for Linux (until additional platforms are added to the mDNS support). This is intended to provide a way to compile a single binary to run on embedded systems without the need for bridges or setting up unneeded dependencies.

The following projects have been modified and added to this source code. These libraries were modified to remove dependency on the Flutter SDK to allow for a pure Dart background service that can be ran headless.

- https://github.com/leithalnajjar/tlv_decoder
- https://github.com/Skyost/Bonsoir
- https://github.com/vipycm/srp (Dart 3.0 incompatible)

This project is based on [HAP-NodeJS](https://github.com/homebridge/HAP-NodeJS).
