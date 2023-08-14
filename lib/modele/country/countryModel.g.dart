// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countryModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      id: json['id'] as String?,
      name: json['name'] as String?,
      iso3: json['iso3'] as String?,
      numericCode: json['numericCode'] as String?,
      iso2: json['iso2'] as String?,
      phoneCode: json['phoneCode'] as String?,
      capital: json['capital'] as String?,
      currency: json['currency'] as String?,
      currencyName: json['currencyName'] as String?,
      currencySymbol: json['currencySymbol'] as String?,
      tld: json['tld'] as String?,
      native: json['native'] as String?,
      region: json['region'] as String?,
      subregion: json['subregion'] as String?,
      timeZones: json['timeZones'] as String?,
      translation: json['translation'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      emoji: json['emoji'] as String?,
      emojiU: json['emojiU'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      flag: json['flag'] as bool?,
      wikiDataId: json['wikiDataId'] as String?,
      creatorUser: json['creatorUser'] as String?,
      updaterUser: json['updaterUser'] as String?,
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iso3': instance.iso3,
      'numericCode': instance.numericCode,
      'iso2': instance.iso2,
      'phoneCode': instance.phoneCode,
      'capital': instance.capital,
      'currency': instance.currency,
      'currencyName': instance.currencyName,
      'currencySymbol': instance.currencySymbol,
      'tld': instance.tld,
      'native': instance.native,
      'region': instance.region,
      'subregion': instance.subregion,
      'timeZones': instance.timeZones,
      'translation': instance.translation,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'emoji': instance.emoji,
      'emojiU': instance.emojiU,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'flag': instance.flag,
      'wikiDataId': instance.wikiDataId,
      'creatorUser': instance.creatorUser,
      'updaterUser': instance.updaterUser,
    };
