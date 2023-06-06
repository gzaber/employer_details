import 'package:details_api/details_api.dart';
import 'package:isar/isar.dart';

import 'models/models.dart';

class IsarDetailsApi implements DetailsApi {
  IsarDetailsApi(this._isar);

  final Isar _isar;

  @override
  Future<void> createDetail(Detail detail) async {
    await _isar.writeTxn(() async {
      await _isar.detailModels.put(DetailModel.fromDetail(detail));
    });
  }

  @override
  Future<void> updateDetail(Detail detail) async {
    await createDetail(detail);
  }

  @override
  Future<void> deleteDetail(int id) async {
    return await _isar.writeTxn<void>(() async {
      await _isar.detailModels.delete(id);
    });
  }

  @override
  Future<Detail?> readDetail(int id) async {
    final detailModel = await _isar.detailModels.get(id);

    if (detailModel != null) {
      return detailModel.toDetail();
    }
    return null;
  }

  @override
  Future<List<Detail>> readAllDetails() async {
    final detailModels = await _isar.detailModels.where().findAll();

    return detailModels.map((m) => m.toDetail()).toList();
  }
}
