// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotelModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hotel _$HotelFromJson(Map<String, dynamic> json) => Hotel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      starsCount: json['starsCount'] as int?,
      shortDescription: json['shortDescription'] as String?,
      picture: json['picture'] as String?,
      longDescription: json['longDescription'] as String?,
      address: json['address'] as String?,
      zipCode: json['zipCode'] as String?,
      countryId: json['countryId'] as String?,
      stateId: json['stateId'] as String?,
      cityId: json['cityId'] as String?,
      coordinates: json['coordinates'] as Map<String, dynamic>?,
      tripadvisorUrl: json['tripadvisorUrl'] as String?,
      importName: json['importName'] as String?,
      creatorUserId: json['creatorUserId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updaterUserId: json['updaterUserId'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$HotelToJson(Hotel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'starsCount': instance.starsCount,
      'shortDescription': instance.shortDescription,
      'picture': instance.picture,
      'longDescription': instance.longDescription,
      'address': instance.address,
      'zipCode': instance.zipCode,
      'countryId': instance.countryId,
      'stateId': instance.stateId,
      'cityId': instance.cityId,
      'coordinates': instance.coordinates,
      'tripadvisorUrl': instance.tripadvisorUrl,
      'importName': instance.importName,
      'creatorUserId': instance.creatorUserId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updaterUserId': instance.updaterUserId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
