// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transportModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transport _$TransportFromJson(Map<String, dynamic> json) => Transport(
      id: json['id'] as String?,
      agencyId: json['agencyId'] as String?,
      touristGuideId: json['touristGuideId'] as String?,
      touristGroupId: json['touristGroupId'] as String?,
      activityId: json['activityId'] as String?,
      transportCompanyId: json['transportCompanyId'] as String?,
      busId: json['busId'] as String?,
      driverId: json['driverId'] as String?,
      note: json['note'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      durationHours: json['durationHours'] as int?,
      reference: json['reference'] as String?,
      from: json['from'] as String?,
      to: json['to'] as String?,
      confirmed: json['confirmed'] as bool?,
      creatorUserId: json['creatorUserId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updaterUserId: json['updaterUserId'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      plannings: (json['plannings'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      touristGroups: (json['touristGroups'] as List<dynamic>?)
          ?.map((e) => TouristGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      bus: json['bus'] == null
          ? null
          : Bus.fromJson(json['bus'] as Map<String, dynamic>),
      touristGuide: json['touristGuide'] == null
          ? null
          : TouristGuide.fromJson(json['touristGuide'] as Map<String, dynamic>),
      driver: json['driver'] == null
          ? null
          : Driver.fromJson(json['driver'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransportToJson(Transport instance) => <String, dynamic>{
      'id': instance.id,
      'agencyId': instance.agencyId,
      'touristGuideId': instance.touristGuideId,
      'touristGroupId': instance.touristGroupId,
      'activityId': instance.activityId,
      'transportCompanyId': instance.transportCompanyId,
      'busId': instance.busId,
      'driverId': instance.driverId,
      'note': instance.note,
      'date': instance.date?.toIso8601String(),
      'durationHours': instance.durationHours,
      'reference': instance.reference,
      'from': instance.from,
      'to': instance.to,
      'confirmed': instance.confirmed,
      'creatorUserId': instance.creatorUserId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updaterUserId': instance.updaterUserId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'plannings': instance.plannings,
      'touristGroups': instance.touristGroups,
      'bus': instance.bus,
      'touristGuide': instance.touristGuide,
      'driver': instance.driver,
    };
