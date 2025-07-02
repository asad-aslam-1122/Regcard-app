class DurationModel {
  DurationModel({
    this.id,
    this.title,
    this.isActive,
    this.durationCount,
    this.durationType,
  });

  DurationModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    isActive = json['isActive'];
    durationCount = json['durationCount'];
    durationType = json['durationType'];
  }
  num? id;
  String? title;
  bool? isActive;
  num? durationCount;
  num? durationType;
  DurationModel copyWith({
    num? id,
    String? title,
    bool? isActive,
    num? durationCount,
    num? durationType,
  }) =>
      DurationModel(
        id: id ?? this.id,
        title: title ?? this.title,
        isActive: isActive ?? this.isActive,
        durationCount: durationCount ?? this.durationCount,
        durationType: durationType ?? this.durationType,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['isActive'] = isActive;
    map['durationCount'] = durationCount;
    map['durationType'] = durationType;
    return map;
  }
}
