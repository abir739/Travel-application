import 'package:json_annotation/json_annotation.dart';

part 'driversModel.g.dart';
@JsonSerializable()
class Driver {
  String? id;
  String? transportCompanyId;
  String? userId;
  String? name;
  String? phone;
  String? licenceNumber;
  bool? enabled;
  String? creatorUserId;
  DateTime? createdAt;
  String? updaterUserId;
  DateTime? updatedAt;

  Driver({
     this.id,
     this.transportCompanyId,
     this.userId,
     this.name,
     this.phone,
     this.licenceNumber,
     this.enabled,
     this.creatorUserId,
     this.createdAt,
     this.updaterUserId,
     this.updatedAt,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);
  Map<String, dynamic> toJson() => _$DriverToJson(this);
}
