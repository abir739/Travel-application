import 'package:json_annotation/json_annotation.dart';

import '../TouristGuide.dart';

part 'Listtourisguid.g.dart';

@JsonSerializable()
class Listtourisguid {
  List<TouristGuide>? results;

  Listtourisguid({this.results});

  factory Listtourisguid.fromJson(Map<String, dynamic> json) =>
      _$ListtourisguidFromJson(json);
  Map<String, dynamic> toJson() => _$ListtourisguidToJson(this);
}
