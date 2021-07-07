class SeenTutorials {
  final bool paymentStripTutorial;

  SeenTutorials._({this.paymentStripTutorial});

  SeenTutorials.initial() : this._(paymentStripTutorial: false);

  SeenTutorials copyWith({bool paymentStripTutorial}) {
    return SeenTutorials._(
        paymentStripTutorial:
            paymentStripTutorial ?? this.paymentStripTutorial);
  }

  SeenTutorials.fromJson(Map<String, dynamic> json)
      : paymentStripTutorial = json['paymentStripTutorial'] ?? false;

  Map<String, dynamic> toJson() => {
        'paymentStripTutorial': paymentStripTutorial,
      };
}
