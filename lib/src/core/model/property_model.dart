class PropertyModel {
  final int id;
  final String name;
  final List<UnitModel> units;

  PropertyModel({
    required this.id,
    required this.name,
    required this.units,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['PropID'],
      name: json['PropertyName'],
      units: (json['Units'] as List)
          .map((e) => UnitModel.fromJson(e))
          .toList(),
    );
  }
}

class UnitModel {
  final int id;
  final String name;

  UnitModel({
    required this.id,
    required this.name,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['UnitID'],
      name: json['UnitName'],
    );
  }
}
