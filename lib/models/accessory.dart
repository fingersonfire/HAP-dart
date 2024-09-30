import 'package:hap_dart/models/service.dart';

class AccessoryModel {
  AccessoryModel({
    required this.aid,
    required this.services,
  });

  /// Integer assigned by the HAP Accessory Server to uniquely identify the HAP Accessory object
  final String aid;

  /// Array of Service objects. Must not be empty. The maximum number of services must not exceed 100.
  final List<ServiceModel> services;

  Map<String, dynamic> get map {
    return {
      'aid': aid,
      'services': services.map((s) => s.map),
    };
  }
}
