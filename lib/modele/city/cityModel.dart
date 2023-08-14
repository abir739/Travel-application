import 'package:json_annotation/json_annotation.dart';

import '../country/countryModel.dart';

part 'cityModel.g.dart';

@JsonSerializable()
class City {
  String? id;
  String? name;
  String? stateCode;
  int? latitude;
  int? longitude;
  String? countryCode;
  String? wikiDataId;
  bool? flag;
  String? creatorUserId;
  DateTime? createdAt;
  String? updaterUserId;
  DateTime? updatedAt;
  Country? country;

  City({
    this.id,
    this.name,
    this.stateCode,
    this.longitude,
    this.latitude,
    this.countryCode,
    this.wikiDataId,
    this.flag,
    this.creatorUserId,
    this.createdAt,
    this.updaterUserId,
    this.updatedAt,this.country
  });

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
  Map<String, dynamic> toJson() => _$CityToJson(this);
}
