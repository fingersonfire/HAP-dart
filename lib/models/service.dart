import 'package:hap_dart/models/characteristic.dart';

class ServiceModel {
  ServiceModel({
    required this.characteristics,
    required this.hidden,
    required this.iid,
    required this.linked,
    required this.primary,
    required this.type,
  });

  /// Array of Characteristic objects. Must not be empty. The maximum number of
  /// characteristics must not exceed 100, and each characteristic in the
  /// array must have a unique type.
  final List<CharacteristicModel> characteristics;

  /// When set to True, this service is not visible to user.
  final bool hidden;

  /// Integer assigned by the HAP Accessory Server to uniquely identify the HAP Service object
  final int iid;

  /// An array of numbers containing the instance ids of the services that this service links to.
  final List<int> linked;

  /// When set to True, this is the primary service on the accessory.
  final bool primary;

  /// Defines the type of the service
  final String type;

  Map<String, dynamic> get map {
    return {
      'characteristics': characteristics.map((c) => c.map),
      'hidden': hidden,
      'iid': iid,
      'linked': linked,
      'primary': primary,
      'type': type,
    };
  }
}
