class PreferencesModel {
  PreferencesModel({
      this.maritalStatus, 
      this.hasKids, 
      this.kids, 
      this.pets, 
      this.isSmoker, 
      this.healthProblem, 
      this.allergies, 
      this.hasMobilityProblem, 
      this.footSize, 
      this.clotheSize,});

  PreferencesModel.fromJson(dynamic json) {
    maritalStatus = json['maritalStatus'];
    hasKids = json['hasKids'];
    kids = json['kids'] != null ? json['kids'].cast<String>() : [];
    pets = json['pets'] != null ? json['pets'].cast<String>() : [];
    isSmoker = json['isSmoker'];
    healthProblem = json['healthProblem'];
    allergies = json['allergies'] != null ? json['allergies'].cast<String>() : [];
    hasMobilityProblem = json['hasMobilityProblem'];
    footSize = json['footSize'];
    clotheSize = json['clotheSize'];
  }
  int? maritalStatus;
  bool? hasKids;
  List<String>? kids;
  List<String>? pets;
  bool? isSmoker;
  String? healthProblem;
  List<String>? allergies;
  bool? hasMobilityProblem;
  String? footSize;
  String? clotheSize;
PreferencesModel copyWith({  int? maritalStatus,
  bool? hasKids,
  List<String>? kids,
  List<String>? pets,
  bool? isSmoker,
  String? healthProblem,
  List<String>? allergies,
  bool? hasMobilityProblem,
  String? footSize,
  String? clotheSize,
}) => PreferencesModel(  maritalStatus: maritalStatus ?? this.maritalStatus,
  hasKids: hasKids ?? this.hasKids,
  kids: kids ?? this.kids,
  pets: pets ?? this.pets,
  isSmoker: isSmoker ?? this.isSmoker,
  healthProblem: healthProblem ?? this.healthProblem,
  allergies: allergies ?? this.allergies,
  hasMobilityProblem: hasMobilityProblem ?? this.hasMobilityProblem,
  footSize: footSize ?? this.footSize,
  clotheSize: clotheSize ?? this.clotheSize,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['maritalStatus'] = maritalStatus;
    map['hasKids'] = hasKids;
    map['kids'] = kids;
    map['pets'] = pets;
    map['isSmoker'] = isSmoker;
    map['healthProblem'] = healthProblem;
    map['allergies'] = allergies;
    map['hasMobilityProblem'] = hasMobilityProblem;
    map['footSize'] = footSize;
    map['clotheSize'] = clotheSize;
    return map;
  }

}