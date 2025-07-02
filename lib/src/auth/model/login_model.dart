
class LoginModel {
  LoginModel({
      String? token, 
      String? expiration, 
      bool? emailConfirmationRequired, 
      bool? emailConfirmed,}){
    _token = token;
    _expiration = expiration;
    _emailConfirmationRequired = emailConfirmationRequired;
    _emailConfirmed = emailConfirmed;
}

  LoginModel.fromJson(dynamic json) {
    _token = json['token'];
    _expiration = json['expiration'];
    _emailConfirmationRequired = json['emailConfirmationRequired'];
    _emailConfirmed = json['emailConfirmed'];
  }
  String? _token;
  String? _expiration;
  bool? _emailConfirmationRequired;
  bool? _emailConfirmed;
LoginModel copyWith({  String? token,
  String? expiration,
  bool? emailConfirmationRequired,
  bool? emailConfirmed,
}) => LoginModel(  token: token ?? _token,
  expiration: expiration ?? _expiration,
  emailConfirmationRequired: emailConfirmationRequired ?? _emailConfirmationRequired,
  emailConfirmed: emailConfirmed ?? _emailConfirmed,
);
  String? get token => _token;
  String? get expiration => _expiration;
  bool? get emailConfirmationRequired => _emailConfirmationRequired;
  bool? get emailConfirmed => _emailConfirmed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    map['expiration'] = _expiration;
    map['emailConfirmationRequired'] = _emailConfirmationRequired;
    map['emailConfirmed'] = _emailConfirmed;
    return map;
  }

}