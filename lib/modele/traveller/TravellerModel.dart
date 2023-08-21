import 'package:json_annotation/json_annotation.dart';

part 'TravellerModel.g.dart';

@JsonSerializable()
class Traveller {
  String? id;
  String? title;
  String? code;
  String? userId;
  String? touristGroupId;
  
  bool? hasPartner;


  Traveller({
    this.id,
    this.code,
    this.title,
    this.userId,
    
    this.hasPartner,
    this.touristGroupId,
  
  });

  factory Traveller.fromJson(Map<String, dynamic> json) =>
      _$TravellerFromJson(json);
  Map<String, dynamic> toJson() => _$TravellerToJson(this);
}
