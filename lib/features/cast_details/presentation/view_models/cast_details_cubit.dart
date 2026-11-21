import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/cast_details/domain/entities/cast_details.dart';
import 'package:movie_discovery_app/features/cast_details/domain/use_cases/get_cast_details_use_case.dart';
import 'package:movie_discovery_app/features/cast_details/presentation/view_models/cast_details_state.dart';

class CastDetailsCubit extends Cubit<CastDetailsState> {
  final GetCastDetailsUseCase getCastDetailsUseCase;
  final int personId;
  final String language;

  CastDetailsCubit({
    required this.getCastDetailsUseCase,
    required this.personId,
    required this.language,
  }) : super(const CastDetailsState(isLoading: true)) {
    loadDetails();
  }

  Future<void> loadDetails() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await getCastDetailsUseCase(personId, language: language);
    if (isClosed) return;
    if (result is ApiSuccess<CastDetails>) {
      emit(state.copyWith(details: result.data, isLoading: false));
    } else if (result is ApiError<CastDetails>) {
      emit(
        state.copyWith(isLoading: false, errorMessage: result.failure.message),
      );
    }
  }
}
