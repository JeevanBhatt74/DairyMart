import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/location_entity.dart';

part 'location_api_model.g.dart';

@JsonSerializable()
class LocationApiModel {
  @JsonKey(name: '_id') // Maps MongoDB '_id' to 'locationId'
  final String locationId;
  final String areaName;

  LocationApiModel({
    required this.locationId,
    required this.areaName,
  });

  factory LocationApiModel.fromJson(Map<String, dynamic> json) =>
      _$LocationApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationApiModelToJson(this);

  // Convert to Entity
  LocationEntity toEntity() {
    return LocationEntity(id: locationId, name: areaName);
  }
}