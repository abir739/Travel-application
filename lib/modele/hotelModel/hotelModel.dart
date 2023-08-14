import 'package:json_annotation/json_annotation.dart';

import '../TouristGuide.dart';
import '../activitsmodel/activityTempModel.dart';
import '../agance.dart';
import '../creatorUser.dart';
import '../touristGroup.dart';
import '../updaterUser.dart';

part 'hotelModel.g.dart';

@JsonSerializable()
class Hotel {
  String? id;
  String? name;
  int? starsCount;
  String? shortDescription;
  String? picture;
  String? longDescription;
  String? address;
  String? zipCode;
  String? countryId;
  String? stateId;
  String? cityId;
  Map<String, dynamic>?
      coordinates; // or LatLng class if using google_maps_flutter
  String? tripadvisorUrl;
  String? importName;
  String? creatorUserId;
  DateTime? createdAt;
  String? updaterUserId;
  DateTime? updatedAt;

  Hotel({
    this.id,
    this.name,
    this.starsCount,
    this.shortDescription,
    this.picture,
    this.longDescription,
    this.address,
    this.zipCode,
    this.countryId,
    this.stateId,
    this.cityId,
    this.coordinates,
    this.tripadvisorUrl,
    this.importName,
    this.creatorUserId,
    this.createdAt,
    this.updaterUserId,
    this.updatedAt,
  });
factory Hotel.fromJson(Map<String, dynamic> json) =>
      _$HotelFromJson(json);
  Map<String?, dynamic> toJson() => _$HotelToJson(this);
}
