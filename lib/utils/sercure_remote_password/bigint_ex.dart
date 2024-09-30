extension BigIntEx on BigInt {
  String toHex({bool evenLen = true}) {
    var hexStr = toRadixString(16);
    if (evenLen && !hexStr.length.isEven) {
      hexStr = '0$hexStr';
    }
    return hexStr;
  }
}
