import 'package:json_annotation/json_annotation.dart';

// import '../activity_model.dart';
part 'pushnotificationmodel.g.dart';
@JsonSerializable()
class PushNotification {
  PushNotification({
    this.id,
    this.title,
    this.message,
    this.type,
    this.fk,
    this.category,
    this.badge,
    this.sound,
    this.sending,
    this.sendingTime,
    this.createdAt,
    this.creatorUserId,
 
    this.updatedAt,
    this.updaterUserId,
   
  });


  String? id;

  String? title;


  String? message;


  String? type;


  int? fk;


  String? category;


  int? badge;


  String? sound;


  bool? sending;


  DateTime? sendingTime;


  DateTime? createdAt;

  String? creatorUserId;


  


  DateTime? updatedAt;


  String? updaterUserId;




  factory PushNotification.fromJson(Map<String, dynamic> json) =>

      _$PushNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationToJson(this);

}
