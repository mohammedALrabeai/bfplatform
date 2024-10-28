class BrandClass {
  List<BrandData>? data;

  BrandClass(
      this.data); // Using shorthand for constructor parameter initialization

  BrandClass.fromJson(Map<String, dynamic> json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data!.add(BrandData.fromJson(v));
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

class BrandData {
  int id; // Made non-nullable; ensure you handle null cases in your app logic
  String name;
  String logo;
  String banner;

  BrandData({
    required this.id,
    required this.name,
    required this.logo,
    required this.banner,
  });

  BrandData.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        logo = json["logo"],
        banner = json["banner"];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "logo": logo,
      "banner": banner,
    };
  }
}
