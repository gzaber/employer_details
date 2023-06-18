import 'package:details_api/details_api.dart';

class DetailsRepository {
  DetailsRepository(this._detailsApi);

  final DetailsApi _detailsApi;

  Future<void> saveDetail(Detail detail) async {
    await _detailsApi.saveDetail(detail);
  }

  Future<void> saveAllDetails(List<Detail> details) async {
    await _detailsApi.saveAllDetails(details);
  }

  Future<void> updateDetail(Detail detail) async {
    await _detailsApi.updateDetail(detail);
  }

  Future<void> deleteDetail(int id) async {
    await _detailsApi.deleteDetail(id);
  }

  Future<Detail?> readDetail(int id) async {
    return await _detailsApi.readDetail(id);
  }

  Future<List<Detail>> readAllDetails() async {
    return await _detailsApi.readAllDetails();
  }

  Future<void> clearDetails() async {
    await _detailsApi.clearDetails();
  }
}
