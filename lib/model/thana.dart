

class ThanaClass {
  List<ThanaData> data;


  ThanaClass({
      List<ThanaData> data}){
    data = data;
}

  ThanaClass.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(ThanaData.fromJson(v));
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



class ThanaData {
  int _id;
  String _name;

  int get id => _id;
  String get name => _name;

  ThanaData({
      int id, 
      String name}){
    _id = id;
    _name = name;
}

  ThanaData.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    return map;
  }

}