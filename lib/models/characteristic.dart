import 'package:hap_dart/enums.dart';

class CharacteristicModel<T> {
  CharacteristicModel({
    this.description,
    this.ev,
    required this.format,
    required this.iid,
    this.maxDataLen,
    this.maxLen,
    this.maxValue,
    this.minStep,
    this.minValue,
    required this.perms,
    this.pid,
    this.ttl,
    required this.type,
    this.unit,
    this.validValues,
    this.validValuesRange,
    this.value,
  });

  /// String describing the characteristic on a manufacturer-specific basis,
  /// such as an indoor versus outdoor temperature reading.
  final String? description;

  /// Boolean indicating if event notifications are enabled for this characteristic.
  final bool? ev;

  /// Format of the value.
  final Formats format;

  /// Integer assigned by the HAP Accessory Server to uniquely identify the HAP Characteristic object.
  final int iid;

  /// Maximum number of characters if the format is ”data”.
  /// If this property is omitted for ”data” formats, then the default value is 2097152.
  final int? maxDataLen;

  /// Maximum number of characters if the format is ”string”.
  /// If this property is omitted for ”string” formats, then the default value is 64.
  /// The maximum value allowed is 256.
  final int? maxLen;

  /// Maximum value for the characteristic, which is only appropriate for characteristics that have a format of ”int” or ”float”.
  final int? maxValue;

  /// Minimum step value for the characteristic, which is only appropriate for characteristics that have a format of ”int” or ”float”.
  final int? minStep;

  /// Minimum value for the characteristic, which is only appropriate for characteristics that have a format of ”int” or ”float”.
  final int? minValue;

  /// Array of permission strings describing the capabilities of the characteristic.
  final List<Permissions> perms;

  /// 64-bit unsigned integer assigned by the controller to uniquely identify the timed write transaction.
  final int? pid;

  /// TTL: Specified TTL in milliseconds the controller requests the accessory to securely execute a write command. Maximum value of this is 9007199254740991.
  final int? ttl;

  /// Defines the type of the characteristic.
  final String type;

  /// Unit of the value.
  final Units? unit;

  /// valid-values: An array of numbers where each element represents a valid value.
  final List<int>? validValues;

  /// valid-values-range: A 2 element array representing the starting value and ending value of the range of valid values.
  final List<int>? validValuesRange;

  /// The value of the characteristic, which must conform to the ”format” property.
  /// The literal value null may also be used if the characteristic has no value.
  /// This property must be present if and only if the characteristic contains the Paired Read permission.
  T? value;

  Map<String, dynamic> get map {
    Map<String, dynamic> data = {
      'description': description,
      'ev': ev,
      'format': format.toString(),
      'iid': iid,
      'maxDataLen': maxDataLen,
      'maxLen': maxLen,
      'minStep': minStep,
      'minValue': minValue,
      'perms': perms.map((p) => p.toString()),
      'pid': pid,
      'TTL': ttl,
      'type': type,
      'unit': unit.toString(),
      'valid-values': validValues,
      'valid-values-range': validValuesRange,
      'value': value,
    };

    data.removeWhere((k, v) => v == null && k != 'value');

    return data;
  }
}
