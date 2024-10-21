

class ProductDetails {
  Product data;



  ProductDetails({
    Product data}){
    data = data;
}

  ProductDetails.fromJson(dynamic json) {
    data = json["data"] != null ? Product.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (data != null) {
      map["data"] = data.toJson();
    }
    return map;
  }

}


class Product {
  int productId;
  String name;
  String shortDesc;
  dynamic bigDesc;
  String discount;
  bool discountHave;
  String price;
  String catName;
  int catId;
  String brand;
  int brandId;
  List<Images> images;
  List<Variants> variants;
  List<ForCart> forCart;


  Product({
      int productId, 
      String name, 
      String shortDesc, 
      dynamic bigDesc, 
      String discount, 
      bool discountHave,
      String price,
      String catName, 
      int catId, 
      String brand, 
      int brandId, 
      List<Images> images, 
      List<Variants> variants, 
      List<ForCart> forCart}){
    productId = productId;
    name = name;
    shortDesc = shortDesc;
    bigDesc = bigDesc;
    discount = discount;
    discountHave = discountHave;
    price = price;
    catName = catName;
    catId = catId;
    brand = brand;
    brandId = brandId;
    images = images;
    variants = variants;
    forCart = forCart;
}

  Product.fromJson(dynamic json) {
    productId = json["productId"];
    name = json["name"];
    shortDesc = json["shortDesc"];
    bigDesc = json["bigDesc"];
    discount = json["discount"];
    discountHave = json["discountHave"];
    price = json["price"];
    catName = json["catName"];
    catId = json["catId"];
    brand = json["brand"];
    brandId = json["brandId"];
    if (json["images"] != null) {
      images = [];
      json["images"].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
    if (json["variants"] != null) {
      variants = [];
      json["variants"].forEach((v) {
        variants.add(Variants.fromJson(v));
      });
    }
    if (json["forCart"] != null) {
      forCart = [];
      json["forCart"].forEach((v) {
        forCart.add(ForCart.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["productId"] = productId;
    map["name"] = name;
    map["shortDesc"] = shortDesc;
    map["bigDesc"] = bigDesc;
    map["discount"] = discount;
    map["price"] = price;
    map["catName"] = catName;
    map["catId"] = catId;
    map["brand"] = brand;
    map["brandId"] = brandId;
    if (images != null) {
      map["images"] = images.map((v) => v.toJson()).toList();
    }
    if (variants != null) {
      map["variants"] = variants.map((v) => v.toJson()).toList();
    }
    if (forCart != null) {
      map["forCart"] = forCart.map((v) => v.toJson()).toList();
    }
    return map;
  }

}



class ForCart {
  String _name;
  String _email;
  int _vendorId;
  int _rating;
  bool _stockOut;
  String _discountText;
  String _priceFormat;
  dynamic _price;
  String _extraPriceFormat;
  dynamic _extraPrice;
  String _totalPriceFormat;
  dynamic _totalPrice;
  String _shopLogo;
  String _slug;
  int _vendorStockId;
  String _variant;
  int _rateing;

  String get name => _name;
  String get email => _email;
  int get vendorId => _vendorId;
  int get rating => _rating;
  bool get stockOut => _stockOut;
  String get discountText=> _discountText;
  String get priceFormat => _priceFormat;
  dynamic get price => _price;
  String get extraPriceFormat => _extraPriceFormat;
  dynamic get extraPrice => _extraPrice;
  String get totalPriceFormat => _totalPriceFormat;
  dynamic get totalPrice => _totalPrice;
  String get shopLogo => _shopLogo;
  String get slug => _slug;
  int get vendorStockId => _vendorStockId;
  String get variant => _variant;
  int get rateing => _rateing;

  ForCart({
      String name, 
      String email, 
      int vendorId, 
      int rating,
      bool stockOut,
      String discountText,
      String priceFormat,
    dynamic price,
      String extraPriceFormat,
    dynamic extraPrice,
      String totalPriceFormat,
    dynamic totalPrice,
      String shopLogo, 
      String slug, 
      int vendorStockId, 
      String variant}){
    _name = name;
    _email = email;
    _vendorId = vendorId;
    _rating = rating;
    _stockOut = stockOut;
    _discountText= discountText;
    _priceFormat = priceFormat;
    _price = price;
    _extraPriceFormat = extraPriceFormat;
    _extraPrice = extraPrice;
    _totalPriceFormat = totalPriceFormat;
    _totalPrice = totalPrice;
    _shopLogo = shopLogo;
    _slug = slug;
    _vendorStockId = vendorStockId;
    _variant = variant;
}

  ForCart.fromJson(dynamic json) {
    _name = json["name"];
    _email = json["email"];
    _vendorId = json["vendorId"];
    _rating = json["rating"];
    _stockOut = json["stockOut"];
    _discountText = json["discountText"];
    _priceFormat = json["priceFormat"];
    _price = json["price"];
    _extraPriceFormat = json["extraPriceFormat"];
    _extraPrice = json["extraPrice"];
    _totalPriceFormat = json["totalPriceFormat"];
    _totalPrice = json["totalPrice"];
    _shopLogo = json["shopLogo"];
    _slug = json["slug"];
    _vendorStockId = json["vendorStockId"];
    _variant = json["variant"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["email"] = _email;
    map["vendorId"] = _vendorId;
    map["rating"] = _rating;
    map["stockOut"] = _stockOut;
    map["discountText"] = _discountText;
    map["priceFormat"] = _priceFormat;
    map["price"] = _price;
    map["extraPriceFormat"] = _extraPriceFormat;
    map["extraPrice"] = _extraPrice;
    map["totalPriceFormat"] = _totalPriceFormat;
    map["totalPrice"] = _totalPrice;
    map["shopLogo"] = _shopLogo;
    map["slug"] = _slug;
    map["vendorStockId"] = _vendorStockId;
    map["variant"] = _variant;
    return map;
  }

}



class Variants {
  String _unit;
  List<Variant> _variant;

  String get unit => _unit;
  List<Variant> get variant => _variant;

  Variants({
    String unit,
    List<Variant> variant}){
    _unit = unit;
    _variant = variant;
  }

  Variants.fromJson(dynamic json) {
    _unit = json["unit"];
    if (json["variant"] != null) {
      _variant = [];
      json["variant"].forEach((v) {
        _variant.add(Variant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["unit"] = _unit;
    if (_variant != null) {
      map["variant"] = _variant.map((v) => v.toJson()).toList();
    }
    return map;
  }

}



class Variant {
  int variantId;
  String unit;
  bool active;
  String variant;
  String code;


  Variant({
    int variantId,
    String unit,
    bool active,
    String variant,
    String code}){
    variantId = variantId;
    unit = unit;
    active = active;
    variant = variant;
    code = code;
  }

  Variant.fromJson(dynamic json) {
    variantId = json["variantId"];
    unit = json["unit"];
    active = json["active"];
    variant = json["variant"];
    code = json["code"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["variantId"] = variantId;
    map["unit"] = unit;
    map["active"] = active;
    map["variant"] = variant;
    map["code"] = code;
    return map;
  }

}





class Images {
  String _url;

  String get url => _url;

  Images({
      String url}){
    _url = url;
}

  Images.fromJson(dynamic json) {
    _url = json["url"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["url"] = _url;
    return map;
  }

}