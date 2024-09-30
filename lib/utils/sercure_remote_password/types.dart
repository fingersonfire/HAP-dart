class Session {
  Session({required this.key, required this.proof});

  String key;
  String proof;
}

class Ephemeral {
  Ephemeral({required this.public, required this.secret});

  String public;
  String secret;
}
