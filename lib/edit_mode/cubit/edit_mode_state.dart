part of 'edit_mode_cubit.dart';

enum EditModeStatus { loading, success, failure }

class EditModeState extends Equatable {
  const EditModeState({
    this.status = EditModeStatus.loading,
    this.details = const [],
  });

  final EditModeStatus status;
  final List<Detail> details;

  @override
  List<Object> get props => [status, details];

  EditModeState copyWith({
    EditModeStatus? status,
    List<Detail>? details,
  }) {
    return EditModeState(
      status: status ?? this.status,
      details: details ?? this.details,
    );
  }
}
