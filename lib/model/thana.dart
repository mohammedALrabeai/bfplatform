class ThanaClass {
  List<ThanaData>? data;

  ThanaClass({this.data});

  ThanaClass.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data!.add(ThanaData.fromJson(v));
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

class ThanaData {
  int? id;
  String? name;

  ThanaData({this.id, this.name});

  ThanaData.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    return map;
  }
}
