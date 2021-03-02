class SeenTutorials {
  final bool podcastsTutorial;
  final bool paymentStripTutorial;

  SeenTutorials._({this.podcastsTutorial, this.paymentStripTutorial});

  SeenTutorials.initial()
      : this._(podcastsTutorial: false, paymentStripTutorial: false);

  SeenTutorials copyWith(
      {String podcastsTutorial, String paymentStripTutorial}) {
    return SeenTutorials._(
        podcastsTutorial: podcastsTutorial ?? this.podcastsTutorial,
        paymentStripTutorial:
            paymentStripTutorial ?? this.paymentStripTutorial);
  }

  SeenTutorials.fromJson(Map<String, dynamic> json)
      : podcastsTutorial = json['podcastsTutorial'] ?? false,
        paymentStripTutorial = json['paymentStripTutorial'] ?? false;

  Map<String, dynamic> toJson() => {
        'podcastsTutorial': podcastsTutorial,
        'paymentStripTutorial': paymentStripTutorial,
      };
}
