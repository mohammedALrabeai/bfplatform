class Category {
  List<Data>? _data;

  List<Data>? get data => _data;

  Category({required List<Data> data}) : _data = data;

  Category.fromJson(Map<String, dynamic> json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic>? toJson() {
    var map = <String, dynamic>{};
    if (_data != null) {
      map["data"] = _data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  int? _id;
  String? _name;
  List<Parent>? _parent;

  int? get id => _id;
  String? get name => _name;
  List<Parent>? get parent => _parent;

  Data({int? id, String? name, List<Parent>? parent})
      : _id = id,
        _name = name,
        _parent = parent;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json["id"];
    _name = json["name"];
    if (json["parent"] != null) {
      _parent = [];
      json["parent"].forEach((v) {
        _parent!.add(Parent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    if (_parent != null) {
      map["parent"] = _parent!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Parent {
  int? _id;
  String? _name;
  List<Child>? _child;

  int? get id => _id;
  String? get name => _name;
  List<Child>? get child => _child;

  Parent({int? id, String? name, List<Child>? child})
      : _id = id,
        _name = name,
        _child = child;

  Parent.fromJson(Map<String, dynamic> json) {
    _id = json["id"];
    _name = json["name"];
    if (json["child"] != null) {
      _child = [];
      json["child"].forEach((v) {
        _child!.add(Child.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    if (_child != null) {
      map["child"] = _child!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Child {
  int? _id;
  String? _name;

  int? get id => _id;
  String? get name => _name;

  Child({int? id, String? name})
      : _id = id,
        _name = name;

  Child.fromJson(Map<String, dynamic> json) {
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