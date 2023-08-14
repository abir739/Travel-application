import 'package:json_annotation/json_annotation.dart';
import 'package:zenify_trip/modele/activitsmodel/activitiesCategoryModel.dart';

part 'activityTempModel.g.dart';

@JsonSerializable()
class ActivityTemplate {
  String? id;
  String? name;
  int? durationHours;
  String? shortDescription;
  String? picture;
  String? video;

  String? longDescription;
  String? includedServiceList;
  String? notIncludedServiceList;
  String? safetyMeasureList;
  double? adultPrice;

  double? childPrice;
  String? currency;
  bool? hotelPickupOffered;
  String? countryId;
  String? stateId;
  String? cityId;
  Map<String, dynamic>? coordinates; // or LatLng class if using google_maps_flutter
  String? creatorUserId;
  DateTime? createdAt;
  String? updaterUserId;
  DateTime? updatedAt;
  DateTime? deletedAt;
  List<String>? images;
  String? primaryColor;
  String? secondaryColor;
ActivitiesCategoryModel? activitiesCategoryModelmplate;
  String? logo;
  ActivityTemplate({
     this.id,
     this.name,this.images,
this.activitiesCategoryModelmplate,
     this.durationHours,
     this.shortDescription,
     this.picture,
     this.longDescription,
     this.includedServiceList,
     this.notIncludedServiceList,
     this.safetyMeasureList,
     this.adultPrice,
     this.childPrice,
     this.currency,
     this.hotelPickupOffered,
     this.countryId,
     this.stateId,this.video,
     this.cityId,
     this.coordinates,
     this.creatorUserId,
     this.createdAt,
     this.updaterUserId,
     this.updatedAt,
     this.deletedAt,
this.primaryColor,
    this.secondaryColor,this.logo
  });
factory ActivityTemplate.fromJson(Map<String, dynamic> json) =>
      _$ActivityTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityTemplateToJson(this);
}
