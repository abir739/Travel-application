import 'package:json_annotation/json_annotation.dart';

part 'taskModel.g.dart';

@JsonSerializable()
class Tasks {
  String? id;
  String? agencyId;
  String? touristGuideId;
  String? todoDate;
  String? description;
  String? creatorUserId;
  String? createdAt;

  Tasks({
    this.id,
    this.agencyId,
    this.touristGuideId,
    this.todoDate,
    this.description,
    this.creatorUserId,
    this.createdAt,
  });

  factory Tasks.fromJson(Map<String, dynamic> json) => _$TasksFromJson(json);
  Map<String, dynamic> toJson() => _$TasksToJson(this);
}