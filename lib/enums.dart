enum TLVValues {
  requestType(0x00),
  method(0x00),
  username(0x01),
  identifier(0x01),
  salt(0x02),
  publicKey(0x03),
  passwordProof(0x04),
  encryptedData(0x05),
  sequenceNum(0x06),
  state(0x06),
  errorCode(0x07),
  retryDelay(0x08),
  certificate(0x09),
  proof(0x0A),
  signature(0x0A),
  permissions(0x0B),
  fragmentData(0x0C),
  fragmentLast(0x0D),
  separator(0x0FF);

  const TLVValues(this.value);

  final int value;
}

enum PairMethods {
  pairSetup(0x00),
  pairSetupWithAuth(0x01),
  pairVerify(0x02),
  addPairing(0x03),
  removePairing(0x04),
  listPairings(0x05);

  const PairMethods(this.value);

  final int value;
}

enum PairingStates {
  m1(0x01),
  m2(0x02),
  m3(0x03),
  m4(0x04),
  m5(0x05),
  m6(0x06);

  const PairingStates(this.value);

  final int value;
}

enum MimeTypes {
  tlv('application/pairing+tlv8'),
  json('application/hap+json'),
  image('image/jpeg');

  const MimeTypes(this.value);

  final String value;
}

enum Permissions {
  pairedRead('pr'),
  pairedWrite('pw'),
  events('ev'),
  additionalAuthorization('aa'),
  timedWrite('tw'),
  hidden('hd'),
  writeResponse('wr');

  const Permissions(this.value);
  final String value;

  @override
  String toString() => value;
}

enum Formats {
  bool('bool'),
  uint8('uint8'),
  uint16('uint16'),
  uint32('uint32'),
  int('int'),
  float('float'),
  string('string'),
  tlv8('tlv8'),
  data('data');

  const Formats(this.value);
  final String value;

  @override
  String toString() => value;
}

enum Units {
  celsius('celsius'),
  percentage('percentage'),
  arcdegrees('arcdegrees'),
  lux('lux'),
  seconds('seconds');

  const Units(this.value);
  final String value;

  @override
  String toString() => value;
}
