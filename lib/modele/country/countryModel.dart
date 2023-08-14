import 'package:json_annotation/json_annotation.dart';

part 'countryModel.g.dart';

@JsonSerializable()
class Country {
  String? id;
  String? name;
  String? iso3;
  String? numericCode;
  String? iso2;
  String? phoneCode;
  String? capital;
  String? currency;
  String? currencyName;
  String? currencySymbol;
  String? tld;
  String? native;
  String? region;
  String? subregion;
  String? timeZones;
  String? translation;
  double? latitude;
  double? longitude;
  String? emoji;
  String? emojiU;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? flag;
  String? wikiDataId;
  String? creatorUser;
  String? updaterUser;

  Country({
    this.id,
    this.name,
    this.iso3,
    this.numericCode,
    this.iso2,
    this.phoneCode,
    this.capital,
    this.currency,
    this.currencyName,
    this.currencySymbol,
    this.tld,
    this.native,
    this.region,
    this.subregion,
    this.timeZones,
    this.translation,
    this.latitude,
    this.longitude,
    this.emoji,
    this.emojiU,
    this.createdAt,
    this.updatedAt,
    this.flag,
    this.wikiDataId,
    this.creatorUser,
    this.updaterUser,
  });

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);
  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
