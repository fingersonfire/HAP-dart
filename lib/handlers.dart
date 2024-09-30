import 'dart:typed_data';

import 'package:hap_dart/enums.dart';
import 'package:hap_dart/utils/tlv.dart';
import 'package:shelf/shelf.dart';

Future<void> pairingHandler(Request request) async {
  final Stream<List<int>> stream = request.read();
  final List<int> buffer = [];

  await for (List<int> chunk in stream) {
    buffer.addAll(chunk);
  }

  final List<TLV> decoded = TLV.decode(Uint8List.fromList(buffer));
  final records = Map.fromIterable(decoded.map((d) => [d.type, d.value]));

  final sequence = records[TLVValues.sequenceNum][0];

  switch (sequence) {
    case PairingStates.m1:
      Response(
        200,
        headers: {
          'Content-Type': MimeTypes.tlv,
        },
      );
    default:
  }
}
