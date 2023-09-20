// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taskModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tasks _$TasksFromJson(Map<String, dynamic> json) => Tasks(
      id: json['id'] as String?,
      agencyId: json['agencyId'] as String?,
      touristGuideId: json['touristGuideId'] as String?,
      todoDate: json['todoDate'] == null
          ? null
          : DateTime.parse(json['todoDate'] as String),
      description: json['description'] as String?,
      creatorUserId: json['creatorUserId'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$TasksToJson(Tasks instance) => <String, dynamic>{
      'id': instance.id,
      'agencyId': instance.agencyId,
      'touristGuideId': instance.touristGuideId,
      'todoDate': instance.todoDate?.toIso8601String(),
      'description': instance.description,
      'creatorUserId': instance.creatorUserId,
      'createdAt': instance.createdAt,
    };
