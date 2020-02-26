abstract class DBItem {
  Map<String, dynamic> toMap();
}

class Asset implements DBItem {
  final String url;
  final List<int> data;

  Asset(this.url, this.data);

  Asset.fromMap(Map<String, dynamic> json)
      : url = json["url"],
        data = json["data"];

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'data': data,
    };
  }
}

class Item implements DBItem {
  final int id;
  final String name;
  final String imageURL;
  final String currency;
  final double price;

  Item({this.id, this.name, this.imageURL, this.currency, this.price});

  Item copyWith({String name, String imageURL, String currency, double price}) {
    return Item(
        id: this.id,
        name: name ?? this.name,
        imageURL: imageURL ?? this.imageURL,
        currency: currency ?? this.currency,
        price: price ?? this.price);
  }

  Item.fromMap(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        imageURL = json["imageURL"],
        currency = json["currency"],
        price = json["price"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageURL': imageURL,
      'currency': currency,
      'price': price,
    };
  }
}

class SaleLine implements DBItem {
  final int id;
  final int saleID;
  final String itemName;
  final int quantity;
  final String itemImageURL;
  final double pricePerItem;
  final String currency;
  final double satConversionRate;

  SaleLine(
      {this.id,
      this.saleID,
      this.itemName,
      this.quantity,
      this.itemImageURL,
      this.pricePerItem,
      this.currency,
      this.satConversionRate});

  SaleLine copywith(
      {String saleID,
      String itemName,
      int quantity,
      String itemImageURL,
      double pricePerItem,
      String currency,
      double satConversionRate}) {
    return SaleLine(
        id: this.id,
        saleID: saleID ?? this.saleID,
        itemName: itemName ?? this.itemName,
        quantity: quantity ?? this.quantity,
        itemImageURL: itemImageURL ?? this.itemImageURL,
        pricePerItem: pricePerItem ?? this.pricePerItem,
        currency: currency ?? this.currency,
        satConversionRate: satConversionRate ?? this.satConversionRate);
  }

  SaleLine.fromMap(Map<String, dynamic> json)
      : id = json["id"],
        saleID = json["sale_id"],
        itemName = json["item_name"],
        quantity = json["quantity"],
        itemImageURL = json["item_image_url"],
        pricePerItem = json["pricePerItem"],
        currency = json["currency"],
        satConversionRate = json["satConversionRate"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sale_id': saleID,
      'itemName': itemName,
      'quantity': quantity,
      'itemImageURL': itemImageURL,
      'pricePerItem': pricePerItem,
      'currency': currency,
      'satConversionRate': satConversionRate,
    };
  }
}

class Sale implements DBItem {
  final int id;
  final List<SaleLine> saleLines;

  Sale copyWith({List<SaleLine> saleLines}) {
    return Sale(id: this.id, saleLines: saleLines.toList());
  }

  Sale({this.id, this.saleLines});

  Sale.fromMap(Map<String, dynamic> json)
      : id = json["id"],
        saleLines = [];

  @override
  Map<String, dynamic> toMap() {
    return {'id': id};
  }
}
