import 'dart:io';

import 'package:flutter/cupertino.dart';

class SplitPaymentModel {
  SplitPaymentModel({
    this.splitPaymentItems,
    this.currentPage,
    this.totalPages,
    this.pageSize,
    this.totalItems,
    this.hasPrevious,
    this.hasNext,
  });

  SplitPaymentModel.fromJson(dynamic json) {
    if (json['items'] != null) {
      splitPaymentItems = [];
      json['items'].forEach((v) {
        splitPaymentItems?.add(SplitPaymentItems.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalItems = json['totalItems'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
  }
  List<SplitPaymentItems>? splitPaymentItems;
  num? currentPage;
  num? totalPages;
  num? pageSize;
  num? totalItems;
  bool? hasPrevious;
  bool? hasNext;
  SplitPaymentModel copyWith({
    List<SplitPaymentItems>? splitPaymentItems,
    num? currentPage,
    num? totalPages,
    num? pageSize,
    num? totalItems,
    bool? hasPrevious,
    bool? hasNext,
  }) =>
      SplitPaymentModel(
        splitPaymentItems: splitPaymentItems ?? this.splitPaymentItems,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        pageSize: pageSize ?? this.pageSize,
        totalItems: totalItems ?? this.totalItems,
        hasPrevious: hasPrevious ?? this.hasPrevious,
        hasNext: hasNext ?? this.hasNext,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (splitPaymentItems != null) {
      map['items'] = splitPaymentItems?.map((v) => v.toJson()).toList();
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

class SplitPaymentItems {
  SplitPaymentItems({
    this.id,
    this.title,
    this.totalAmount,
    this.date,
    this.createdAt,
    this.paymentStatus,
    this.createdByUserId,
    this.mediaFiles,
    this.selectedFile,
    this.participants,
  });

  SplitPaymentItems.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    totalAmount = json['totalAmount'];
    date = json['date'];
    createdAt = json['createdAt'];
    paymentStatus = json['paymentStatus'];
    createdByUserId = json['createdByUserId'];
    if (json['mediaFiles'] != null) {
      mediaFiles = [];
      json['mediaFiles'].forEach((v) {
        mediaFiles?.add(MediaFiles.fromJson(v));
      });
    }
    if (json['participants'] != null) {
      participants = [];
      json['participants'].forEach((v) {
        participants?.add(Participants.fromJson(v));
      });
    }
  }
  num? id;
  String? title;
  double? totalAmount;
  String? date;
  String? createdAt;
  num? paymentStatus;
  String? createdByUserId;
  List<MediaFiles>? mediaFiles;
  File? selectedFile;
  List<Participants>? participants;
  SplitPaymentItems copyWith({
    num? id,
    String? title,
    double? totalAmount,
    String? date,
    String? createdAt,
    num? paymentStatus,
    String? createdByUserId,
    List<MediaFiles>? mediaFiles,
    File? selectedFile,
    List<Participants>? participants,
  }) =>
      SplitPaymentItems(
        id: id ?? this.id,
        title: title ?? this.title,
        totalAmount: totalAmount ?? this.totalAmount,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        createdByUserId: createdByUserId ?? this.createdByUserId,
        mediaFiles: mediaFiles ?? this.mediaFiles,
        participants: participants ?? this.participants,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['totalAmount'] = totalAmount;
    map['date'] = date;
    map['createdAt'] = createdAt;
    map['paymentStatus'] = paymentStatus;
    map['createdByUserId'] = createdByUserId;
    if (mediaFiles != null) {
      map['mediaFiles'] = mediaFiles?.map((v) => v.toJson()).toList();
    }
    if (participants != null) {
      map['participants'] = participants?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Participants {
  Participants({
    this.contributionAmount,
    this.controller,
    this.percentage,
    this.paymentStatus,
    this.pictureUrl,
    this.fullName,
    this.isPaid,
    this.userId,
  });

  Participants.fromJson(dynamic json) {
    contributionAmount = json['contributionAmount'];
    paymentStatus = json['paymentStatus'];
    pictureUrl = json['pictureUrl'];
    fullName = json['fullName'];
    isPaid = json['isPaid'];
    userId = json['userId'];
  }
  double? contributionAmount;
  TextEditingController? controller;
  double? percentage;
  num? paymentStatus;
  String? pictureUrl;
  String? fullName;
  bool? isPaid;
  String? userId;
  Participants copyWith({
    double? contributionAmount,
    TextEditingController? controller,
    double? percentage,
    num? paymentStatus,
    String? pictureUrl,
    String? fullName,
    bool? isPaid,
    String? userId,
  }) =>
      Participants(
        contributionAmount: contributionAmount ?? this.contributionAmount,
        controller: controller ?? this.controller,
        percentage: percentage ?? this.percentage,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        pictureUrl: pictureUrl ?? this.pictureUrl,
        fullName: fullName ?? this.fullName,
        isPaid: isPaid ?? this.isPaid,
        userId: userId ?? this.userId,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['contributionAmount'] = contributionAmount;
    map['paymentStatus'] = paymentStatus;
    map['pictureUrl'] = pictureUrl;
    map['fullName'] = fullName;
    map['isPaid'] = isPaid;
    map['userId'] = userId;
    return map;
  }
}

class MediaFiles {
  MediaFiles({
    this.fileName,
    this.fileUrl,
    this.fileExtension,
    this.fileSize,
    this.fileType,
  });

  MediaFiles.fromJson(dynamic json) {
    fileName = json['fileName'];
    fileUrl = json['fileUrl'];
    fileExtension = json['fileExtension'];
    fileSize = json['fileSize'];
    fileType = json['fileType'];
  }
  String? fileName;
  String? fileUrl;
  String? fileExtension;
  num? fileSize;
  num? fileType;
  MediaFiles copyWith({
    String? fileName,
    String? fileUrl,
    String? fileExtension,
    num? fileSize,
    num? fileType,
  }) =>
      MediaFiles(
        fileName: fileName ?? this.fileName,
        fileUrl: fileUrl ?? this.fileUrl,
        fileExtension: fileExtension ?? this.fileExtension,
        fileSize: fileSize ?? this.fileSize,
        fileType: fileType ?? this.fileType,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fileName'] = fileName;
    map['fileUrl'] = fileUrl;
    map['fileExtension'] = fileExtension;
    map['fileSize'] = fileSize;
    map['fileType'] = fileType;
    return map;
  }
}
