import '../../../../auth/model/personalizationOptions.dart';

class PersonalizedModel {
  PersonalizedModel({
      this.roomTemperature, 
      this.foodPersonalities, 
      this.pescatarianPreference, 
      this.gastronomyTypes, 
      this.otherGastronomy, 
      this.restaurantTypes, 
      this.activityTypes, 
      this.otherActivity,});

  PersonalizedModel.fromJson(dynamic json) {
    roomTemperature = json['roomTemperature'];
    if (json['foodPersonalities'] != null) {
      foodPersonalities = [];
      json['foodPersonalities'].forEach((v) {
        foodPersonalities?.add(PersonalizationOptions.fromJson(v));
      });
    }
    pescatarianPreference = json['pescatarianPreference'];
    if (json['gastronomyTypes'] != null) {
      gastronomyTypes = [];
      json['gastronomyTypes'].forEach((v) {
        gastronomyTypes?.add(PersonalizationOptions.fromJson(v));
      });
    }
    otherGastronomy = json['otherGastronomy'];
    if (json['restaurantTypes'] != null) {
      restaurantTypes = [];
      json['restaurantTypes'].forEach((v) {
        restaurantTypes?.add(PersonalizationOptions.fromJson(v));
      });
    }
    if (json['activityTypes'] != null) {
      activityTypes = [];
      json['activityTypes'].forEach((v) {
        activityTypes?.add(PersonalizationOptions.fromJson(v));
      });
    }
    otherActivity = json['otherActivity'];
  }
  String? roomTemperature;
  List<PersonalizationOptions>? foodPersonalities;
  String? pescatarianPreference;
  List<PersonalizationOptions>? gastronomyTypes;
  String? otherGastronomy;
  List<PersonalizationOptions>? restaurantTypes;
  List<PersonalizationOptions>? activityTypes;
  String? otherActivity;
PersonalizedModel copyWith({  String? roomTemperature,
  List<PersonalizationOptions>? foodPersonalities,
  String? pescatarianPreference,
  List<PersonalizationOptions>? gastronomyTypes,
  String? otherGastronomy,
  List<PersonalizationOptions>? restaurantTypes,
  List<PersonalizationOptions>? activityTypes,
  String? otherActivity,
}) => PersonalizedModel(  roomTemperature: roomTemperature ?? this.roomTemperature,
  foodPersonalities: foodPersonalities ?? this.foodPersonalities,
  pescatarianPreference: pescatarianPreference ?? this.pescatarianPreference,
  gastronomyTypes: gastronomyTypes ?? this.gastronomyTypes,
  otherGastronomy: otherGastronomy ?? this.otherGastronomy,
  restaurantTypes: restaurantTypes ?? this.restaurantTypes,
  activityTypes: activityTypes ?? this.activityTypes,
  otherActivity: otherActivity ?? this.otherActivity,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['roomTemperature'] = roomTemperature;
    if (foodPersonalities != null) {
      map['foodPersonalities'] = foodPersonalities?.map((v) => v.toJson()).toList();
    }
    map['pescatarianPreference'] = pescatarianPreference;
    if (gastronomyTypes != null) {
      map['gastronomyTypes'] = gastronomyTypes?.map((v) => v.toJson()).toList();
    }
    map['otherGastronomy'] = otherGastronomy;
    if (restaurantTypes != null) {
      map['restaurantTypes'] = restaurantTypes?.map((v) => v.toJson()).toList();
    }
    if (activityTypes != null) {
      map['activityTypes'] = activityTypes?.map((v) => v.toJson()).toList();
    }
    map['otherActivity'] = otherActivity;
    return map;
  }

}
