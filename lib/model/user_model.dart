class UserModel {
  bool? success;
  String? message;
  User? user;

  UserModel({this.success, this.message, this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    user = json['result'] != null ? new User.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.user != null) {
      data['result'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? access;
  String? isVerified;
  String? isActive;
  String? name;
  String? email;
  String? contactDetails;
  String? lastLoggedOn;
  String? state;
  String? city;
  String? profileImage;
  String? token;

  User(
      {this.id,
      this.access,
      this.isVerified,
      this.isActive,
      this.name,
      this.email,
      this.contactDetails,
      this.lastLoggedOn,
      this.state,
      this.city,
      this.profileImage,
      this.token});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    access = json['access'];
    isVerified = json['is_verified'];
    isActive = json['is_active'];
    name = json['name'];
    email = json['email'];
    contactDetails = json['contact_details'];
    lastLoggedOn = json['last_logged_on'];
    state = json['state'];
    city = json['city'];
    profileImage = json['profile_image'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['access'] = this.access;
    data['is_verified'] = this.isVerified;
    data['is_active'] = this.isActive;
    data['name'] = this.name;
    data['email'] = this.email;
    data['contact_details'] = this.contactDetails;
    data['last_logged_on'] = this.lastLoggedOn;
    data['state'] = this.state;
    data['city'] = this.city;
    data['profile_image'] = this.profileImage;
    data['token'] = this.token;
    return data;
  }
}
