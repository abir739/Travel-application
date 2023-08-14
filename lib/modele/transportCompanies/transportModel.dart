import 'package:json_annotation/json_annotation.dart';

import '../TouristGuide.dart';
import '../activitsmodel/activityTempModel.dart';
import '../agance.dart';
import '../creatorUser.dart';
import '../touristGroup.dart';
import '../updaterUser.dart';

part 'transportModel.g.dart';

@JsonSerializable()
class Transport {
  String? id;
  String? name;
  String? fullName;
  String? logo;
  bool? enabled;
  String? email;
  String? website;
  String? phone;
  String? fax;
  String? managerName;
  String? mobile;
  String? address;
  Map<String, dynamic>?
      coordinates; // or LatLng class if using google_maps_flutter
  String? zipCode;
  String? countryId;
  String? stateId;
  String? cityId;
  String? creatorUserId;
  DateTime? createdAt;
  String? updaterUserId;
  DateTime? updatedAt;

  Transport({
     this.id,
     this.name,
     this.fullName,
     this.logo,
     this.enabled,
     this.email,
     this.website,
     this.phone,
     this.fax,
     this.managerName,
     this.mobile,
     this.address,
     this.coordinates,
     this.zipCode,
     this.countryId,
     this.stateId,
     this.cityId,
     this.creatorUserId,
     this.createdAt,
     this.updaterUserId,
     this.updatedAt,
  });
  factory Transport.fromJson(Map<String, dynamic> json) =>
      _$TransportFromJson(json);
  Map<String?, dynamic> toJson() => _$TransportToJson(this);

}
