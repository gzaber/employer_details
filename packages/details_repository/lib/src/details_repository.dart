import 'package:details_api/details_api.dart';

class DetailsRepository {
  DetailsRepository(this._detailsApi);

  final DetailsApi _detailsApi;

  Future<void> createDetail(Detail detail) async {
    await _detailsApi.createDetail(detail);
  }

  Future<void> updateDetail(Detail detail) async {
    await _detailsApi.updateDetail(detail);
  }

  Future<void> deleteDetail(int id) async {
    await _detailsApi.deleteDetail(id);
  }

  Future<List<Detail>> readAllDetails() async {
    return await _detailsApi.readAllDetails();
  }
}
