class ShopProductHub {
  List<ShopProductData>? data;

  ShopProductHub({this.data});

  ShopProductHub.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data!.add(ShopProductData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (data != null) {
      map["data"] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ShopProductData {
  dynamic productId;
  String? name;
  String? image;
  String? slug;
  int? sku;
  String? discount;
  bool? discountHave;
  String? price;

  ShopProductData({
    this.productId,
    this.name,
    this.image,
    this.slug,
    this.sku,
    this.discount,
    this.discountHave,
    this.price,
  });

  ShopProductData.fromJson(dynamic json) {
    productId = json["productId"];
    name = json["name"];
    image = json["image"];
    slug = json["slug"];
    sku = json["sku"];
    discount = json["discount"];
    discountHave = json["discountHave"];
    price = json["price"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["productId"] = productId;
    map["name"] = name;
    map["image"] = image;
    map["slug"] = slug;
    map["sku"] = sku;
    map["discount"] = discount;
    map["discountHave"] = discountHave;
    map["price"] = price;
    return map;
  }
}