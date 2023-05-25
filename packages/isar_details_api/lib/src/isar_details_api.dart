import 'package:details_api/details_api.dart';
import 'package:isar/isar.dart';

import 'models/models.dart';

class IsarDetailsApi implements DetailsApi {
  IsarDetailsApi(this._isar);

  final Isar _isar;

  @override
  Future<void> createDetail(Detail detail) async {
    await _isar.writeTxn(
      () async {
        await _isar
            .collection<DetailModel>()
            .put(DetailModel.fromDetail(detail));
      },
    );
  }

  @override
  Future<void> updateDetail(Detail detail) async {
    await createDetail(detail);
  }

  @override
  Future<void> deleteDetail(int id) async {
    await _isar.writeTxn(() async {
      await _isar.collection<DetailModel>().delete(id);
    });
  }

  @override
  Future<Detail?> readDetail(int id) async {
    late final DetailModel? detailModel;

    await _isar.writeTxn(() async {
      detailModel = await _isar.collection<DetailModel>().get(id);
    });

    if (detailModel != null) {
      return detailModel!.toDetail();
    }
    return null;
  }

  @override
  Future<List<Detail>> readAllDetails() async {
    late final List<DetailModel> detailModels;

    await _isar.writeTxn(() async {
      detailModels = await _isar.collection<DetailModel>().where().findAll();
    });

    return detailModels.map((m) => m.toDetail()).toList();
  }
}
