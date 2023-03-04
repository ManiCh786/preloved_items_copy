class UsersModel {
  String? userId;
  String? profileImageUrl;
  String? fName;
  String? lName;
  String? email;
  String? phone;
  String? status;
  String? accountType;
  DateTime? createdAt;
  DateTime? updatedAt;
  UsersModel({
    this.userId,
    this.profileImageUrl,
    this.fName,
    this.lName,
    this.email,
    this.phone,
    this.status,
    this.accountType,
    this.createdAt,
    this.updatedAt,
  });
  UsersModel.fromJson(Map<String, dynamic> data, String id) {
    userId = id;
    profileImageUrl = data['profileImageUrl'];
    fName = data['fName'];
    lName = data['lName'];
    email = data['email'];
    phone = data['phone'];
    status = data['status'];
    accountType = data['accountType'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }
  Map<String, dynamic> toJson() {
    return {
      "profileImageUrl": profileImageUrl,
      "fName": fName,
      "lName": lName,
      "email": email,
      "phone": phone,
      "status": status,
      "accountType": accountType,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
