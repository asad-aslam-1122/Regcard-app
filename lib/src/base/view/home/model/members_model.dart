class MembersModel {
  MembersModel({
    this.membersItems,
    this.currentPage,
    this.totalPages,
    this.pageSize,
    this.totalItems,
    this.hasPrevious,
    this.hasNext,
  });

  MembersModel.fromJson(dynamic json) {
    if (json['items'] != null) {
      membersItems = [];
      json['items'].forEach((v) {
        membersItems?.add(MembersItems.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalItems = json['totalItems'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
  }
  List<MembersItems>? membersItems;
  int? currentPage;
  num? totalPages;
  num? pageSize;
  num? totalItems;
  bool? hasPrevious;
  bool? hasNext;
  MembersModel copyWith({
    List<MembersItems>? membersItems,
    int? currentPage,
    num? totalPages,
    num? pageSize,
    num? totalItems,
    bool? hasPrevious,
    bool? hasNext,
  }) =>
      MembersModel(
        membersItems: membersItems ?? this.membersItems,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        pageSize: pageSize ?? this.pageSize,
        totalItems: totalItems ?? this.totalItems,
        hasPrevious: hasPrevious ?? this.hasPrevious,
        hasNext: hasNext ?? this.hasNext,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (membersItems != null) {
      map['items'] = membersItems?.map((v) => v.toJson()).toList();
    }
    map['currentPage'] = currentPage;
    map['totalPages'] = totalPages;
    map['pageSize'] = pageSize;
    map['totalItems'] = totalItems;
    map['hasPrevious'] = hasPrevious;
    map['hasNext'] = hasNext;
    return map;
  }
}

class MembersItems {
  MembersItems(
      {this.id,
      this.title,
      this.firstName,
      this.lastName,
      this.fullName,
      this.email,
      this.pictureUrl,
      this.phoneNumber,
      this.workPosition,
      this.company,
      this.isRequestSent,
      this.country,
      this.city,
      this.isPaid,
      this.amount,
      this.percentage});

  MembersItems.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    fullName = json['fullName'];
    email = json['email'];
    pictureUrl = json['pictureUrl'];
    phoneNumber = json['phoneNumber'];
    workPosition = json['workPosition'];
    company = json['company'];
    isRequestSent = json['isRequestSent'];
    country = json['location']['country'];
    city = json['location']['city'];
  }
  String? id;
  String? title;
  String? country;
  String? city;
  String? firstName;
  String? lastName;
  String? fullName;
  String? email;
  String? pictureUrl;
  String? phoneNumber;
  String? workPosition;
  String? company;
  bool? isRequestSent;
  bool? isPaid;
  double? amount;
  double? percentage;
  MembersItems copyWith({
    String? id,
    String? title,
    String? firstName,
    String? lastName,
    String? fullName,
    String? email,
    String? pictureUrl,
    String? phoneNumber,
    String? workPosition,
    String? country,
    String? city,
    String? company,
    bool? isRequestSent,
    bool? isPaid,
    double? amount,
    double? percentage,
  }) =>
      MembersItems(
        id: id ?? this.id,
        title: title ?? this.title,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        pictureUrl: pictureUrl ?? this.pictureUrl,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        workPosition: workPosition ?? this.workPosition,
        country: country ?? this.country,
        city: city ?? this.city,
        company: company ?? this.company,
        isRequestSent: isRequestSent ?? this.isRequestSent,
        isPaid: isPaid ?? this.isPaid,
        amount: amount ?? this.amount,
        percentage: percentage ?? this.percentage,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['fullName'] = fullName;
    map['email'] = email;
    map['pictureUrl'] = pictureUrl;
    map['phoneNumber'] = phoneNumber;
    map['workPosition'] = workPosition;
    map['company'] = company;
    map['country'] = country;
    map['city'] = city;
    map['isRequestSent'] = isRequestSent;
    return map;
  }
}
