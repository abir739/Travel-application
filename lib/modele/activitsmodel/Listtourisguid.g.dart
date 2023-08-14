// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Listtourisguid.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Listtourisguid _$ListtourisguidFromJson(Map<String, dynamic> json) =>
    Listtourisguid(
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => TouristGuide.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListtourisguidToJson(Listtourisguid instance) =>
    <String, dynamic>{
      'results': instance.results,
    };
