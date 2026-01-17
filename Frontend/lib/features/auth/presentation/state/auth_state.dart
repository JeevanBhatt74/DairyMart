import '../../domain/entities/location_entity.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final List<LocationEntity> locations;

  AuthState({
    required this.isLoading,
    required this.error,
    required this.locations,
  });

  // Initial State
  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      error: null,
      locations: [],
    );
  }

  // CopyWith for state updates
  AuthState copyWith({
    bool? isLoading,
    String? error,
    List<LocationEntity>? locations,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      locations: locations ?? this.locations,
    );
  }
}