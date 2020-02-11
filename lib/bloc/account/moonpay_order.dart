class MoonpayOrder {
  final String address;
  final String url;
  final int orderTimestamp;

  MoonpayOrder(this.address, this.url, this.orderTimestamp);

  MoonpayOrder.fromJson(Map<String, dynamic> json)
      : this(json["address"], json["url"], json["orderTimestamp"] ?? null);

  Map<String, dynamic> toJson() {
    return {
      "address": address,
      "url": url,
      "orderTimestamp": orderTimestamp,
    };
  }

  MoonpayOrder copyWith({int orderTimestamp}) {
    return MoonpayOrder(this.address, this.url, orderTimestamp);
  }
}
