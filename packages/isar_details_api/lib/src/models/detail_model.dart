import 'package:details_api/details_api.dart';
import 'package:isar/isar.dart';

part 'detail_model.g.dart';

@collection
class DetailModel {
  DetailModel({
    required this.id,
    required this.iconData,
    required this.title,
    required this.content,
    required this.position,
  });

  final Id id;
  final String title;
  final String content;
  final int iconData;
  final int position;

  DetailModel.fromDetail(Detail detail)
      : id = detail.id ?? Isar.autoIncrement,
        iconData = detail.iconData,
        title = detail.title,
        content = detail.content,
        position = detail.position;

  Detail toDetail() {
    return Detail(
      id: id,
      title: title,
      content: content,
      iconData: iconData,
      position: position,
    );
  }
}
