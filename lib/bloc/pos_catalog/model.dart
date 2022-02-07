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
  final String sku;
  final String imageURL;
  final String currency;
  final double price;

  Item(
      {this.id, this.name, this.sku, this.imageURL, this.currency, this.price});

  Item copyWith(
      {String name,
      String sku,
      String imageURL,
      String currency,
      double price}) {
    return Item(
        id: this.id,
        name: name ?? this.name,
        sku: sku ?? this.sku,
        imageURL: imageURL ?? this.imageURL,
        currency: currency ?? this.currency,
        price: price ?? this.price);
  }

  Item.fromMap(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        sku = json["sku"],
        imageURL = json["imageURL"],
        currency = json["currency"],
        price = json["price"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'imageURL': imageURL,
      'currency': currency,
      'price': price,
    };
  }
}

class SaleLine implements DBItem {
  final int id;
  final int saleID;
  final int itemID;
  final String itemName;
  final String itemSKU;
  final int quantity;
  final String itemImageURL;
  final double pricePerItem;
  final String currency;
  final double satConversionRate;

  double get totalFiat => quantity * pricePerItem;

  double get totalSats => totalFiat * satConversionRate;

  bool get isCustom => itemID == null;

  SaleLine(
      {this.id,
      this.saleID,
      this.itemID,
      this.itemName,
      this.itemSKU,
      this.quantity,
      this.itemImageURL,
      this.pricePerItem,
      this.currency,
      this.satConversionRate});

  SaleLine copyWith(
      {int id,
      int saleID,
      String itemName,
      String itemSKU,
      int quantity,
      String itemImageURL,
      double pricePerItem,
      String currency,
      double satConversionRate}) {
    return SaleLine(
        id: id != null && id < 0 ? null : this.id,
        saleID: saleID ?? this.saleID,
        itemID: this.itemID,
        itemName: itemName ?? this.itemName,
        itemSKU: itemSKU ?? this.itemSKU,
        quantity: quantity ?? this.quantity,
        itemImageURL: itemImageURL ?? this.itemImageURL,
        pricePerItem: pricePerItem ?? this.pricePerItem,
        currency: currency ?? this.currency,
        satConversionRate: satConversionRate ?? this.satConversionRate);
  }

  SaleLine copyNew() {
    return copyWith(id: -1);
  }

  SaleLine.fromItem(Item item, int quantity, double satConversionRate)
      : id = null,
        saleID = null,
        itemID = item.id,
        itemName = item.name,
        itemSKU = item.sku,
        quantity = quantity,
        itemImageURL = item.imageURL,
        pricePerItem = item.price,
        currency = item.currency,
        satConversionRate = satConversionRate;

  SaleLine.fromMap(Map<String, dynamic> json)
      : id = json["id"],
        saleID = json["sale_id"],
        itemID = json["item_id"],
        itemName = json["item_name"],
        itemSKU = json["item_sku"],
        quantity = json["quantity"],
        itemImageURL = json["item_image_url"],
        pricePerItem = json["price_per_item"],
        currency = json["currency"],
        satConversionRate = json["sat_conversion_rate"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sale_id': saleID,
      'item_name': itemName,
      'item_id': itemID,
      'item_sku': itemSKU,
      'quantity': quantity,
      'item_image_url': itemImageURL,
      'price_per_item': pricePerItem,
      'currency': currency,
      'sat_conversion_rate': satConversionRate,
    };
  }
}

class Sale implements DBItem {
  final int id;
  final List<SaleLine> saleLines;
  final String note;
  final bool priceLocked;

  Sale copyWith(
      {int id, List<SaleLine> saleLines, bool priceLocked, String note}) {
    return Sale(
        id: id != null && id < 0 ? null : this.id,
        note: note ?? this.note,
        saleLines: (saleLines ?? this.saleLines).toList(),
        priceLocked: priceLocked ?? this.priceLocked);
  }

  Sale copyNew() {
    return copyWith(
        id: -1, saleLines: this.saleLines.map((sl) => sl.copyNew()).toList());
  }

