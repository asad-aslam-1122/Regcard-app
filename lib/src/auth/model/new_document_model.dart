import 'package:regcard/constant/enums.dart';

class NewDocumentModel {
  NewDocumentModel({
      this.id, 
      this.documentType, 
      this.name, 
      this.documentUrl, 
      this.familyMember,});

  NewDocumentModel.fromJson(dynamic json) {
    id = json['id'];
    documentType = DocumentType.values[json['documentType']];
    name = json['name'];
    documentUrl = json['documentUrl'];
    familyMember = json['familyMember'];
  }
  int? id;
  DocumentType? documentType;
  String? name;
  String? documentUrl;
  String? familyMember;
NewDocumentModel copyWith({  int? id,
  DocumentType? documentType,
  String? name,
  String? documentUrl,
  String? familyMember,
}) => NewDocumentModel(  id: id ?? this.id,
  documentType: documentType ?? this.documentType,
  name: name ?? this.name,
  documentUrl: documentUrl ?? this.documentUrl,
  familyMember: familyMember ?? this.familyMember,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['documentType'] = documentType?.index??0;
    map['name'] = name;
    map['documentUrl'] = documentUrl;
    map['familyMember'] = familyMember;
    return map;
  }

}



// List<NewDocumentModel> docList = [
//   NewDocumentModel(
//     id: 1,
//     documentType: DocumentType.familyDocuments,
//     name: 'Document 1',
//     documentUrl: "https://reg-card.assortcloud.com/Uploads/Images/1_638454898982170109.png",
//     familyMember: 'Family Member 1',
//   ),
//   NewDocumentModel(
//     id: 2,
//     documentType: DocumentType.familyDocuments,
//     name: 'Document 2',
//     documentUrl: "https://reg-card.assortcloud.com/Uploads/Images/1_638454898982170109.png",
//     familyMember: 'Family Member 2',
//   ),
//   NewDocumentModel(
//     id: 8,
//     documentType: DocumentType.familyDocuments,
//     name: 'Document 21',
//     documentUrl: "https://reg-card.assortcloud.com/Uploads/Images/1_638454898982170109.png",
//     familyMember: 'Family Member 2',
//   ),
//   NewDocumentModel(
//     id: 3,
//     documentType: DocumentType.myDocuments,
//     name: 'Document 3',
//     documentUrl: "https://reg-card.assortcloud.com/Uploads/Images/1_638454898982170109.png",
//     familyMember: null,
//   ),
//   NewDocumentModel(
//     id: 4,
//     documentType: DocumentType.additionalDocuments,
//     name: 'Document 4',
//     documentUrl: "https://reg-card.assortcloud.com/Uploads/Images/1_638454898982170109.png",
//     familyMember: null ,
//   ),
//   NewDocumentModel(
//     id: 5,
//     documentType: DocumentType.additionalDocuments,
//     name: 'Document 5',
//     documentUrl: "https://reg-card.assortcloud.com/Uploads/Images/1_638454898982170109.png",
//     familyMember: null,
//   ),
// ];



























