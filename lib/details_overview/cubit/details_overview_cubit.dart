import 'package:details_repository/details_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'details_overview_state.dart';

class DetailsOverviewCubit extends Cubit<DetailsOverviewState> {
  DetailsOverviewCubit({
    required DetailsRepository detailsRepository,
  })  : _detailsRepository = detailsRepository,
        super(const DetailsOverviewState());

  final DetailsRepository _detailsRepository;

  void getDetails() async {
    emit(state.copyWith(status: DetailsOverviewStatus.loading));
    try {
      final details = await _detailsRepository.readAllDetails();
      emit(
        state.copyWith(
          status: DetailsOverviewStatus.success,
          details: details,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(status: DetailsOverviewStatus.failure),
      );
    }
  }
}
