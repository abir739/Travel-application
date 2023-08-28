// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TravellerModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Traveller _$TravellerFromJson(Map<String, dynamic> json) => Traveller(
      id: json['id'] as String?,
      code: json['code'] as String?,
      title: json['title'] as String?,
      userId: json['userId'] as String?,
      hasPartner: json['hasPartner'] as bool?,
      touristGroupId: json['touristGroupId'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TravellerToJson(Traveller instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'code': instance.code,
      'userId': instance.userId,
      'touristGroupId': instance.touristGroupId,
      'user': instance.user,
      'hasPartner': instance.hasPartner,
    };
