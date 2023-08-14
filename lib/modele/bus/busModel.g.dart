// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'busModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bus _$BusFromJson(Map<String, dynamic> json) => Bus(
      id: json['id'] as String?,
      transportCompanyId: json['transportCompanyId'] as String?,
      registrationPlate: json['registrationPlate'] as String?,
      seats: json['seats'] as int?,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      color: json['color'] as String?,
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

Map<String, dynamic> _$BusToJson(Bus instance) => <String, dynamic>{
      'id': instance.id,
      'transportCompanyId': instance.transportCompanyId,
      'registrationPlate': instance.registrationPlate,
      'seats': instance.seats,
      'brand': instance.brand,
      'model': instance.model,
      'color': instance.color,
      'enabled': instance.enabled,
      'creatorUserId': instance.creatorUserId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updaterUserId': instance.updaterUserId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
