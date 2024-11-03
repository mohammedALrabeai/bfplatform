import 'dart:async';
import 'dart:io';

import 'package:many_vendor_app/model/cart.dart';
import 'package:many_vendor_app/model/setting.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path =
        join(directory.path, 'multivendor.db'); //create path to database create

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          """CREATE TABLE Setting(Id INTEGER AUTO_INCREMENT [PRIMARY KEY],type TEXT,value TEXT)""");
      await db.execute(
          """CREATE TABLE wishlist(Id INTEGER AUTO_INCREMENT [PRIMARY KEY],productId INTEGER)""");
      await db.execute(
          """CREATE TABLE cart(Id INTEGER AUTO_INCREMENT [PRIMARY KEY],vendorStockId INTEGER, campaignId INTEGER, quantity INTEGER)""");
      await db.close();
    });
  }

  /*add system setting*/
  Future<int> addSystemItem(AppSetting item) async {
    final db = await init();
    return db.insert("Setting", item.toMap());
  }

  /*fetch all system setting*/
  Future<List<AppSetting>> fetchSetting() async {
    final db = await init();
    var setting = await db.query('Setting');
    return List.generate(setting.length, (i) {
      return AppSetting(
          id:
          int.parse(
          setting[i]['id'].toString()),
          type: setting[i]['type'].toString(),
          value: setting[i]['value'].toString());
    });
  }

  /*update single column*/
  Future<int> settingUpdate(String type, AppSetting item) async {
    final db = await init();
    int result = await db
        .update('setting', item.toMap(), where: 'type = ?', whereArgs: [type]);
    return result;
  }

  /*wishlist*/
  Future<int> addWishList(Wishlist item) async {
    final db = await init();
    /*check data have duplicate*/
    return db.insert('wishlist', item.toMap());
  }

/*wishlist fetch*/
  Future<List<Wishlist>> fetchWishList() async {
    final db = await init();
    var wish = await db.query('wishlist');
    return List.generate(wish.length, (i) {
      return Wishlist(id: int.parse(wish[i]['id'].toString()),
      productId: int.parse(wish[i]['productId'].toString()));
    });
  }

  /*update wishlist*/

  Future<int> removeFormDb(int id, String table) async {
    final db = await init();
    int result = await db.delete(table, where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<int> removeWishlist(int productId) async {
    final db = await init();
    int result = await db
        .delete('wishlist', where: "productId = ?", whereArgs: [productId]);

    return result;
  }

  Future<List<Cart>> fetchCart() async {
    final db = await init();
    var carts = await db.query('cart');
    return List.generate(carts.length, (index) {
      return Cart(
        id: int.parse(carts[index]['id'].toString()),
        vendorStockId: int.parse(carts[index]['vendorStockId'].toString()),
        quantity:int.parse( carts[index]['quantity'].toString()),
        campaignId:int.parse( carts[index]['campaignId'].toString()),
      );
    });
  }

  Future<int> quantity() async {
    final db = await init();
    var carts = await db.rawQuery('SELECT SUM(quantity) FROM cart');
    int value = carts[0]["SUM(quantity)"] == null ? 0 :
   int.parse(carts[0]["SUM(quantity)"].toString());
    return value;
  }

  Future<int> addToCartUpdate(int vendorStockId, Cart cart) async {
    final db = await init();
    int result = await db.update(
        'cart',
        {
          'id': cart.id,
          'vendorStockId': cart.vendorStockId,
          'campaignId': cart.campaignId,
          'quantity': cart.quantity
        },
        where: 'vendorStockId = ?',
        whereArgs: [vendorStockId]);
    return result;
  }

  /// here is something wrong
  // Future<int> addToCartWithIncrement(Cart newCart) async {
  //   final db = await init();
  //   bool status = true;
  //   // /*here increment the quantity*/
  //   var carts = await fetchCart();
  //   carts.forEach((element) {
  //     if (element.vendorStockId == newCart.vendorStockId) {
  //       newCart.quantity = element.quantity + 1;
  //       status = false;
  //       //int x=0;
  //       return addToCartUpdate(element.vendorStockId, newCart);
  //     //  return x;
  //     }
  //   });
  //   if (status) {
  //     newCart.quantity = 1;
  //     return db.insert('cart', newCart.toMap());
  //   }
  //   return 0;
  // }

  Future<int> removeCart(int vendorStockId) async {
    final db = await init();
    int result = await db
        .delete('cart', where: "vendorStockId = ?", whereArgs: [vendorStockId]);

    return result;
  }

  Future<int> removeCartCampaign(int campaignId) async {
    final db = await init();
    int result = await db
        .delete('wishlist', where: "campaignId = ?", whereArgs: [campaignId]);
    return result;
  }
}
