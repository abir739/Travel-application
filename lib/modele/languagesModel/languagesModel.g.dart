// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'languagesModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Language _$LanguageFromJson(Map<String, dynamic> json) => Language(
      id: json['id'] as String?,
      name: json['name'] as String?,
      locale: json['locale'] as String?,
      code: json['code'] as String?,
      picture: json['picture'] as String?,
      preferred: json['preferred'] as bool?,
      creatorUserId: json['creatorUserId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updaterUserId: json['updaterUserId'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$LanguageToJson(Language instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'locale': instance.locale,
      'code': instance.code,
      'picture': instance.picture,
      'preferred': instance.preferred,
      'creatorUserId': instance.creatorUserId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updaterUserId': instance.updaterUserId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
