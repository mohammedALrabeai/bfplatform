class DistrictClass {
  List<DistrictData> data=[]; // Made non-nullable

  DistrictClass(List<DistrictData> data)
      : data = data ?? []; // Initialize with an empty list if null

  DistrictClass.fromJson(Map<String, dynamic> json)
      : data = (json["data"] as List<dynamic> ?? [])
      .map((v) => DistrictData.fromJson(v))
      .toList(); // Use list comprehension

  Map<String, dynamic> toJson() {
    return {
      "data": data.map((v) => v.toJson()).toList(),
    };
  }
}

class DistrictData {
  int id; // Made non-nullable
  String district; // Made non-nullable

  DistrictData(
      {required this.id,
        required this.district}); // Use required for non-nullable fields

  DistrictData.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        district = json["district"];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "district": district,
    };
  }
}