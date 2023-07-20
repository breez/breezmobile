class NostrSettings {
  final bool showSnort;

  NostrSettings({this.showSnort = true});

  NostrSettings.start() : this(showSnort: true);

  NostrSettings copyWith({
    bool showSnort,
  }) {
    return NostrSettings(
      showSnort: showSnort ?? this.showSnort,
    );
  }

  NostrSettings.fromJson(Map<String, dynamic> json)
      : this(showSnort: json["showSnort"] ?? true);

  Map<String, dynamic> toJson() => {
        "showSnort": showSnort,
      };
}
