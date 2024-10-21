

class TrendingCategoryHub {
  List<TrendingCategoryData> data;


  TrendingCategoryHub({
      List<TrendingCategoryData> data}){
    data = data;
}

  TrendingCategoryHub.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(TrendingCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (data != null) {
      map["data"] = data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


class TrendingCategoryData {
  int _catId;
  String _name;
  String _image;

  int get catId => _catId;
  String get name => _name;
  String get image => _image;

  TrendingCategoryData({
      int catId, 
      String name, 
      String image}){
    _catId = catId;
    _name = name;
    _image = image;
}

  TrendingCategoryData.fromJson(dynamic json) {
    _catId = json["catId"];
    _name = json["name"];
    _image = json["image"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["catId"] = _catId;
    map["name"] = _name;
    map["image"] = _image;
    return map;
  }

}