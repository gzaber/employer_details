import 'package:details_repository/details_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manage_detail_state.dart';

class ManageDetailCubit extends Cubit<ManageDetailState> {
  ManageDetailCubit({
    required DetailsRepository detailsRepository,
  })  : _detailsRepository = detailsRepository,
        super(ManageDetailState());

  final DetailsRepository _detailsRepository;

  void onIconChanged(int iconData) {
    emit(
      state.copyWith(
        detail: state.detail.copyWith(iconData: iconData),
      ),
    );
  }

  void onTitleChanged(String title) {
    emit(
      state.copyWith(
        detail: state.detail.copyWith(title: title),
      ),
    );
  }

  void onDescriptionChanged(String description) {
    emit(
      state.copyWith(
        detail: state.detail.copyWith(description: description),
      ),
    );
  }

  void getDetail(int? id) async {
    if (id == null) return;
    emit(state.copyWith(status: ManageDetailStatus.loading));
    try {
      final detail = await _detailsRepository.readDetail(id);
      if (detail == null) throw Exception();
      emit(
        state.copyWith(
          status: ManageDetailStatus.success,
          detail: detail,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ManageDetailStatus.failure));
    }
  }

  void createDetail() async {
    emit(state.copyWith(status: ManageDetailStatus.loading));
    try {
      final details = await _detailsRepository.readAllDetails();
      final detail = state.detail.copyWith(position: details.length);
      await _detailsRepository.createDetail(detail);
      emit(state.copyWith(status: ManageDetailStatus.saveSuccess));
    } catch (_) {
      emit(state.copyWith(status: ManageDetailStatus.failure));
    }
  }

  void updateDetail() async {
    emit(state.copyWith(status: ManageDetailStatus.loading));
    try {
      await _detailsRepository.updateDetail(state.detail);
      emit(state.copyWith(status: ManageDetailStatus.saveSuccess));
    } catch (_) {
      emit(state.copyWith(status: ManageDetailStatus.failure));
    }
  }
}
