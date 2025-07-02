class RecordsModel {
  RecordsModel({
      this.items, 
      this.currentPage, 
      this.totalPages, 
      this.pageSize, 
      this.totalRecordsItems,
      this.hasPrevious,
      this.hasNext,});

  RecordsModel.fromJson(dynamic json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(RecordsItems.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalRecordsItems = json['totalRecordsItems'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
  }
  List<RecordsItems>? items;
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalRecordsItems;
  bool? hasPrevious;
  bool? hasNext;
RecordsModel copyWith({  List<RecordsItems>? items,
  int? currentPage,
  int? totalPages,
  int? pageSize,
  int? totalRecordsItems,
  bool? hasPrevious,
  bool? hasNext,
}) => RecordsModel(  items: items ?? this.items,
  currentPage: currentPage ?? this.currentPage,
  totalPages: totalPages ?? this.totalPages,
  pageSize: pageSize ?? this.pageSize,
  totalRecordsItems: totalRecordsItems ?? this.totalRecordsItems,
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
    map['totalRecordsItems'] = totalRecordsItems;
    map['hasPrevious'] = hasPrevious;
    map['hasNext'] = hasNext;
    return map;
  }

}

class RecordsItems {
  RecordsItems({
      this.name,
      this.recordUrl,
      this.id,});

  RecordsItems.fromJson(dynamic json) {
    name = json['name'];
    recordUrl = json['recordUrl'];
    id = json['id'];
  }
  String? name;
  String? recordUrl;
  int? id;
RecordsItems copyWith({  String? name,
  String? recordUrl,
  int? id,
}) => RecordsItems(  name: name ?? this.name,
  recordUrl: recordUrl ?? this.recordUrl,
  id: id ?? this.id,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['recordUrl'] = recordUrl;
    map['id'] = id;
    return map;
  }

}