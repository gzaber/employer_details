part of 'manage_detail_cubit.dart';

enum ManageDetailStatus { initial, loading, success, failure }

class ManageDetailState extends Equatable {
  ManageDetailState({
    this.status = ManageDetailStatus.initial,
    Detail? detail,
  }) : detail = detail ??
            Detail(
              title: '',
              description: '',
              iconData: 58136,
              position: 0,
            );

  final ManageDetailStatus status;
  final Detail detail;

  @override
  List<Object> get props => [status, detail];

  ManageDetailState copyWith({
    ManageDetailStatus? status,
    Detail? detail,
  }) {
    return ManageDetailState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
    );
  }
}
