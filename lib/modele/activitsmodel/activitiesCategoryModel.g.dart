// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activitiesCategoryModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivitiesCategoryModel _$ActivitiesCategoryModelFromJson(
        Map<String, dynamic> json) =>
    ActivitiesCategoryModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      enabled: json['enabled'] as bool?,
      creatorUserId: json['creatorUserId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updaterUserId: json['updaterUserId'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ActivitiesCategoryModelToJson(
        ActivitiesCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'enabled': instance.enabled,
      'creatorUserId': instance.creatorUserId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updaterUserId': instance.updaterUserId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
