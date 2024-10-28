class CampaignItem {
  List<Data>? _data;

  List<Data>? get data => _data;

  CampaignItem({List<Data>? data}) : _data = data;

  CampaignItem.fromJson(Map<String, dynamic> json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map["data"] = _data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  int _productId;
  String _image;
  String _name;
  int _campaignId;
  dynamic _quantity;
  int _vendorStockId;
  bool _stockOut;
  String _price;
  int _rating;
  String _shopName;
  List<Shops>? _shops;

  int get productId => _productId;
  String get image => _image;
  String get name => _name;
  int get campaignId => _campaignId;
  dynamic get quantity => _quantity;
  int get vendorStockId => _vendorStockId;
  bool get stockOut => _stockOut;
  String get price => _price;
  int get rating => _rating;
  String get shopName => _shopName;
  List<Shops>? get shops => _shops;

  Data({
    required int productId,
    required String image,
    required String name,
    required int campaignId,
    dynamic quantity,
    required int vendorStockId,
    required bool stockOut,
    required String price,
    required int rating,
    required String shopName,
    List<Shops>? shops,
  })  : _productId = productId,
        _image = image,
        _name = name,
        _campaignId = campaignId,
        _quantity = quantity,
        _vendorStockId = vendorStockId,
        _stockOut = stockOut,
        _price = price,
        _rating = rating,
        _shopName = shopName,
        _shops = shops;

  Data.fromJson(Map<String, dynamic> json)
      : _productId = json["productId"],
        _image = json["image"],
        _name = json["name"],
        _campaignId = json["campaignId"],
        _quantity = json["quantity"],
        _vendorStockId = json["vendorStockId"],
        _stockOut = json["stockOut"],
        _price = json["price"],
        _rating = json["rating"],
        _shopName = json["shopName"],
        _shops = (json["shops"] != null)
            ? (json["shops"] as List).map((v) => Shops.fromJson(v)).toList()
            : null;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["productId"] = _productId;
    map["image"] = _image;
    map["name"] = _name;
    map["campaignId"] = _campaignId;
    map["quantity"] = _quantity;
    map["vendorStockId"] = _vendorStockId;
    map["price"] = _price;
    map["rating"] = _rating;
    map["shopName"] = _shopName;
    if (_shops != null) {
      map["shops"] = _shops!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Shops {
  int _vendorId;
  bool _stockOut;
  String? _discountText;
  String? _priceFormat;
  int _price;
  String? _extraPriceFormat;
  int _extraPrice;
  String? _totalPriceFormat;
  int _totalPrice;
  dynamic _shopLogo;
  int _vendorStockId;
  String? _variant;

  int get vendorId => _vendorId;
  bool get stockOut => _stockOut;
  String? get discountText => _discountText;
  String? get priceFormat => _priceFormat;
  int get price => _price;
  String? get extraPriceFormat => _extraPriceFormat;
  int get extraPrice => _extraPrice;
  String? get totalPriceFormat => _totalPriceFormat;
  int get totalPrice => _totalPrice;
  dynamic get shopLogo => _shopLogo;
  int get vendorStockId => _vendorStockId;
  String? get variant => _variant;

  Shops({
    required int vendorId,
    required bool stockOut,
    String? discountText,
    String? priceFormat,
    required int price,
    String? extraPriceFormat,
    required int extraPrice,
    String? totalPriceFormat,
    required int totalPrice,
    dynamic shopLogo,
    required int vendorStockId,
    String? variant,
  })  : _vendorId = vendorId,
        _stockOut = stockOut,
        _discountText = discountText,
        _priceFormat = priceFormat,
        _price = price,
        _extraPriceFormat = extraPriceFormat,
        _extraPrice = extraPrice,
        _totalPriceFormat = totalPriceFormat,
        _totalPrice = totalPrice,
        _shopLogo = shopLogo,
        _vendorStockId = vendorStockId,
        _variant = variant;

  Shops.fromJson(Map<String, dynamic> json)
      : _vendorId = json["vendorId"],
        _stockOut = json["stockOut"],
        _discountText = json["discountText"],
        _priceFormat = json["priceFormat"],
        _price = json["price"],
        _extraPriceFormat = json["extraPriceFormat"],
        _extraPrice = json["extraPrice"],
        _totalPriceFormat = json["totalPriceFormat"],
        _totalPrice = json["totalPrice"],
        _shopLogo = json["shopLogo"],
        _vendorStockId = json["vendorStockId"],
        _variant = json["variant"];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["vendorId"] = _vendorId;
    map["stockOut"] = _stockOut;
    map["discountText"] = _discountText;
    map["priceFormat"] = _priceFormat;
    map["price"] = _price;
    map["extraPriceFormat"] = _extraPriceFormat;
    map["extraPrice"] = _extraPrice;
    map["totalPriceFormat"] = _totalPriceFormat;
    map["totalPrice"] = _totalPrice;
    map["shopLogo"] = _shopLogo;
    map["vendorStockId"] = _vendorStockId;
    map["variant"] = _variant;
    return map;
  }
}
