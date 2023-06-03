part of 'details_overview_cubit.dart';

enum DetailsOverviewStatus { loading, success, failure }

class DetailsOverviewState extends Equatable {
  const DetailsOverviewState({
    this.status = DetailsOverviewStatus.loading,
    this.details = const [],
  });

  final DetailsOverviewStatus status;
  final List<Detail> details;

  @override
  List<Object> get props => [status, details];

  DetailsOverviewState copyWith({
    DetailsOverviewStatus? status,
    List<Detail>? details,
  }) {
    return DetailsOverviewState(
      status: status ?? this.status,
      details: details ?? this.details,
    );
  }
}
