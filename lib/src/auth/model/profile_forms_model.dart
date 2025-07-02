import 'package:regcard/src/auth/model/personalizationOptions.dart';

class ProfileFormsModel {
  ProfileFormsModel({
      this.id, 
      this.email, 
      this.phoneNumber, 
      this.title, 
      this.firstName, 
      this.lastName, 
      this.fullName, 
      this.loginRole, 
      this.fcmToken, 
      this.timeZoneId, 
      this.isBlocked, 
      this.profileStep, 
      this.step1, 
      this.step2, 
      this.step3, 
      this.step4, 
      this.step5, 
      this.step6, 
      this.step7,});

  ProfileFormsModel.fromJson(dynamic json) {
    id = json['id'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    title = json['title'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    fullName = json['fullName'];
    loginRole = json['loginRole'];
    fcmToken = json['fcmToken'];
    timeZoneId = json['timeZoneId'];
    isBlocked = json['isBlocked'];
    profileStep = json['profileStep'];
    step1 = json['step1'] != null ? Step1.fromJson(json['step1']) : null;
    step2 = json['step2'] != null ? Step2.fromJson(json['step2']) : null;
    step3 = json['step3'] != null ? Step3.fromJson(json['step3']) : null;
    step4 = json['step4'] != null ? Step4.fromJson(json['step4']) : null;
    step5 = json['step5'] != null ? Step5.fromJson(json['step5']) : null;
    step6 = json['step6'] != null ? Step6.fromJson(json['step6']) : null;
    step7 = json['step7'] != null ? Step7.fromJson(json['step7']) : null;
  }
  String? id;
  String? email;
  String? phoneNumber;
  String? title;
  String? firstName;
  String? lastName;
  String? fullName;
  int? loginRole;
  String? fcmToken;
  String? timeZoneId;
  bool? isBlocked;
  int? profileStep;
  Step1? step1;
  Step2? step2;
  Step3? step3;
  Step4? step4;
  Step5? step5;
  Step6? step6;
  Step7? step7;
ProfileFormsModel copyWith({  String? id,
  String? email,
  String? phoneNumber,
  String? title,
  String? firstName,
  String? lastName,
  String? fullName,
  int? loginRole,
  String? fcmToken,
  String? timeZoneId,
  bool? isBlocked,
  int? profileStep,
  Step1? step1,
  Step2? step2,
  Step3? step3,
  Step4? step4,
  Step5? step5,
  Step6? step6,
  Step7? step7,
}) => ProfileFormsModel(  id: id ?? this.id,
  email: email ?? this.email,
  phoneNumber: phoneNumber ?? this.phoneNumber,
  title: title ?? this.title,
  firstName: firstName ?? this.firstName,
  lastName: lastName ?? this.lastName,
  fullName: fullName ?? this.fullName,
  loginRole: loginRole ?? this.loginRole,
  fcmToken: fcmToken ?? this.fcmToken,
  timeZoneId: timeZoneId ?? this.timeZoneId,
  isBlocked: isBlocked ?? this.isBlocked,
  profileStep: profileStep ?? this.profileStep,
  step1: step1 ?? this.step1,
  step2: step2 ?? this.step2,
  step3: step3 ?? this.step3,
  step4: step4 ?? this.step4,
  step5: step5 ?? this.step5,
  step6: step6 ?? this.step6,
  step7: step7 ?? this.step7,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    map['title'] = title;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['fullName'] = fullName;
    map['loginRole'] = loginRole;
    map['fcmToken'] = fcmToken;
    map['timeZoneId'] = timeZoneId;
    map['isBlocked'] = isBlocked;
    map['profileStep'] = profileStep;
    if (step1 != null) {
      map['step1'] = step1?.toJson();
    }
    if (step2 != null) {
      map['step2'] = step2?.toJson();
    }
    if (step3 != null) {
      map['step3'] = step3?.toJson();
    }
    if (step4 != null) {
      map['step4'] = step4?.toJson();
    }
    if (step5 != null) {
      map['step5'] = step5?.toJson();
    }
    if (step6 != null) {
      map['step6'] = step6?.toJson();
    }
    if (step7 != null) {
      map['step7'] = step7?.toJson();
    }
    return map;
  }

}

class Step7 {
  Step7({
      this.activityTypes, 
      this.otherActivity,});

  Step7.fromJson(dynamic json) {
    if (json['activityTypes'] != null) {
      activityTypes = [];
      json['activityTypes'].forEach((v) {
        activityTypes?.add(PersonalizationOptions.fromJson(v));
      });
    }
    otherActivity = json['otherActivity'];
  }
  List<PersonalizationOptions>? activityTypes;
  String? otherActivity;
Step7 copyWith({  List<PersonalizationOptions>? activityTypes,
  String? otherActivity,
}) => Step7(  activityTypes: activityTypes ?? this.activityTypes,
  otherActivity: otherActivity ?? this.otherActivity,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (activityTypes != null) {
      map['activityTypes'] = activityTypes?.map((v) => v.toJson()).toList();
    }
    map['otherActivity'] = otherActivity;
    return map;
  }

}

class Step6 {
  Step6({
      this.otherGastronomy, 
      this.gastronomyTypes, 
      this.restaurantTypes,});

  Step6.fromJson(dynamic json) {
    otherGastronomy = json['otherGastronomy'];
    if (json['gastronomyTypes'] != null) {
      gastronomyTypes = [];
      json['gastronomyTypes'].forEach((v) {
        gastronomyTypes?.add(PersonalizationOptions.fromJson(v));
      });
    }
    if (json['restaurantTypes'] != null) {
      restaurantTypes = [];
      json['restaurantTypes'].forEach((v) {
        restaurantTypes?.add(PersonalizationOptions.fromJson(v));
      });
    }
  }
  String? otherGastronomy;
  List<PersonalizationOptions>? gastronomyTypes;
  List<PersonalizationOptions>? restaurantTypes;
Step6 copyWith({  String? otherGastronomy,
  List<PersonalizationOptions>? gastronomyTypes,
  List<PersonalizationOptions>? restaurantTypes,
}) => Step6(  otherGastronomy: otherGastronomy ?? this.otherGastronomy,
  gastronomyTypes: gastronomyTypes ?? this.gastronomyTypes,
  restaurantTypes: restaurantTypes ?? this.restaurantTypes,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otherGastronomy'] = otherGastronomy;
    if (gastronomyTypes != null) {
      map['gastronomyTypes'] = gastronomyTypes?.map((v) => v.toJson()).toList();
    }
    if (restaurantTypes != null) {
      map['restaurantTypes'] = restaurantTypes?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Step5 {
  Step5({
      this.clotheSize, 
      this.roomTemperature, 
      this.foodPersonalities, 
      this.pescatarianPreference,});

  Step5.fromJson(dynamic json) {
    clotheSize = json['clotheSize'];
    roomTemperature = json['roomTemperature'];
    if (json['foodPersonalities'] != null) {
      foodPersonalities = [];
      json['foodPersonalities'].forEach((v) {
        foodPersonalities?.add(PersonalizationOptions.fromJson(v));
      });
    }
    pescatarianPreference = json['pescatarianPreference'];
  }
  String? clotheSize;
  String? roomTemperature;
  List<PersonalizationOptions>? foodPersonalities;
  String? pescatarianPreference;
Step5 copyWith({  String? clotheSize,
  String? roomTemperature,
  List<PersonalizationOptions>? foodPersonalities,
  String? pescatarianPreference,
}) => Step5(  clotheSize: clotheSize ?? this.clotheSize,
  roomTemperature: roomTemperature ?? this.roomTemperature,
  foodPersonalities: foodPersonalities ?? this.foodPersonalities,
  pescatarianPreference: pescatarianPreference ?? this.pescatarianPreference,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['clotheSize'] = clotheSize;
    map['roomTemperature'] = roomTemperature;
    if (foodPersonalities != null) {
      map['foodPersonalities'] = foodPersonalities?.map((v) => v.toJson()).toList();
    }
    map['pescatarianPreference'] = pescatarianPreference;
    return map;
  }

}

class Step4 {
  Step4({
      this.isSmoker, 
      this.healthProblem, 
      this.allergies, 
      this.hasMobilityProblem, 
      this.footSize,});

  Step4.fromJson(dynamic json) {
    isSmoker = json['isSmoker'];
    healthProblem = json['healthProblem'];
    allergies = json['allergies'] != null ? json['allergies'].cast<String>() : [];
    hasMobilityProblem = json['hasMobilityProblem'];
    footSize = json['footSize'];
  }
  bool? isSmoker;
  String? healthProblem;
  List<String>? allergies;
  bool? hasMobilityProblem;
  String? footSize;
Step4 copyWith({  bool? isSmoker,
  String? healthProblem,
  List<String>? allergies,
  bool? hasMobilityProblem,
  String? footSize,
}) => Step4(  isSmoker: isSmoker ?? this.isSmoker,
  healthProblem: healthProblem ?? this.healthProblem,
  allergies: allergies ?? this.allergies,
  hasMobilityProblem: hasMobilityProblem ?? this.hasMobilityProblem,
  footSize: footSize ?? this.footSize,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isSmoker'] = isSmoker;
    map['healthProblem'] = healthProblem;
    map['allergies'] = allergies;
    map['hasMobilityProblem'] = hasMobilityProblem;
    map['footSize'] = footSize;
    return map;
  }

}

class Step3 {
  Step3({
      this.maritalStatus, 
      this.hasKids, 
      this.kids, 
      this.pets,});

  Step3.fromJson(dynamic json) {
    maritalStatus = json['maritalStatus'];
    hasKids = json['hasKids'];
    kids = json['kids'] != null ? json['kids'].cast<String>() : [];
    pets = json['pets'] != null ? json['pets'].cast<String>() : [];
  }
  int? maritalStatus;
  bool? hasKids;
  List<String>? kids;
  List<String>? pets;
Step3 copyWith({  int? maritalStatus,
  bool? hasKids,
  List<String>? kids,
  List<String>? pets,
}) => Step3(  maritalStatus: maritalStatus ?? this.maritalStatus,
  hasKids: hasKids ?? this.hasKids,
  kids: kids ?? this.kids,
  pets: pets ?? this.pets,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['maritalStatus'] = maritalStatus;
    map['hasKids'] = hasKids;
    map['kids'] = kids;
    map['pets'] = pets;
    return map;
  }

}

class Step2 {
  Step2({
      this.workPosition, 
      this.company, 
      this.isBillingDefault, 
      this.billingCompany, 
      this.billingEmail, 
      this.billingPhone, 
      this.billingAddress,});

  Step2.fromJson(dynamic json) {
    workPosition = json['workPosition'];
    company = json['company'];
    isBillingDefault = json['isBillingDefault'];
    billingCompany = json['billingCompany'];
    billingEmail = json['billingEmail'];
    billingPhone = json['billingPhone'];
    billingAddress = json['billingAddress'];
  }
  String? workPosition;
  String? company;
  bool? isBillingDefault;
  String? billingCompany;
  String? billingEmail;
  String? billingPhone;
  String? billingAddress;
Step2 copyWith({  String? workPosition,
  String? company,
  bool? isBillingDefault,
  String? billingCompany,
  String? billingEmail,
  String? billingPhone,
  String? billingAddress,
}) => Step2(  workPosition: workPosition ?? this.workPosition,
  company: company ?? this.company,
  isBillingDefault: isBillingDefault ?? this.isBillingDefault,
  billingCompany: billingCompany ?? this.billingCompany,
  billingEmail: billingEmail ?? this.billingEmail,
  billingPhone: billingPhone ?? this.billingPhone,
  billingAddress: billingAddress ?? this.billingAddress,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['workPosition'] = workPosition;
    map['company'] = company;
    map['isBillingDefault'] = isBillingDefault;
    map['billingCompany'] = billingCompany;
    map['billingEmail'] = billingEmail;
    map['billingPhone'] = billingPhone;
    map['billingAddress'] = billingAddress;
    return map;
  }

}

class Step1 {
  Step1({
      this.pictureUrl, 
      this.address, 
      this.city, 
      this.country, 
      this.birthDate,});

  Step1.fromJson(dynamic json) {
    pictureUrl = json['pictureUrl'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
    birthDate = json['birthDate'];
  }
  String? pictureUrl;
  String? address;
  String? city;
  String? country;
  String? birthDate;
Step1 copyWith({  String? pictureUrl,
  String? address,
  String? city,
  String? country,
  String? birthDate,
}) => Step1(  pictureUrl: pictureUrl ?? this.pictureUrl,
  address: address ?? this.address,
  city: city ?? this.city,
  country: country ?? this.country,
  birthDate: birthDate ?? this.birthDate,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pictureUrl'] = pictureUrl;
    map['address'] = address;
    map['city'] = city;
    map['country'] = country;
    map['birthDate'] = birthDate;
    return map;
  }

}