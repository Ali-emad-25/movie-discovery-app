import 'package:movie_discovery_app/features/cast_details/domain/entities/cast_details.dart';

class CastDetailsState {
  final CastDetails? details;
  final bool isLoading;
  final String? errorMessage;

  const CastDetailsState({
    this.details,
    this.isLoading = false,
    this.errorMessage,
  });

  CastDetailsState copyWith({
    CastDetails? details,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) => CastDetailsState(
    details: details ?? this.details,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );
}
