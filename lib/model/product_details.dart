class ProductDetails {
  Product? data;

  ProductDetails({this.data});

  ProductDetails.fromJson(dynamic json) {
    data = json["data"] != null ? Product.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (data != null) {
      map["data"] = data!.toJson();
    }
    return map;
  }
}

class Product {
  int? productId;
  String? name;
  String? shortDesc;
  dynamic bigDesc;
  String? discount;
  bool? discountHave;
  String? price;
  String? catName;
  int? catId;
  String? brand;
  int? brandId;
  List<Images>? images;
  List<Variants>? variants;
  List<ForCart>? forCart;

  Product({
    this.productId,
    this.name,
    this.shortDesc,
    this.bigDesc,
    this.discount,
    this.discountHave,
    this.price,
    this.catName,
    this.catId,
    this.brand,
    this.brandId,
    this.images,
    this.variants,
    this.forCart,
  });

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
        images!.add(Images.fromJson(v));
      });
    }
    if (json["variants"] != null) {
      variants = [];
      json["variants"].forEach((v) {
        variants!.add(Variants.fromJson(v));
      });
    }
    if (json["forCart"] != null) {
      forCart = [];
      json["forCart"].forEach((v) {
        forCart!.add(ForCart.fromJson(v));
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
      map["images"] = images!.map((v) => v.toJson()).toList();
    }
    if (variants != null) {
      map["variants"] = variants!.map((v) => v.toJson()).toList();
    }
    if (forCart != null) {
      map["forCart"] = forCart!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ForCart {
  String? name;
  String? email;
  int? vendorId;
  int? rating;
  bool? stockOut;
  String? discountText;
  String? priceFormat;
  dynamic price;
  String? extraPriceFormat;
  dynamic extraPrice;
  String? totalPriceFormat;
  dynamic totalPrice;
  String? shopLogo;
  String? slug;
  int? vendorStockId;
  String? variant;
  int? rateing;

  ForCart({
    this.name,
    this.email,
    this.vendorId,
    this.rating,
    this.stockOut,
    this.discountText,
    this.priceFormat,
    this.price,
    this.extraPriceFormat,
    this.extraPrice,
    this.totalPriceFormat,
    this.totalPrice,
    this.shopLogo,
    this.slug,
    this.vendorStockId,
    this.variant,
  });

  ForCart.fromJson(dynamic json) {
    name = json["name"];
    email = json["email"];
    vendorId = json["vendorId"];
    rating = json["rating"];
    stockOut = json["stockOut"];
    discountText = json["discountText"];
    priceFormat = json["priceFormat"];
    price = json["price"];
    extraPriceFormat = json["extraPriceFormat"];
    extraPrice = json["extraPrice"];
    totalPriceFormat = json["totalPriceFormat"];
    totalPrice = json["totalPrice"];
    shopLogo = json["shopLogo"];
    slug = json["slug"];
    vendorStockId = json["vendorStockId"];
    variant = json["variant"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["email"] = email;
    map["vendorId"] = vendorId;
    map["rating"] = rating;
    map["stockOut"] = stockOut;
    map["discountText"] = discountText;
    map["priceFormat"] = priceFormat;
    map["price"] = price;
    map["extraPriceFormat"] = extraPriceFormat;
    map["extraPrice"] = extraPrice;
    map["totalPriceFormat"] = totalPriceFormat;
    map["totalPrice"] = totalPrice;
    map["shopLogo"] = shopLogo;
    map["slug"] = slug;
    map["vendorStockId"] = vendorStockId;
    map["variant"] = variant;
    return map;
  }
}

class Variants {
  String? unit;
  List<Variant>? variant;

  Variants({this.unit, this.variant});

  Variants.fromJson(dynamic json) {
    unit = json["unit"];
    if (json["variant"] != null) {
      variant = [];
      json["variant"].forEach((v) {
        variant!.add(Variant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["unit"] = unit;
    if (variant != null) {
      map["variant"] = variant!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Variant {
  int? variantId;
  String? unit;
  bool? active;
  String? variant;
  String? code;

  Variant({this.variantId, this.unit, this.active, this.variant, this.code});

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
  String? url;

  Images({this.url});

  Images.fromJson(dynamic json) {
    url = json["url"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["url"] = url;
    return map;
  }
}