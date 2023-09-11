import 'package:json_annotation/json_annotation.dart';


part 'languagesModel.g.dart';

@JsonSerializable()
class Language {
  String? id;
  String? name;
  String? locale;
  String? code;
  String? picture;
  bool? preferred;
  String? creatorUserId;
  DateTime? createdAt;
  String? updaterUserId;
  DateTime? updatedAt;

  Language({
    this.id,
    this.name,
    this.locale,
    this.code,
    this.picture,
    this.preferred,
    this.creatorUserId,
    this.createdAt,
    this.updaterUserId,
    this.updatedAt,
  });
  factory Language.fromJson(Map<String, dynamic> json) =>
      _$LanguageFromJson(json);
  Map<String?, dynamic> toJson() => _$LanguageToJson(this);
}
