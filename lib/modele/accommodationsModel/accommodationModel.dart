import 'package:json_annotation/json_annotation.dart';
import '../../modele/hotelModel/hotelModel.dart';


part 'accommodationModel.g.dart';

@JsonSerializable()
class Accommodations {
  String? id;
  String? agencyId;
  String? travellerId;
  String? hotelId;
  String? roomNumber;
  int? countNights;
  String? note;
  DateTime? date;
  String? reference;
  int? adultCount;
  int? childCount;
  int? babyCount;
  String? roomType;
  String? comment;
  String? mealPlan;
  double? price;
  String? currency;
  String? status;
  String? log;
  String? creatorUserId;
  DateTime? createdAt;
  String? updaterUserId;
  DateTime? updatedAt;
  Hotel? hotel;

  Accommodations({
    this.id,
    this.agencyId,
    this.travellerId,
    this.hotelId,
    this.roomNumber,
    this.countNights,
    this.note,
    this.date,
    this.reference,
    this.adultCount,
    this.childCount,
    this.babyCount,
    this.roomType,
    this.comment,
    this.mealPlan,
    this.price,
    this.currency,
    this.status,
    this.log,
    this.creatorUserId,
    this.createdAt,
    this.updaterUserId,
    this.updatedAt,
this.hotel,
  });
  factory Accommodations.fromJson(Map<String, dynamic> json) =>
      _$AccommodationsFromJson(json);
  Map<String, dynamic> toJson() => _$AccommodationsToJson(this);
}
