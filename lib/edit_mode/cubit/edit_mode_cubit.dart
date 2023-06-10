import 'dart:math';

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
      details.sort((a, b) => a.position.compareTo(b.position));
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
      final details = state.details;
      final deletedIndex = details.indexWhere((d) => d.id == id);
      details.removeAt(deletedIndex);
      for (int i = deletedIndex; i < details.length; i++) {
        details[i] = details[i].copyWith(position: i);
        await _detailsRepository.updateDetail(details[i]);
      }
      emit(state.copyWith(status: EditModeStatus.success, details: details));
    } catch (_) {
      emit(state.copyWith(status: EditModeStatus.failure));
    }
  }

  void updateDetailPosition({
    required int oldIndex,
    required int newIndex,
  }) async {
    emit(state.copyWith(status: EditModeStatus.loading));
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final details = state.details;
    final detail = details.removeAt(oldIndex);
    details.insert(newIndex, detail);

    final minIndex = min(oldIndex, newIndex);
    try {
      for (int i = minIndex; i < details.length; i++) {
        details[i] = details[i].copyWith(position: i);
        await _detailsRepository.updateDetail(details[i]);
      }
      emit(
        state.copyWith(status: EditModeStatus.success, details: details),
      );
    } catch (_) {
      emit(state.copyWith(status: EditModeStatus.failure));
    }
  }
}
