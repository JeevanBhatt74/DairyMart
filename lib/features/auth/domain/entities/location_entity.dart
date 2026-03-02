import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final String id;
  final String name;

  const LocationEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}