class UserProfile {
  UserProfile({
    this.id,
    this.email,
    this.pictureUrl,
    this.loginRole,
    this.fcmToken,
    this.timeZoneId,
    this.isChatReplies,
    this.isConnectionRequest,
    this.isNewsArticleUploaded,
    this.isSharingHistory,
    this.isRequiresSharingRequestConfirmation,
    this.isShareRegCard,
    this.isRegCardFirstShare,
    this.totalScanCount,
    this.isBlocked,
    this.profileStep,
    this.title,
    this.firstName,
    this.lastName,
    this.fullName,
    this.phoneNumber,
    this.address,
    this.city,
    this.country,
    this.birthDate,
    this.workPosition,
    this.company,
    this.isBillingDefault,
    this.billingCompany,
    this.billingEmail,
    this.billingPhone,
    this.billingAddress,
    this.unReadNotification,
    this.unReadChat,
  });

  UserProfile.fromJson(dynamic json) {
    id = json['id'];
    email = json['email'];
    pictureUrl = json['pictureUrl'];
    loginRole = json['loginRole'];
    fcmToken = json['fcmToken'];
    timeZoneId = json['timeZoneId'];
    isChatReplies = json['isChatReplies'];
    isConnectionRequest = json['isConnectionRequest'];
    isNewsArticleUploaded = json['isNewsArticleUploaded'];
    isSharingHistory = json['isSharingHistory'];
    isRequiresSharingRequestConfirmation =
        json['isRequiresSharingRequestConfirmation'];
    isShareRegCard = json['isShareRegCard'];
    isRegCardFirstShare = json['isRegCardFirstShare'];
    totalScanCount = json['totalScanCount'];
    isBlocked = json['isBlocked'];
    profileStep = json['profileStep'];
    title = json['title'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
    birthDate = json['birthDate'];
    workPosition = json['workPosition'];
    company = json['company'];
    isBillingDefault = json['isBillingDefault'];
    billingCompany = json['billingCompany'];
    billingEmail = json['billingEmail'];
    billingPhone = json['billingPhone'];
    billingAddress = json['billingAddress'];
    unReadNotification = json['unReadNotification'];
    unReadChat = json['unReadChat'];
  }
  String? id;
  String? email;
  String? pictureUrl;
  num? loginRole;
  String? fcmToken;
  String? timeZoneId;
  bool? isChatReplies;
  bool? isConnectionRequest;
  bool? isNewsArticleUploaded;
  bool? isSharingHistory;
  bool? isRequiresSharingRequestConfirmation;
  bool? isShareRegCard;
  bool? isRegCardFirstShare;
  num? totalScanCount;
  bool? isBlocked;
  num? profileStep;
  String? title;
  String? firstName;
  String? lastName;
  String? fullName;
  String? phoneNumber;
  String? address;
  String? city;
  String? country;
  String? birthDate;
  String? workPosition;
  String? company;
  bool? isBillingDefault;
  String? billingCompany;
  String? billingEmail;
  String? billingPhone;
  String? billingAddress;
  num? unReadNotification;
  num? unReadChat;
  UserProfile copyWith({
    String? id,
    String? email,
    String? pictureUrl,
    num? loginRole,
    String? fcmToken,
    String? timeZoneId,
    bool? isChatReplies,
    bool? isConnectionRequest,
    bool? isNewsArticleUploaded,
    bool? isSharingHistory,
    bool? isRequiresSharingRequestConfirmation,
    bool? isShareRegCard,
    bool? isRegCardFirstShare,
    num? totalScanCount,
    bool? isBlocked,
    num? profileStep,
    String? title,
    String? firstName,
    String? lastName,
    String? fullName,
    String? phoneNumber,
    String? address,
    String? city,
    String? country,
    String? birthDate,
    String? workPosition,
    String? company,
    bool? isBillingDefault,
    String? billingCompany,
    String? billingEmail,
    String? billingPhone,
    String? billingAddress,
    num? unReadNotification,
    num? unReadChat,
  }) =>
      UserProfile(
        id: id ?? this.id,
        email: email ?? this.email,
        pictureUrl: pictureUrl ?? this.pictureUrl,
        loginRole: loginRole ?? this.loginRole,
        fcmToken: fcmToken ?? this.fcmToken,
        timeZoneId: timeZoneId ?? this.timeZoneId,
        isChatReplies: isChatReplies ?? this.isChatReplies,
        isConnectionRequest: isConnectionRequest ?? this.isConnectionRequest,
        isNewsArticleUploaded:
            isNewsArticleUploaded ?? this.isNewsArticleUploaded,
        isSharingHistory: isSharingHistory ?? this.isSharingHistory,
        isRequiresSharingRequestConfirmation:
            isRequiresSharingRequestConfirmation ??
                this.isRequiresSharingRequestConfirmation,
        isShareRegCard: isShareRegCard ?? this.isShareRegCard,
        isRegCardFirstShare: isRegCardFirstShare ?? this.isRegCardFirstShare,
        totalScanCount: totalScanCount ?? this.totalScanCount,
        isBlocked: isBlocked ?? this.isBlocked,
        profileStep: profileStep ?? this.profileStep,
        title: title ?? this.title,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        fullName: fullName ?? this.fullName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address ?? this.address,
        city: city ?? this.city,
        country: country ?? this.country,
        birthDate: birthDate ?? this.birthDate,
        workPosition: workPosition ?? this.workPosition,
        company: company ?? this.company,
        isBillingDefault: isBillingDefault ?? this.isBillingDefault,
        billingCompany: billingCompany ?? this.billingCompany,
        billingEmail: billingEmail ?? this.billingEmail,
        billingPhone: billingPhone ?? this.billingPhone,
        billingAddress: billingAddress ?? this.billingAddress,
        unReadNotification: unReadNotification ?? this.unReadNotification,
        unReadChat: unReadChat ?? this.unReadChat,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['email'] = email;
    map['pictureUrl'] = pictureUrl;
    map['loginRole'] = loginRole;
    map['fcmToken'] = fcmToken;
    map['timeZoneId'] = timeZoneId;
    map['isChatReplies'] = isChatReplies;
    map['isConnectionRequest'] = isConnectionRequest;
    map['isNewsArticleUploaded'] = isNewsArticleUploaded;
    map['isSharingHistory'] = isSharingHistory;
    map['isRequiresSharingRequestConfirmation'] =
        isRequiresSharingRequestConfirmation;
    map['isShareRegCard'] = isShareRegCard;
    map['isRegCardFirstShare'] = isRegCardFirstShare;
    map['totalScanCount'] = totalScanCount;
    map['isBlocked'] = isBlocked;
    map['profileStep'] = profileStep;
    map['title'] = title;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['fullName'] = fullName;
    map['phoneNumber'] = phoneNumber;
    map['address'] = address;
    map['city'] = city;
    map['country'] = country;
    map['birthDate'] = birthDate;
    map['workPosition'] = workPosition;
    map['company'] = company;
    map['isBillingDefault'] = isBillingDefault;
    map['billingCompany'] = billingCompany;
    map['billingEmail'] = billingEmail;
    map['billingPhone'] = billingPhone;
    map['billingAddress'] = billingAddress;
    map['unReadNotification'] = unReadNotification;
    map['unReadChat'] = unReadChat;
    return map;
  }
}
