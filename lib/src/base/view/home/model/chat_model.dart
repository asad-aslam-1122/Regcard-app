class ChatModel {
  ChatModel({
    this.message,
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.totalRecords,
  });

  ChatModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      message = [];
      json['data'].forEach((v) {
        message?.add(Message.fromJson(v));
      });
    }
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
  }
  List<Message>? message;
  num? pageNumber;
  num? pageSize;
  num? totalPages;
  num? totalRecords;
  ChatModel copyWith({
    List<Message>? message,
    num? pageNumber,
    num? pageSize,
    num? totalPages,
    num? totalRecords,
  }) =>
      ChatModel(
        message: message ?? this.message,
        pageNumber: pageNumber ?? this.pageNumber,
        pageSize: pageSize ?? this.pageSize,
        totalPages: totalPages ?? this.totalPages,
        totalRecords: totalRecords ?? this.totalRecords,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (message != null) {
      map['data'] = message?.map((v) => v.toJson()).toList();
    }
    map['pageNumber'] = pageNumber;
    map['pageSize'] = pageSize;
    map['totalPages'] = totalPages;
    map['totalRecords'] = totalRecords;
    return map;
  }
}

class Message {
  Message({
    this.chatHeadId,
    this.chatId,
    this.messageType,
    this.message,
    this.sender,
    this.sendTime,
    this.latitute,
    this.longitute,
    this.thumbnail,
    this.url,
    this.detail,
    this.name,
    this.size,
    this.extension,
  });

  Message.fromJson(dynamic json) {
    chatHeadId = json['chatHeadId'];
    chatId = json['chatId'];
    messageType = json['messageType'];
    message = json['message'];
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    sendTime = json['sendTime'];
    latitute = json['latitute'];
    longitute = json['longitute'];
    thumbnail = json['thumbnail'];
    url = json['url'];
    detail = json['detail'];
    name = json['name'];
    size = json['size'];
    extension = json['extension'];
  }
  num? chatHeadId;
  num? chatId;
  num? messageType;
  String? message;
  Sender? sender;
  String? sendTime;
  num? latitute;
  num? longitute;
  String? thumbnail;
  String? url;
  String? detail;
  String? name;
  String? size;
  String? extension;
  Message copyWith({
    num? chatHeadId,
    num? chatId,
    num? messageType,
    String? message,
    Sender? sender,
    String? sendTime,
    num? latitute,
    num? longitute,
    String? thumbnail,
    String? url,
    String? detail,
    String? name,
    String? size,
    String? extension,
  }) =>
      Message(
        chatHeadId: chatHeadId ?? this.chatHeadId,
        chatId: chatId ?? this.chatId,
        messageType: messageType ?? this.messageType,
        message: message ?? this.message,
        sender: sender ?? this.sender,
        sendTime: sendTime ?? this.sendTime,
        latitute: latitute ?? this.latitute,
        longitute: longitute ?? this.longitute,
        thumbnail: thumbnail ?? this.thumbnail,
        url: url ?? this.url,
        detail: detail ?? this.detail,
        name: name ?? this.name,
        size: size ?? this.size,
        extension: extension ?? this.extension,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['chatHeadId'] = chatHeadId;
    map['chatId'] = chatId;
    map['messageType'] = messageType;
    map['message'] = message;
    if (sender != null) {
      map['sender'] = sender?.toJson();
    }
    map['sendTime'] = sendTime;
    map['latitute'] = latitute;
    map['longitute'] = longitute;
    map['thumbnail'] = thumbnail;
    map['url'] = url;
    map['detail'] = detail;
    map['name'] = name;
    map['size'] = size;
    map['extension'] = extension;
    return map;
  }
}

class Sender {
  Sender({
    this.id,
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
    this.isBlocked,
  });

  Sender.fromJson(dynamic json) {
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
    isBlocked = json['isBlocked'];
  }
  String? id;
  String? title;
  String? firstName;
  String? lastName;
  String? fullName;
  String? email;
  String? pictureUrl;
  String? phoneNumber;
  String? workPosition;
  String? company;
  bool? isRequestSent;
  bool? isBlocked;
  Sender copyWith({
    String? id,
    String? title,
    String? firstName,
    String? lastName,
    String? fullName,
    String? email,
    String? pictureUrl,
    String? phoneNumber,
    String? workPosition,
    String? company,
    bool? isRequestSent,
    bool? isBlocked,
  }) =>
      Sender(
        id: id ?? this.id,
        title: title ?? this.title,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        pictureUrl: pictureUrl ?? this.pictureUrl,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        workPosition: workPosition ?? this.workPosition,
        company: company ?? this.company,
        isRequestSent: isRequestSent ?? this.isRequestSent,
        isBlocked: isBlocked ?? this.isBlocked,
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
    map['isRequestSent'] = isRequestSent;
    map['isBlocked'] = isBlocked;
    return map;
  }
}
