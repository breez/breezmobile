import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/bloc/pos_catalog/sqlite/repository.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

SqliteRepository repo;
void main() {
  WidgetsFlutterBinding.ensureInitialized();  
  group('sqlite_repo_test', () {
    setUp(() async {      
      await SqliteRepository().dropDB();
      repo = SqliteRepository();
    });
    
    tearDownAll(() async {
      await repo.dropDB();
    });

    test("should test item", () async {      
      int id = await repo.addItem(Item(name: "item1", currency: "USD", price: 1.0));
      expect(id, 1);
      var id2 = await repo.addItem(Item(name: "item2", currency: "USD", price: 1.0));
      expect(id2, 2);     
      var items = await repo.fetchItems();
      expect(items.length, 2);
      var item1 = await repo.fetchItemByID(1);
      expect(item1.name, "item1");
      expect(item1.currency, "USD");
      expect(item1.price, 1.0);
      expect(item1.imageURL, null);

      var item2 = await repo.fetchItemByID(2);
      expect(item2.name, "item2");
      expect(item2.currency, "USD");
      expect(item2.price, 1.0);
      expect(item2.imageURL, null);
      
      var item3 = item2.copyWith(currency: "ILS");
      await repo.updateItem(item3);
      item3 = await repo.fetchItemByID(item3.id);
      expect(item3.currency, "ILS");

      repo.deleteItem(1);
      repo.deleteItem(2);
      items = await repo.fetchItems();
      expect(items.length, 0);
    });

    test("should test sale", () async {
      int saleID = await repo.addSale(Sale(saleLines: [
        SaleLine(itemName: "SaleLine1", quantity: 1, itemImageURL: "testURL1", pricePerItem: 1.0, currency: "USD", satConversionRate: 1.5 ),
        SaleLine(itemName: "SaleLine2", quantity: 1, itemImageURL: "testURL2", pricePerItem: 2.0, currency: "USD", satConversionRate: 2.5 )
      ]));
    
      expect(saleID, 1);
      var fetchedSale = await repo.fetchSaleByID(saleID);
      expect(fetchedSale.saleLines.length, 2);
      expect(fetchedSale.id, saleID);
    });

    test("should test assets", () async {
      String url = await repo.addAsset([1,2,3]);
      var assetData = await repo.fetchAssetByURL(url);
      expect(assetData.length, 3);
      await repo.deleteAsset(url);
      assetData = await repo.fetchAssetByURL(url);
      expect(assetData, null);      
    });   
  });
}