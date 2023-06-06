import 'package:details_api/details_api.dart';
import 'package:isar/isar.dart';

part 'detail_model.g.dart';

@collection
class DetailModel extends Equatable {
  DetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconData,
    required this.position,
  });

  final Id id;
  final String title;
  final String description;
  final int iconData;
  final int position;

  DetailModel.fromDetail(Detail detail)
      : id = detail.id ?? Isar.autoIncrement,
        title = detail.title,
        description = detail.description,
        iconData = detail.iconData,
        position = detail.position;

  Detail toDetail() {
    return Detail(
      id: id,
      title: title,
      description: description,
      iconData: iconData,
      position: position,
    );
  }

  @override
  List<Object> get props => [id, title, description, iconData, position];
}
