// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cityModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) => City(
      id: json['id'] as String?,
      name: json['name'] as String?,
      stateCode: json['stateCode'] as String?,
      longitude: json['longitude'] as int?,
      latitude: json['latitude'] as int?,
      countryCode: json['countryCode'] as String?,
      wikiDataId: json['wikiDataId'] as String?,
      flag: json['flag'] as bool?,
      creatorUserId: json['creatorUserId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updaterUserId: json['updaterUserId'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      country: json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'stateCode': instance.stateCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'countryCode': instance.countryCode,
      'wikiDataId': instance.wikiDataId,
      'flag': instance.flag,
      'creatorUserId': instance.creatorUserId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updaterUserId': instance.updaterUserId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'country': instance.country,
    };
