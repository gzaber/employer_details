import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail.g.dart';

@JsonSerializable()
class Detail extends Equatable {
  Detail({
    this.id,
    required this.title,
    required this.description,
    required this.iconData,
    required this.position,
  });

  final int? id;
  final String title;
  final String description;
  final int iconData;
  final int position;

  factory Detail.fromJson(Map<String, dynamic> json) => _$DetailFromJson(json);

  Map<String, dynamic> toJson() => _$DetailToJson(this);

  Detail copyWith({
    int? id,
    String? title,
    String? description,
    int? iconData,
    int? position,
  }) {
    return Detail(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconData: iconData ?? this.iconData,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [id, title, description, iconData, position];
}
