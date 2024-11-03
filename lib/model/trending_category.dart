class TrendingCategoryHub {
  List<TrendingCategoryData>? data;

  TrendingCategoryHub({this.data});

  TrendingCategoryHub.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data!.add(TrendingCategoryData.fromJson(v));
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

class TrendingCategoryData {
  late int catId;
  late String name;
  late String image;

  TrendingCategoryData({required this.catId,required this.name,required this.image});

  TrendingCategoryData.fromJson(dynamic json) {
    catId = json["catId"];
    name = json["name"];
    image = json["image"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["catId"] = catId;
    map["name"] = name;
    map["image"] = image;
    return map;
  }
}