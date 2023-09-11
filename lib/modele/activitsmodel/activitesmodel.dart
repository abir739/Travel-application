import 'package:json_annotation/json_annotation.dart';

import '../TouristGuide.dart';
import '../agance.dart';
import 'activityTempModel.dart';
part 'activitesmodel.g.dart';

@JsonSerializable()
class Activity {
  String? id;
  String? name;
  String? agencyId;
  String? logo;
  String? activityTemplateId;
  String? touristGuideId;
  DateTime? departureDate;
  String? departureNote;
  DateTime? returnDate;

  // bool isFavorite;
  String? returnNote;
  String? reference;
  bool ? confirmed;
  double? adultPrice;
  double? childPrice;
  double? babyPrice;
  String? currency;
  int? placesCount;
  String? parentActivityId;
  String? creatorUserId;
  DateTime? createdAt;
  String? updaterUserId;
  DateTime? updatedAt;
  String? deletedAt;
  Agency? agency;
  ActivityTemplate? activityTemplate;
  TouristGuide? touristGuide;
 List<String>? plannings;
   List<String>? touristGroups;
  List<String>? images;
   String? primaryColor;
   String? secondaryColor;
  Activity({
this.primaryColor,
this.secondaryColor,
     this.id,
this.images,
     this.agencyId,
     this.activityTemplateId,
     this.touristGuideId,
     this.departureDate,
    this.departureNote,
     this.returnDate,
    this.returnNote,
    this.reference,
     this.confirmed,
    this.adultPrice,
    this.childPrice,
    this.babyPrice,
     this.currency,
    this.placesCount,
    this.parentActivityId,
     this.creatorUserId,
     this.createdAt,
    this.updaterUserId,
     this.updatedAt,
    this.deletedAt,
this.name,
     this.agency,
     this.activityTemplate,
     this.touristGuide,
this.plannings,
     this.touristGroups,
this.logo
// this.isFavorite = false,
  });
factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}
