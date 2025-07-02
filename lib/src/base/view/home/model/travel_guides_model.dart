class TravelGuidesModel {
  TravelGuidesModel({
      this.travelItems,
      this.currentPage, 
      this.totalPages, 
      this.pageSize, 
      this.totalTravelGuidesItems, 
      this.hasPrevious, 
      this.hasNext,});

  TravelGuidesModel.fromJson(dynamic json) {
    if (json['items'] != null) {
      travelItems = [];
      json['items'].forEach((v) {
        travelItems?.add(TravelGuidesItems.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalTravelGuidesItems = json['totalTravelGuidesItems'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
  }
  List<TravelGuidesItems>? travelItems;
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalTravelGuidesItems;
  bool? hasPrevious;
  bool? hasNext;
TravelGuidesModel copyWith({  List<TravelGuidesItems>? items,
  int? currentPage,
  int? totalPages,
  int? pageSize,
  int? totalTravelGuidesItems,
  bool? hasPrevious,
  bool? hasNext,
}) => TravelGuidesModel(  travelItems: items ?? travelItems,
  currentPage: currentPage ?? this.currentPage,
  totalPages: totalPages ?? this.totalPages,
  pageSize: pageSize ?? this.pageSize,
  totalTravelGuidesItems: totalTravelGuidesItems ?? this.totalTravelGuidesItems,
  hasPrevious: hasPrevious ?? this.hasPrevious,
  hasNext: hasNext ?? this.hasNext,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (travelItems != null) {
      map['items'] = travelItems?.map((v) => v.toJson()).toList();
    }
    map['currentPage'] = currentPage;
    map['totalPages'] = totalPages;
    map['pageSize'] = pageSize;
    map['totalTravelGuidesItems'] = totalTravelGuidesItems;
    map['hasPrevious'] = hasPrevious;
    map['hasNext'] = hasNext;
    return map;
  }

}

class TravelGuidesItems {
  TravelGuidesItems({
      this.title, 
      this.blogUrl, 
      this.thumbnailUrl, 
      this.createdAt, 
      this.lastModifiedAt, 
      this.id,});

  TravelGuidesItems.fromJson(dynamic json) {
    title = json['title'];
    blogUrl = json['blogUrl'];
    thumbnailUrl = json['thumbnailUrl'];
    createdAt = json['createdAt'];
    lastModifiedAt = json['lastModifiedAt'];
    id = json['id'];
  }
  String? title;
  String? blogUrl;
  String? thumbnailUrl;
  String? createdAt;
  String? lastModifiedAt;
  int? id;
TravelGuidesItems copyWith({  String? title,
  String? blogUrl,
  String? thumbnailUrl,
  String? createdAt,
  String? lastModifiedAt,
  int? id,
}) => TravelGuidesItems(  title: title ?? this.title,
  blogUrl: blogUrl ?? this.blogUrl,
  thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
  createdAt: createdAt ?? this.createdAt,
  lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
  id: id ?? this.id,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['blogUrl'] = blogUrl;
    map['thumbnailUrl'] = thumbnailUrl;
    map['createdAt'] = createdAt;
    map['lastModifiedAt'] = lastModifiedAt;
    map['id'] = id;
    return map;
  }

}