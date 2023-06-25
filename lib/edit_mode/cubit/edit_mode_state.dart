part of 'edit_mode_cubit.dart';

enum EditModeStatus { loading, success, failure }

class EditModeState extends Equatable {
  const EditModeState({
    this.status = EditModeStatus.loading,
    this.details = const [],
    this.isExported = false,
    this.xFileAllDetails,
  });

  final EditModeStatus status;
  final List<Detail> details;
  final bool isExported;
  final XFile? xFileAllDetails;

  @override
  List<Object?> get props => [status, details, isExported, xFileAllDetails];

  EditModeState copyWith({
    EditModeStatus? status,
    List<Detail>? details,
    bool? isExported,
    XFile? xFileAllDetails,
  }) {
    return EditModeState(
      status: status ?? this.status,
      details: details ?? this.details,
      isExported: isExported ?? this.isExported,
      xFileAllDetails: xFileAllDetails ?? this.xFileAllDetails,
    );
  }
}
