class UserData{
  String? pictureUrl;
  String? firstName;
  String? lastName;
  String? fullName;
  String? email;
  String? userId;
  bool? isBlock;
  bool? isConnected;
  bool? isRequested;
  Form1? form1;
  Form2? form2;

  UserData({this.pictureUrl, this.firstName, this.lastName, this.fullName,
       this.email, this.userId, this.form1,this.form2,this.isBlock, this.isConnected, this.isRequested = false});
}

class Form1{
  String? address;
  String? city;
  String? country;
  String? dob;

  Form1(this.address, this.city,this.country, this.dob);
}

class Form2{
  String? workPosition;
  String? companyName;
  String? companyAddress;

  Form2(this.workPosition, this.companyName, this.companyAddress);
}