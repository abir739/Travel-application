// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driversModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Driver _$DriverFromJson(Map<String, dynamic> json) => Driver(
      id: json['id'] as String?,
      transportCompanyId: json['transportCompanyId'] as String?,
      userId: json['userId'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      licenceNumber: json['licenceNumber'] as String?,
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

Map<String, dynamic> _$DriverToJson(Driver instance) => <String, dynamic>{
      'id': instance.id,
      'transportCompanyId': instance.transportCompanyId,
      'userId': instance.userId,
      'name': instance.name,
      'phone': instance.phone,
      'licenceNumber': instance.licenceNumber,
      'enabled': instance.enabled,
      'creatorUserId': instance.creatorUserId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updaterUserId': instance.updaterUserId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
