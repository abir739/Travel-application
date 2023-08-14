// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accommodationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Accommodations _$AccommodationsFromJson(Map<String, dynamic> json) =>
    Accommodations(
      id: json['id'] as String?,
      agencyId: json['agencyId'] as String?,
      travellerId: json['travellerId'] as String?,
      hotelId: json['hotelId'] as String?,
      roomNumber: json['roomNumber'] as String?,
      countNights: json['countNights'] as int?,
      note: json['note'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      reference: json['reference'] as String?,
      adultCount: json['adultCount'] as int?,
      childCount: json['childCount'] as int?,
      babyCount: json['babyCount'] as int?,
      roomType: json['roomType'] as String?,
      comment: json['comment'] as String?,
      mealPlan: json['mealPlan'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      status: json['status'] as String?,
      log: json['log'] as String?,
      creatorUserId: json['creatorUserId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updaterUserId: json['updaterUserId'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      hotel: json['hotel'] == null
          ? null
          : Hotel.fromJson(json['hotel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AccommodationsToJson(Accommodations instance) =>
    <String, dynamic>{
      'id': instance.id,
      'agencyId': instance.agencyId,
      'travellerId': instance.travellerId,
      'hotelId': instance.hotelId,
      'roomNumber': instance.roomNumber,
      'countNights': instance.countNights,
      'note': instance.note,
      'date': instance.date?.toIso8601String(),
      'reference': instance.reference,
      'adultCount': instance.adultCount,
      'childCount': instance.childCount,
      'babyCount': instance.babyCount,
      'roomType': instance.roomType,
      'comment': instance.comment,
      'mealPlan': instance.mealPlan,
      'price': instance.price,
      'currency': instance.currency,
      'status': instance.status,
      'log': instance.log,
      'creatorUserId': instance.creatorUserId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updaterUserId': instance.updaterUserId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'hotel': instance.hotel,
    };
