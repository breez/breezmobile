class BusinessAddress {
  final String addressLine1;
  final String addressLine2;

  BusinessAddress._({this.addressLine1, this.addressLine2});

  BusinessAddress.initial() : this._(addressLine1: "", addressLine2: "");

  BusinessAddress copyWith({String addressLine1, String addressLine2}) {
    return BusinessAddress._(
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2);
  }

  BusinessAddress.fromJson(Map<String, dynamic> json)
      : addressLine1 = json['addressLine1'],
        addressLine2 = json['addressLine2'];

  Map<String, dynamic> toJson() => {
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
      };

  @override
  String toString() {
    return "$addressLine1\n$addressLine2";
  }
}
