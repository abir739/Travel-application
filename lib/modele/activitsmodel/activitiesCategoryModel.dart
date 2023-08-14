import 'package:json_annotation/json_annotation.dart';

part 'activitiesCategoryModel.g.dart';
@JsonSerializable()
class ActivitiesCategoryModel {
  String? id;
  String? name;
  String? description;
  String? icon;
  bool? enabled;
  String? creatorUserId;
  DateTime? createdAt;
  String? updaterUserId;
  DateTime? updatedAt;

  ActivitiesCategoryModel({
    this.id,
    this.name,
    this.description,
    this.icon,
    this.enabled,
    this.creatorUserId,
    this.createdAt,
    this.updaterUserId,
    this.updatedAt,
  });

  factory ActivitiesCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ActivitiesCategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$ActivitiesCategoryModelToJson(this);
}
