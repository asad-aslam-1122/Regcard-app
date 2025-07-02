import 'chat_model.dart';

class ChatHeadModel {
  ChatHeadModel({
    this.chatHead,
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.totalRecords,
  });

  ChatHeadModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      chatHead = [];
      json['data'].forEach((v) {
        chatHead?.add(ChatHead.fromJson(v));
      });
    }
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
  }
  List<ChatHead>? chatHead;
  num? pageNumber;
  num? pageSize;
  num? totalPages;
  num? totalRecords;
  ChatHeadModel copyWith({
    List<ChatHead>? chatHead,
    num? pageNumber,
    num? pageSize,
    num? totalPages,
    num? totalRecords,
  }) =>
      ChatHeadModel(
        chatHead: chatHead ?? this.chatHead,
        pageNumber: pageNumber ?? this.pageNumber,
        pageSize: pageSize ?? this.pageSize,
        totalPages: totalPages ?? this.totalPages,
        totalRecords: totalRecords ?? this.totalRecords,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (chatHead != null) {
      map['data'] = chatHead?.map((v) => v.toJson()).toList();
    }
    map['pageNumber'] = pageNumber;
    map['pageSize'] = pageSize;
    map['totalPages'] = totalPages;
    map['totalRecords'] = totalRecords;
    return map;
  }
}

class ChatHead {
  ChatHead({
    this.chatHeadId,
    this.type,
    this.lastMsg,
    this.users,
  });

  ChatHead.fromJson(dynamic json) {
    chatHeadId = json['chatHeadId'];
    type = json['type'];
    lastMsg =
        json['lastMsg'] != null ? Message.fromJson(json['lastMsg']) : null;
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users?.add(Sender.fromJson(v));
      });
    }
  }
  num? chatHeadId;
  num? type;
  Message? lastMsg;
  List<Sender>? users;
  ChatHead copyWith({
    num? chatHeadId,
    num? type,
    Message? lastMsg,
    List<Sender>? users,
  }) =>
      ChatHead(
        chatHeadId: chatHeadId ?? this.chatHeadId,
        type: type ?? this.type,
        lastMsg: lastMsg ?? this.lastMsg,
        users: users ?? this.users,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['chatHeadId'] = chatHeadId;
    map['type'] = type;
    if (lastMsg != null) {
      map['lastMsg'] = lastMsg?.toJson();
    }
    if (users != null) {
      map['users'] = users?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
