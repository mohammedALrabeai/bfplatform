class SliderClass {
  List<SliderData>? data;

  SliderClass({this.data});

  SliderClass.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data!.add(SliderData.fromJson(v));
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

class SliderData {
  int? id;
  String? image;
  String? appActivate;

  SliderData({this.id, this.appActivate, this.image});

  SliderData.fromJson(dynamic json) {
    id = json["id"];
    appActivate = json["appActivate"];
    image = json["image"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["appActivate"] = appActivate;
    map["image"] = image;
    return map;
  }
}
