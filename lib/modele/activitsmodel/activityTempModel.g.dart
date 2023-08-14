// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activityTempModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityTemplate _$ActivityTemplateFromJson(Map<String, dynamic> json) =>
    ActivityTemplate(
      id: json['id'] as String?,
      name: json['name'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      activitiesCategoryModelmplate: json['activitiesCategoryModelmplate'] ==
              null
          ? null
          : ActivitiesCategoryModel.fromJson(
              json['activitiesCategoryModelmplate'] as Map<String, dynamic>),
      durationHours: json['durationHours'] as int?,
      shortDescription: json['shortDescription'] as String?,
      picture: json['picture'] as String?,
      longDescription: json['longDescription'] as String?,
      includedServiceList: json['includedServiceList'] as String?,
      notIncludedServiceList: json['notIncludedServiceList'] as String?,
      safetyMeasureList: json['safetyMeasureList'] as String?,
      adultPrice: (json['adultPrice'] as num?)?.toDouble(),
      childPrice: (json['childPrice'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      hotelPickupOffered: json['hotelPickupOffered'] as bool?,
      countryId: json['countryId'] as String?,
      stateId: json['stateId'] as String?,
      video: json['video'] as String?,
      cityId: json['cityId'] as String?,
      coordinates: json['coordinates'] as Map<String, dynamic>?,
      creatorUserId: json['creatorUserId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updaterUserId: json['updaterUserId'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      primaryColor: json['primaryColor'] as String?,
      secondaryColor: json['secondaryColor'] as String?,
      logo: json['logo'] as String?,
    );

Map<String, dynamic> _$ActivityTemplateToJson(ActivityTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'durationHours': instance.durationHours,
      'shortDescription': instance.shortDescription,
      'picture': instance.picture,
      'video': instance.video,
      'longDescription': instance.longDescription,
      'includedServiceList': instance.includedServiceList,
      'notIncludedServiceList': instance.notIncludedServiceList,
      'safetyMeasureList': instance.safetyMeasureList,
      'adultPrice': instance.adultPrice,
      'childPrice': instance.childPrice,
      'currency': instance.currency,
      'hotelPickupOffered': instance.hotelPickupOffered,
      'countryId': instance.countryId,
      'stateId': instance.stateId,
      'cityId': instance.cityId,
      'coordinates': instance.coordinates,
      'creatorUserId': instance.creatorUserId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updaterUserId': instance.updaterUserId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'images': instance.images,
      'primaryColor': instance.primaryColor,
      'secondaryColor': instance.secondaryColor,
      'activitiesCategoryModelmplate': instance.activitiesCategoryModelmplate,
      'logo': instance.logo,
    };
