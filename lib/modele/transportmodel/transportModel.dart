import 'package:json_annotation/json_annotation.dart';

import '../TouristGuide.dart';
import '../bus/busModel.dart';
import '../drivers/driversModel.dart';
import '../touristGroup.dart';

part 'transportModel.g.dart';

@JsonSerializable()
class Transport {
  String? id;
  String? agencyId;
  String? touristGuideId;
  String? touristGroupId;
  String? activityId;
  String? transportCompanyId;
  String? busId;
  String? driverId;
  String? note;
  DateTime? date;
  int? durationHours;
  String? reference;
  String? from;
  String? to;
  bool? confirmed;
  String? creatorUserId;
  DateTime? createdAt;
  String? updaterUserId;
  DateTime? updatedAt;
  List<String>? plannings;
  List<TouristGroup>? touristGroups;
  Bus? bus;
  TouristGuide? touristGuide;
  Driver? driver;

  Transport({
    this.id,
    this.agencyId,
    this.touristGuideId,
    this.activityId,
    this.transportCompanyId,this.touristGroupId,
    this.busId,
    this.driverId,
    this.note,
    this.date,
    this.durationHours,
    this.reference,
    this.from,
    this.to,
    this.confirmed,
    this.creatorUserId,
    this.createdAt,
    this.updaterUserId,
    this.updatedAt,
    this.plannings,
    this.touristGroups,
    this.bus,
this.driver,
      this.touristGuide
  });

  factory Transport.fromJson(Map<String, dynamic> json) =>
      _$TransportFromJson(json);
  Map<String?, dynamic> toJson() => _$TransportToJson(this);
}
