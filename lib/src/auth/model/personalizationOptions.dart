class PersonalizationOptions {
  String? description;
  int? id;

  PersonalizationOptions({this.description, this.id});

  PersonalizationOptions.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['id'] = id;
    return data;
  }
}