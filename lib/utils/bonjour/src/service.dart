import 'dart:convert';
import 'dart:typed_data';

import 'package:hap_dart/utils/bonjour/src/action.dart';
import 'package:hap_dart/utils/bonjour/src/normalizer.dart';
import 'package:hap_dart/utils/bonjour/src/resolved_service.dart';

/// Represents a broadcastable network service.
class BonjourService {
  /// The service name. Should represent what you want to advertise.
  /// This name is subject to change based on conflicts with other services advertised on the same network.
  ///
  /// According to [RFC 6763](https://datatracker.ietf.org/doc/html/rfc6763#section-4.1.1),
  /// it is a user-friendly name consisting of arbitrary Net-Unicode text.
  /// It MUST NOT contain ASCII control characters (byte values 0x00-0x1F and
  /// 0x7F) but otherwise is allowed to contain any characters,
  /// without restriction, including spaces, uppercase, lowercase,
  /// punctuation -- including dots -- accented characters, non-Roman text,
  /// and anything else that may be represented using Net-Unicode.
  final String name;

  /// The service type.
  ///
  /// Syntax :
  /// ```
  /// _ServiceType._TransportProtocolName
  /// ```
  ///
  /// Note especially :
  /// * Each part must start with an underscore, '_'.
  /// * The second part only allows '_tcp' or '_udp'.
  ///
  /// Commons examples are :
  /// ```
  /// _scanner._tcp
  /// _http._tcp
  /// _webdave._tcp
  /// _tftp._udp
  /// ```
  ///
  /// See [Understanding Zeroconf Service Types](http://wiki.ros.org/zeroconf/Tutorials/Understanding%20Zeroconf%20Service%20Types).
  ///
  /// According to [RFC 6335](https://datatracker.ietf.org/doc/html/rfc6335#section-5.1) :
  ///
  /// * Service types MUST be at least 1 character and no more than 15 characters long.
  /// * Service types MUST contain only US-ASCII [ANSI.X3.4-1986] letters 'A' - 'Z' and 'a' - 'z', digits '0' - '9', and hyphens ('-', ASCII 0x2D or decimal 45).
  /// * Service types MUST contain at least one letter ('A' - 'Z' or 'a' - 'z').
  /// * Service types MUST NOT begin or end with a hyphen.
  /// * Hyphens MUST NOT be adjacent to other hyphens.
  final String type;

  /// The service port.
  /// Your service should be reachable at the given port using the protocol specified in [type].
  final int port;

  /// The service attributes.
  /// Will be stored in a TXT record.
  ///
  /// According to [RFC 6763](https://datatracker.ietf.org/doc/html/rfc6763#section-6) :
  ///
  /// * The characters of a key MUST be printable US-ASCII values (0x20-0x7E) excluding '=' (0x3D).
  /// * The key SHOULD be no more than nine characters long.
  /// * The key MUST be at least one character.
  /// * Each constituent string of a DNS TXT record is limited to 255 bytes.
  final Map<String, String> attributes;

  /// Creates a new Bonsoir service instance.
  /// By default, Bonsoir will normalize your [name], [type] and [attributes] in order to conform to RFC 6335.
  /// You can ignore this behavior with the [BonsoirService.ignoreNorms] constructor.
  BonjourService({
    required String name,
    required String type,
    required this.port,
    Map<String, String> attributes = const {},
  })  : name = BonsoirServiceNormalizer.normalizeName(name),
        type = BonsoirServiceNormalizer.normalizeType(type),
        attributes = BonsoirServiceNormalizer.normalizeAttributes(attributes);

  /// Creates a new Bonsoir service instance ignoring the norms.
  /// [name], [type] and [attributes] will not be filtered.
  ///
  /// Be aware that some network environments might not support non-conformant service names.
  const BonjourService.ignoreNorms({
    required this.name,
    required this.type,
    required this.port,
    this.attributes = const {},
  });

  /// Creates a new Bonsoir service instance from the given JSON map.
  factory BonjourService.fromJson(
    Map<String, dynamic> json, {
    String prefix = 'service.',
  }) {
    if (json['${prefix}host'] != null) {
      return ResolvedBonsoirService.fromJson(json, prefix: prefix);
    }
    return BonjourService.ignoreNorms(
      name: json['${prefix}name'],
      type: json['${prefix}type'],
      port: json['${prefix}port'],
      attributes: Map<String, String>.from(json['${prefix}attributes']),
    );
  }

  /// Converts this JSON service to a JSON map.
  Map<String, dynamic> toJson({String prefix = 'service.'}) {
    return {
      '${prefix}name': name,
      '${prefix}type': type,
      '${prefix}port': port,
      '${prefix}attributes': attributes,
    };
  }

  /// Tries to resolve this service.
  Future<void> resolve(ServiceResolver resolver) {
    return resolver.resolveService(this);
  }

  /// Copies this service instance with the given parameters.
  BonjourService copyWith({
    String? name,
    String? type,
    int? port,
    String? host,
    Map<String, String>? attributes,
  }) {
    if (host != null || this is ResolvedBonsoirService) {
      return ResolvedBonsoirService.ignoreNorms(
        name: name ?? this.name,
        type: type ?? this.type,
        port: port ?? this.port,
        host: host ??
            (this is ResolvedBonsoirService
                ? (this as ResolvedBonsoirService).host
                : null),
        attributes: attributes ?? this.attributes,
      );
    } else {
      return BonjourService.ignoreNorms(
        name: name ?? this.name,
        type: type ?? this.type,
        port: port ?? this.port,
        attributes: attributes ?? this.attributes,
      );
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is! BonjourService) {
      return false;
    }
    return identical(this, other) ||
        (name == other.name &&
            type == other.type &&
            port == other.port &&
            json.encode(attributes) == json.encode(other.attributes));
  }

  @override
  int get hashCode => name.hashCode + type.hashCode + port;

  @override
  String toString() => jsonEncode(toJson());
}

/// Various useful functions for services.
extension BonjourServiceUtils on BonjourService {
  /// Returns a string describing the current service.
  String get description => jsonEncode(toJson(prefix: ''));

  /// Returns the TXT record of the current service.
  List<Uint8List> get txtRecord => attributes.entries
      .map((attribute) => utf8.encode('${attribute.key}=${attribute.value}'))
      .toList();

  /// Returns the fully qualified domain name of the current service.
  String get fqdn => '$name.$type.local';
}
