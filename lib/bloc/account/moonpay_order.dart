class MoonpayOrder {
  final String address;
  final int timestamp;

  MoonpayOrder(this.address, this.timestamp);

  MoonpayOrder.fromJson(Map<String, dynamic> json)
      : this(json["pendingMoonpayOrderAddress"] ?? null, json["pendingMoonpayOrderTimestamp"] ?? null);

  Map<String, dynamic> toJson() {
    return {
      "pendingMoonpayOrderAddress": address,
      "pendingMoonpayOrderTimestamp": timestamp,
    };
  }
}
