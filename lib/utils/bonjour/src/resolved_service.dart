import 'package:hap_dart/utils/bonjour/src/service.dart';

/// Represents a resolved Bonsoir service.
class ResolvedBonsoirService extends BonjourService {
  /// The service host.
  final String? host;

  /// Creates a new resolved Bonsoir service.
  ResolvedBonsoirService({
    required super.name,
    required super.type,
    required super.port,
    super.attributes,
    required this.host,
  });

  /// Creates a new resolved Bonsoir service instance from the given JSON map.
  factory ResolvedBonsoirService.fromJson(
    Map<String, dynamic> json, {
    String prefix = 'service.',
  }) {
    return ResolvedBonsoirService.ignoreNorms(
      name: json['${prefix}name'],
      type: json['${prefix}type'],
      port: json['${prefix}port'],
      attributes: Map<String, String>.from(json['${prefix}attributes']),
      host: json['${prefix}host'],
    );
  }

  /// Creates a new resolved Bonsoir service.
  /// [name], [type] and [attributes] will not be filtered.
  ///
  /// Be aware that some network environments might not support non-conformant service names.
  ResolvedBonsoirService.ignoreNorms({
    required super.name,
    required super.type,
    required super.port,
    super.attributes,
    required this.host,
  });

  @override
  Map<String, dynamic> toJson({String prefix = 'service.'}) {
    return super.toJson(prefix: prefix)..['${prefix}host'] = host;
  }

  @override
  bool operator ==(Object other) {
    if (other is! ResolvedBonsoirService) {
      return false;
    }
    return super == other && host == other.host;
  }

  @override
  int get hashCode => super.hashCode + (host?.hashCode ?? -1);
}
