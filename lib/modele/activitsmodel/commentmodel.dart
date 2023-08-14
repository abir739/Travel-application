import 'package:json_annotation/json_annotation.dart';

import '../TouristGuide.dart';

import '../agance.dart';
import '../creatorUser.dart';
import '../touristGroup.dart';
import '../updaterUser.dart';
import 'activitesmodel.dart';
import 'activitesmodel.dart';
import 'usersmodel.dart';
part 'commentmodel.g.dart';
@JsonSerializable()
class Comment {
  String? id;
  String? agencyId;
  Agency? agency;
  String? activityId;
  Activity? activity;
  String? replyToCommentId;
  Comment? replyToComment;
  String? objectType;
  String? objectPrimaryKey;
  String? content;
  bool? checked;
  bool? enabled;
  String? creatorUserId;
  User? creatorUser;
  DateTime? createdAt;
  String? updaterUserId;
  String? updaterUser;
  DateTime? updatedAt;
  Comment({
    this.id,
    this.agencyId,
    this.agency,
    this.activityId,
    this.activity,
    this.replyToCommentId,
    this.replyToComment,
    this.objectType,
    this.objectPrimaryKey,
    this.content,
    this.checked,
    this.enabled,
    this.creatorUserId,
    this.creatorUser,
    this.createdAt,
    this.updaterUserId,
    this.updaterUser,
    this.updatedAt,
  });

 

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
