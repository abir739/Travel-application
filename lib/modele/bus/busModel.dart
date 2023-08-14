import 'package:json_annotation/json_annotation.dart';

part 'busModel.g.dart';
@JsonSerializable()
class Bus {
  String? id;
  String? transportCompanyId;
  String? registrationPlate;
  int? seats;
  String? brand;
  String? model;
  String? color;
  bool? enabled;
  String? creatorUserId;
  DateTime? createdAt;
  String? updaterUserId;
  DateTime? updatedAt;

  Bus({
     this.id,
     this.transportCompanyId,
     this.registrationPlate,
     this.seats,
     this.brand,
     this.model,
     this.color,
     this.enabled,
     this.creatorUserId,
     this.createdAt,
     this.updaterUserId,
     this.updatedAt,
  });

  factory Bus.fromJson(Map<String, dynamic> json) => _$BusFromJson(json);
  Map<String, dynamic> toJson() => _$BusToJson(this);
}
