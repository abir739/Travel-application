class Notificationde {
  String? location;
  String? detail;
  String? date;
  String? email;

  Notificationde({
    this.location,
    this.detail,
    this.date,
    this.email,
  });

  Notificationde.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    detail = json['detail'];
    date = json['createdAt'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avatar'] = location;
    data['name'] = detail;
    data['createdAt'] = date;
    data['email'] = email;
    return data;
  }
}
