// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationApiModel _$LocationApiModelFromJson(Map<String, dynamic> json) =>
    LocationApiModel(
      locationId: json['_id'] as String,
      areaName: json['areaName'] as String,
    );

Map<String, dynamic> _$LocationApiModelToJson(LocationApiModel instance) =>
    <String, dynamic>{
      '_id': instance.locationId,
      'areaName': instance.areaName,
    };
