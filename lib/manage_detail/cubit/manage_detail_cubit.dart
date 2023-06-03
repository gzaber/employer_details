import 'package:details_repository/details_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manage_detail_state.dart';

class ManageDetailCubit extends Cubit<ManageDetailState> {
  ManageDetailCubit({
    required DetailsRepository detailsRepository,
    Detail? detail,
  })  : _detailsRepository = detailsRepository,
        super(ManageDetailState(detail: detail));

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

  void saveDetail() async {
    emit(state.copyWith(status: ManageDetailStatus.loading));
    try {
      await _detailsRepository.updateDetail(state.detail);
      emit(state.copyWith(status: ManageDetailStatus.success));
    } catch (_) {
      emit(state.copyWith(status: ManageDetailStatus.failure));
    }
  }
}
