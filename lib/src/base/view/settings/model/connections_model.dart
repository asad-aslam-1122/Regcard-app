import 'package:regcard/src/base/view/home/model/chat_model.dart';

class ConnectionsModel {
  ConnectionsModel({
    this.connectionsItems,
    this.currentPage,
    this.totalPages,
    this.pageSize,
    this.totalItems,
    this.hasPrevious,
    this.hasNext,
  });

  ConnectionsModel.fromJson(dynamic json) {
    if (json['items'] != null) {
      connectionsItems = [];
      json['items'].forEach((v) {
        connectionsItems?.add(ConnectionsItems.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalItems = json['totalItems'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
  }
  List<ConnectionsItems>? connectionsItems;
  int? currentPage;
  num? totalPages;
  num? pageSize;
  num? totalItems;
  bool? hasPrevious;
  bool? hasNext;
  ConnectionsModel copyWith({
    List<ConnectionsItems>? connectionsItems,
    int? currentPage,
    num? totalPages,
    num? pageSize,
    num? totalItems,
    bool? hasPrevious,
    bool? hasNext,
  }) =>
      ConnectionsModel(
        connectionsItems: connectionsItems ?? this.connectionsItems,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        pageSize: pageSize ?? this.pageSize,
        totalItems: totalItems ?? this.totalItems,
        hasPrevious: hasPrevious ?? this.hasPrevious,
        hasNext: hasNext ?? this.hasNext,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (connectionsItems != null) {
      map['items'] = connectionsItems?.map((v) => v.toJson()).toList();
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

class ConnectionsItems {
  ConnectionsItems({
    this.id,
    this.requestByUser,
    this.requestToUser,
    this.status,
    this.requestedAt,
    this.isRequestInitiatedBy,
  });

  ConnectionsItems.fromJson(dynamic json) {
    id = json['id'];
    requestByUser = json['requestByUser'] != null
        ? Sender.fromJson(json['requestByUser'])
        : null;
    requestToUser = json['requestToUser'] != null
        ? Sender.fromJson(json['requestToUser'])
        : null;
    status = json['status'];
    requestedAt = json['requestedAt'];
    isRequestInitiatedBy = json['isRequestInitiatedBy'];
  }
  num? id;
  Sender? requestByUser;
  Sender? requestToUser;
  num? status;
  String? requestedAt;
  bool? isRequestInitiatedBy;
  ConnectionsItems copyWith({
    num? id,
    Sender? requestByUser,
    Sender? requestToUser,
    num? status,
    String? requestedAt,
    bool? isRequestInitiatedBy,
  }) =>
      ConnectionsItems(
        id: id ?? this.id,
        requestByUser: requestByUser ?? this.requestByUser,
        requestToUser: requestToUser ?? this.requestToUser,
        status: status ?? this.status,
        requestedAt: requestedAt ?? this.requestedAt,
        isRequestInitiatedBy: isRequestInitiatedBy ?? this.isRequestInitiatedBy,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (requestByUser != null) {
      map['requestByUser'] = requestByUser?.toJson();
    }
    if (requestToUser != null) {
      map['requestToUser'] = requestToUser?.toJson();
    }
    map['status'] = status;
    map['requestedAt'] = requestedAt;
    map['isRequestInitiatedBy'] = isRequestInitiatedBy;
    return map;
  }
}
