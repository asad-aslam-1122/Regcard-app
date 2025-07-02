class SocialLink {
  SocialLink({
      this.name, 
      this.value, 
      this.iconUrl, 
      this.id,});

  SocialLink.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
    iconUrl = json['iconUrl'];
    id = json['id'];
  }
  String? name;
  String? value;
  String? iconUrl;
  num? id;
SocialLink copyWith({  String? name,
  String? value,
  String? iconUrl,
  num? id,
}) => SocialLink(  name: name ?? this.name,
  value: value ?? this.value,
  iconUrl: iconUrl ?? this.iconUrl,
  id: id ?? this.id,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['value'] = value;
    map['iconUrl'] = iconUrl;
    map['id'] = id;
    return map;
  }

}