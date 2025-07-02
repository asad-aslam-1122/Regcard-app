class InfoRegCardModel {
  InfoRegCardModel({
      this.regCardModifiedAt, 
      this.webViewUrl,});

  InfoRegCardModel.fromJson(dynamic json) {
    regCardModifiedAt = json['regCardModifiedAt'];
    webViewUrl = json['webViewUrl'];
  }
  String? regCardModifiedAt;
  String? webViewUrl;
InfoRegCardModel copyWith({  String? regCardModifiedAt,
  String? webViewUrl,
}) => InfoRegCardModel(  regCardModifiedAt: regCardModifiedAt ?? this.regCardModifiedAt,
  webViewUrl: webViewUrl ?? this.webViewUrl,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['regCardModifiedAt'] = regCardModifiedAt;
    map['webViewUrl'] = webViewUrl;
    return map;
  }

}