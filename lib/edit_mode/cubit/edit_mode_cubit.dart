import 'package:details_repository/details_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_mode_state.dart';

class EditModeCubit extends Cubit<EditModeState> {
  EditModeCubit({
    required DetailsRepository detailsRepository,
  })  : _detailsRepository = detailsRepository,
        super(const EditModeState());

  final DetailsRepository _detailsRepository;

  void getDetails() async {
    emit(state.copyWith(status: EditModeStatus.loading));
    try {
      final details = await _detailsRepository.readAllDetails();
      emit(
        state.copyWith(
          status: EditModeStatus.success,
          details: details,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: EditModeStatus.failure));
    }
  }

  void deleteDetail({required int id}) async {
    emit(state.copyWith(status: EditModeStatus.loading));
    try {
      await _detailsRepository.deleteDetail(id);
      emit(state.copyWith(status: EditModeStatus.success));
    } catch (_) {
      emit(state.copyWith(status: EditModeStatus.failure));
    }
  }
}
