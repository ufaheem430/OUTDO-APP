import 'package:geolocator/geolocator.dart';

class MeetingModel {
  bool? success;
  String? message;
  Meeting? meeting;

  MeetingModel({this.success, this.message, this.meeting});

  MeetingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    meeting =
        json['result'] != null ? new Meeting.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.meeting != null) {
      data['result'] = this.meeting!.toJson();
    }
    return data;
  }
}

class Meeting {
  List<Upcoming>? upcoming;
  List<Delay>? delay;
  List<Completed>? completed;

  Meeting({this.upcoming, this.delay, this.completed});

  Meeting.fromJson(Map<String, dynamic> json) {
    if (json['upcoming'] != null) {
      upcoming = <Upcoming>[];
      json['upcoming'].forEach((v) {
        upcoming!.add(new Upcoming.fromJson(v));
      });
    }
    if (json['delay'] != null) {
      delay = <Delay>[];
      json['delay'].forEach((v) {
        delay!.add(new Delay.fromJson(v));
      });
    }
    if (json['completed'] != null) {
      completed = <Completed>[];
      json['completed'].forEach((v) {
        completed!.add(new Completed.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.upcoming != null) {
      data['upcoming'] = this.upcoming!.map((v) => v.toJson()).toList();
    }
    if (this.delay != null) {
      data['delay'] = this.delay!.map((v) => v.toJson()).toList();
    }
    if (this.completed != null) {
      data['completed'] = this.completed!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Upcoming {
  String? id;
  String? ordId;
  String? parentId;
  String? userId;
  String? scheduleDate;
  String? comment;
  String? status;
  String? orderStatus;
  String? createdBy;
  String? createdOn;
  String? updatedBy;
  String? updatedOn;
  String? latitude;
  String? longitude;
  String? name;
  String? area;
  String? firstLine;
  String? secondLine;
  String? cityName;
  String? btnOneLabel;
  String? btnTwoLabel;
  bool? isLoading;
  bool? isChangeMeetingStateLoading;
  bool? isReachedDone;
  String? address1;
  String? address2;
  String? locality;
  String? city;
  Position? locationPosition;

  Upcoming({
    this.id,
    this.ordId,
    this.parentId,
    this.userId,
    this.scheduleDate,
    this.comment,
    this.status,
    this.orderStatus,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.latitude,
    this.longitude,
    this.name,
    this.area,
    this.firstLine,
    this.secondLine,
    this.cityName,
    this.btnOneLabel,
    this.btnTwoLabel,
    this.isChangeMeetingStateLoading,
    this.isLoading,
    this.isReachedDone,
    this.address1,
    this.address2,
    this.locality,
    this.city,
    this.locationPosition,
  });

  Upcoming.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ordId = json['ord_id'];
    parentId = json['parent_id'];
    userId = json['user_id'];
    scheduleDate = json['schedule_date'];
    comment = json['comment'];
    status = json['status'];
    orderStatus = json['order_status'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    updatedBy = json['updated_by'];
    updatedOn = json['updated_on'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    name = json['name'];
    area = json['area'];
    firstLine = json['first_line'];
    secondLine = json['second_line'];
    cityName = json['city_name'];
    btnOneLabel = json['btn_one_label'];
    btnTwoLabel = json['btn_two_label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ord_id'] = this.ordId;
    data['parent_id'] = this.parentId;
    data['user_id'] = this.userId;
    data['schedule_date'] = this.scheduleDate;
    data['comment'] = this.comment;
    data['status'] = this.status;
    data['order_status'] = this.orderStatus;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['updated_by'] = this.updatedBy;
    data['updated_on'] = this.updatedOn;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['name'] = this.name;
    data['area'] = this.area;
    data['first_line'] = this.firstLine;
    data['second_line'] = this.secondLine;
    data['city_name'] = this.cityName;
    data['btn_one_label'] = this.btnOneLabel;
    data['btn_two_label'] = this.btnTwoLabel;
    return data;
  }
}

class Delay {
  String? id;
  String? ordId;
  String? parentId;
  String? userId;
  String? scheduleDate;
  String? comment;
  String? status;
  String? orderStatus;
  String? createdBy;
  String? createdOn;
  String? updatedBy;
  String? updatedOn;
  String? latitude;
  String? longitude;
  String? name;
  String? area;
  String? firstLine;
  String? secondLine;
  String? cityName;

  Delay(
      {this.id,
      this.ordId,
      this.parentId,
      this.userId,
      this.scheduleDate,
      this.comment,
      this.status,
      this.orderStatus,
      this.createdBy,
      this.createdOn,
      this.updatedBy,
      this.updatedOn,
      this.latitude,
      this.longitude,
      this.name,
      this.area,
      this.firstLine,
      this.secondLine,
      this.cityName});

  Delay.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ordId = json['ord_id'];
    parentId = json['parent_id'];
    userId = json['user_id'];
    scheduleDate = json['schedule_date'];
    comment = json['comment'];
    status = json['status'];
    orderStatus = json['order_status'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    updatedBy = json['updated_by'];
    updatedOn = json['updated_on'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    name = json['name'];
    area = json['area'];
    firstLine = json['first_line'];
    secondLine = json['second_line'];
    cityName = json['city_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ord_id'] = this.ordId;
    data['parent_id'] = this.parentId;
    data['user_id'] = this.userId;
    data['schedule_date'] = this.scheduleDate;
    data['comment'] = this.comment;
    data['status'] = this.status;
    data['order_status'] = this.orderStatus;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['updated_by'] = this.updatedBy;
    data['updated_on'] = this.updatedOn;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['name'] = this.name;
    data['area'] = this.area;
    data['first_line'] = this.firstLine;
    data['second_line'] = this.secondLine;
    data['city_name'] = this.cityName;
    return data;
  }
}

class Completed {
  String? id;
  String? ordId;
  String? parentId;
  String? userId;
  String? scheduleDate;
  String? comment;
  String? status;
  String? orderStatus;
  String? createdBy;
  String? createdOn;
  String? updatedBy;
  String? updatedOn;
  String? latitude;
  String? longitude;
  String? name;
  String? area;
  String? firstLine;
  String? secondLine;
  String? cityName;

  Completed(
      {this.id,
      this.ordId,
      this.parentId,
      this.userId,
      this.scheduleDate,
      this.comment,
      this.status,
      this.orderStatus,
      this.createdBy,
      this.createdOn,
      this.updatedBy,
      this.updatedOn,
      this.latitude,
      this.longitude,
      this.name,
      this.area,
      this.firstLine,
      this.secondLine,
      this.cityName});

  Completed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ordId = json['ord_id'];
    parentId = json['parent_id'];
    userId = json['user_id'];
    scheduleDate = json['schedule_date'];
    comment = json['comment'];
    status = json['status'];
    orderStatus = json['order_status'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    updatedBy = json['updated_by'];
    updatedOn = json['updated_on'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    name = json['name'];
    area = json['area'];
    firstLine = json['first_line'];
    secondLine = json['second_line'];
    cityName = json['city_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ord_id'] = this.ordId;
    data['parent_id'] = this.parentId;
    data['user_id'] = this.userId;
    data['schedule_date'] = this.scheduleDate;
    data['comment'] = this.comment;
    data['status'] = this.status;
    data['order_status'] = this.orderStatus;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['updated_by'] = this.updatedBy;
    data['updated_on'] = this.updatedOn;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['name'] = this.name;
    data['area'] = this.area;
    data['first_line'] = this.firstLine;
    data['second_line'] = this.secondLine;
    data['city_name'] = this.cityName;
    return data;
  }
}
