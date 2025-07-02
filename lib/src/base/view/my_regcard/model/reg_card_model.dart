class RegCardModel {
  RegCardModel({
    this.regCardItems,
    this.currentPage,
    this.totalPages,
    this.pageSize,
    this.totalItems,
    this.hasPrevious,
    this.hasNext,
  });

  RegCardModel.fromJson(dynamic json) {
    if (json['items'] != null) {
      regCardItems = [];
      json['items'].forEach((v) {
        regCardItems?.add(RegCardItems.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalItems = json['totalItems'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
  }
  List<RegCardItems>? regCardItems;
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalItems;
  bool? hasPrevious;
  bool? hasNext;
  RegCardModel copyWith({
    List<RegCardItems>? regCardItems,
    int? currentPage,
    int? totalPages,
    int? pageSize,
    int? totalItems,
    bool? hasPrevious,
    bool? hasNext,
  }) =>
      RegCardModel(
        regCardItems: regCardItems ?? this.regCardItems,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        pageSize: pageSize ?? this.pageSize,
        totalItems: totalItems ?? this.totalItems,
        hasPrevious: hasPrevious ?? this.hasPrevious,
        hasNext: hasNext ?? this.hasNext,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (regCardItems != null) {
      map['items'] = regCardItems?.map((v) => v.toJson()).toList();
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

class RegCardItems {
  RegCardItems({
    this.id,
    this.title,
    this.isActive,
    this.createdAt,
    this.sharableMyQR,
    this.isQRFirstShare,
    this.durationId,
    this.shareCount,
    this.views,
    this.url,
    this.history,
  });

  RegCardItems.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    sharableMyQR = json['sharableMyQR'];
    isQRFirstShare = json['isQRFirstShare'];
    durationId = json['durationId'];
    shareCount = json['shareCount'];
    views = json['views'];
    url = json['url'];
    if (json['history'] != null) {
      history = [];
      json['history'].forEach((v) {
        history?.add(History.fromJson(v));
      });
    }
  }
  int? id;
  String? title;
  bool? isActive;
  String? createdAt;
  bool? sharableMyQR;
  bool? isQRFirstShare;
  int? durationId;
  int? shareCount;
  int? views;
  String? url;
  List<History>? history;
  RegCardItems copyWith({
    int? id,
    String? title,
    bool? isActive,
    String? createdAt,
    bool? sharableMyQR,
    bool? isQRFirstShare,
    int? durationId,
    int? shareCount,
    int? views,
    String? url,
    List<History>? history,
  }) =>
      RegCardItems(
        id: id ?? this.id,
        title: title ?? this.title,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        sharableMyQR: sharableMyQR ?? this.sharableMyQR,
        isQRFirstShare: isQRFirstShare ?? this.isQRFirstShare,
        durationId: durationId ?? this.durationId,
        shareCount: shareCount ?? this.shareCount,
        views: views ?? this.views,
        url: url ?? this.url,
        history: history ?? this.history,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['isActive'] = isActive;
    map['createdAt'] = createdAt;
    map['sharableMyQR'] = sharableMyQR;
    map['isQRFirstShare'] = isQRFirstShare;
    map['durationId'] = durationId;
    map['shareCount'] = shareCount;
    map['views'] = views;
    map['url'] = url;
    if (history != null) {
      map['history'] = history?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class History {
  History({
    this.shareDate,
    this.shareTime,
    this.durationId,
  });

  History.fromJson(dynamic json) {
    shareDate = json['shareDate'];
    shareTime = json['shareTime'];
    durationId = json['durationId'];
  }
  String? shareDate;
  String? shareTime;
  int? durationId;
  History copyWith({
    String? shareDate,
    String? shareTime,
    int? durationId,
  }) =>
      History(
        shareDate: shareDate ?? this.shareDate,
        shareTime: shareTime ?? this.shareTime,
        durationId: durationId ?? this.durationId,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['shareDate'] = shareDate;
    map['shareTime'] = shareTime;
    map['durationId'] = durationId;
    return map;
  }
}