  Sale({this.id, this.saleLines, this.note, this.priceLocked = false});

  Sale.fromMap(Map<String, dynamic> json)
      : id = json["id"],
        saleLines = [],
        note = json["note"],
        priceLocked = false;

  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'note': note};
  }

  Sale addItem(Item item, double satConversionRate, {int quantity = 1}) {
    bool hasSaleLine = false;
    var saleLines = this.saleLines.map((sl) {
      if (sl.itemID == item.id) {
        hasSaleLine = true;
        return sl.copyWith(quantity: sl.quantity + quantity);
      }
      return sl;
    }).toList();

    if (!hasSaleLine) {
      saleLines.add(SaleLine.fromItem(item, quantity, satConversionRate)
          .copyWith(saleID: this.id));
    }
    return this.copyWith(saleLines: saleLines);
  }

  Sale removeItem(bool Function(SaleLine) predicate) {
    var saleLines = this.saleLines.toList();
    return this.copyWith(
        saleLines: saleLines..removeWhere((element) => predicate(element)));
  }

  Sale updateItems(SaleLine Function(SaleLine) predicate) {
    var saleLines = this.saleLines.toList();
    return this.copyWith(
        saleLines: saleLines.map((element) {
      return predicate(element);
    }).toList());
  }

  Sale incrementQuantity(int itemID, double satConversionRate,
      {int quantity = 1}) {
    var saleLines = this.saleLines.map((sl) {
      if (sl.itemID == itemID) {
        return sl.copyWith(quantity: sl.quantity + quantity);
      }
      return sl;
    }).toList();

    return this
        .copyWith(saleLines: saleLines.where((s) => s.quantity > 0).toList());
  }

  Sale addCustomItem(double price, String currency, double satConversionRate) {
    int customItemsCount =
        this.saleLines.where((element) => element.itemID == null).length;
    var newSaleLines = this.saleLines.toList()
      ..add(SaleLine(
          itemName: "Item ${customItemsCount + 1}",
          saleID: this.id,
          pricePerItem: price,
          quantity: 1,
          currency: currency,
          satConversionRate: satConversionRate));
    return this.copyWith(saleLines: newSaleLines);
  }

  double get totalChargeSat {
    double totalSat = 0;
    Map<double, double> perCurrency = Map();
    saleLines.forEach((element) {
      perCurrency[element.satConversionRate] =
          (perCurrency[element.satConversionRate] ?? 0) +
              element.pricePerItem * element.quantity;
    });
    perCurrency.forEach((rate, value) {
      totalSat += rate * value;
    });
    return totalSat;
  }

  int get totalNumOfItems {
    int total = 0;
    saleLines.forEach((sl) {
      total += sl.quantity;
    });
    return total;
  }

  Map<String, double> get totalAmountInFiat {
    Map<String, double> totals = {};
    saleLines.forEach((saleLine) {
      final previous = totals[saleLine.currency] ?? 0.0;
      totals[saleLine.currency] = previous + saleLine.totalFiat;
    });
    return totals;
  }

  double get totalAmountInSats {
    var total = 0.0;
    saleLines.forEach((saleLine) {
      total += saleLine.totalSats;
    });
    return total;
  }
}

class ProductIcon {
  final List<String> tags;
  final List<String> aliases;
  final String name;

  String get assetPath => "src/pos-icons/$name.svg";

  ProductIcon(this.tags, this.aliases, this.name);

  ProductIcon.fromJson(Map<String, dynamic> json)
      : this((json["tags"] as List<dynamic>).cast<String>(),
            (json["aliases"] as List<dynamic>).cast<String>(), json["name"]);

  bool matches(String searchTerm) {
    return [...tags, ...aliases, name].any((element) {
      return element
          .toLowerCase()
          .contains(searchTerm.replaceAll(" ", "-").toLowerCase());
    });
  }
}

enum PosCatalogItemSort {
  NONE,
  ALPHABETICALLY_A_Z,
  ALPHABETICALLY_Z_A,
  PRICE_SMALL_TO_BIG,
  PRICE_BIG_TO_SMALL,
}
