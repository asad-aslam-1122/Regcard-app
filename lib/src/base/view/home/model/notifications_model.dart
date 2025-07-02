class NotificationModel {
  NotificationModel({
      this.items, 
      this.currentPage, 
      this.totalPages, 
      this.pageSize, 
      this.totalItems, 
      this.hasPrevious, 
      this.hasNext,});

  NotificationModel.fromJson(dynamic json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(NotificationItems.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalItems = json['totalItems'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
  }
  List<NotificationItems>? items;
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalItems;
  bool? hasPrevious;
  bool? hasNext;
NotificationModel copyWith({  List<NotificationItems>? items,
  int? currentPage,
  int? totalPages,
  int? pageSize,
  int? totalItems,
  bool? hasPrevious,
  bool? hasNext,
}) => NotificationModel(  items: items ?? this.items,
  currentPage: currentPage ?? this.currentPage,
  totalPages: totalPages ?? this.totalPages,
  pageSize: pageSize ?? this.pageSize,
  totalItems: totalItems ?? this.totalItems,
  hasPrevious: hasPrevious ?? this.hasPrevious,
  hasNext: hasNext ?? this.hasNext,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
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

class NotificationItems {
  NotificationItems({
      this.description, 
      this.createdAt, 
      this.notifiedById, 
      this.notificationType, 
      this.redirectId, 
      this.isRead, 
      this.id,});

  NotificationItems.fromJson(dynamic json) {
    description = json['description'];
    createdAt = json['createdAt'];
    notifiedById = json['notifiedById'];
    notificationType = json['notificationType'];
    redirectId = json['redirectId'];
    isRead = json['isRead'];
    id = json['id'];
  }
  String? description;
  String? createdAt;
  String? notifiedById;
  int? notificationType;
  int? redirectId;
  bool? isRead;
  int? id;
NotificationItems copyWith({  String? description,
  String? createdAt,
  String? notifiedById,
  int? notificationType,
  int? redirectId,
  bool? isRead,
  int? id,
}) => NotificationItems(  description: description ?? this.description,
  createdAt: createdAt ?? this.createdAt,
  notifiedById: notifiedById ?? this.notifiedById,
  notificationType: notificationType ?? this.notificationType,
  redirectId: redirectId ?? this.redirectId,
  isRead: isRead ?? this.isRead,
  id: id ?? this.id,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = description;
    map['createdAt'] = createdAt;
    map['notifiedById'] = notifiedById;
    map['notificationType'] = notificationType;
    map['redirectId'] = redirectId;
    map['isRead'] = isRead;
    map['id'] = id;
    return map;
  }

}