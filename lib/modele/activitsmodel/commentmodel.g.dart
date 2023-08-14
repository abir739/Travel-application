// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commentmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String?,
      agencyId: json['agencyId'] as String?,
      agency: json['agency'] == null
          ? null
          : Agency.fromJson(json['agency'] as Map<String, dynamic>),
      activityId: json['activityId'] as String?,
      activity: json['activity'] == null
          ? null
          : Activity.fromJson(json['activity'] as Map<String, dynamic>),
      replyToCommentId: json['replyToCommentId'] as String?,
      replyToComment: json['replyToComment'] == null
          ? null
          : Comment.fromJson(json['replyToComment'] as Map<String, dynamic>),
      objectType: json['objectType'] as String?,
      objectPrimaryKey: json['objectPrimaryKey'] as String?,
      content: json['content'] as String?,
      checked: json['checked'] as bool?,
      enabled: json['enabled'] as bool?,
      creatorUserId: json['creatorUserId'] as String?,
      creatorUser: json['creatorUser'] == null
          ? null
          : User.fromJson(json['creatorUser'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updaterUserId: json['updaterUserId'] as String?,
      updaterUser: json['updaterUser'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'agencyId': instance.agencyId,
      'agency': instance.agency,
      'activityId': instance.activityId,
      'activity': instance.activity,
      'replyToCommentId': instance.replyToCommentId,
      'replyToComment': instance.replyToComment,
      'objectType': instance.objectType,
      'objectPrimaryKey': instance.objectPrimaryKey,
      'content': instance.content,
      'checked': instance.checked,
      'enabled': instance.enabled,
      'creatorUserId': instance.creatorUserId,
      'creatorUser': instance.creatorUser,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updaterUserId': instance.updaterUserId,
      'updaterUser': instance.updaterUser,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
