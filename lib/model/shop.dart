class ShopHub {
  List<ShopData>? data;

  ShopHub({this.data});

  ShopHub.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data!.add(ShopData.fromJson(v));
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

class ShopData {
  late int id;
  late String name;
  late int vendorId;
  late String shopLogo;
  late String shopName;
  late String phone;
  late String address;
  late String about;
  late String facebook;
  late int totalProduct;
  late int rating;

  ShopData({
   required this.id,
    required this.name,
    required this.vendorId,
    required this.shopLogo,
    required this.shopName,
    required this.phone,
    required this.address,
    required this.about,
    required this.facebook,
    required this.totalProduct,
    required this.rating,
  });

  ShopData.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    vendorId = json["vendorId"];
    shopLogo = json["shopLogo"];
    shopName = json["shopName"];
    phone = json["phone"];
    address = json["address"];
    about = json["about"];
    facebook = json["facebook"];
    totalProduct = json["totalProduct"];
    rating = json["rating"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["vendorId"] = vendorId;
    map["shopLogo"] = shopLogo;
    map["shopName"] = shopName;
    map["phone"] = phone;
    map["address"] = address;
    map["about"] = about;
    map["facebook"] = facebook;
    map["totalProduct"] = totalProduct;
    map["rating"] = rating;
    return map;
  }
}