import 'models/models.dart';

abstract class DetailsApi {
  Future<void> saveDetail(Detail detail);
  Future<void> saveAllDetails(List<Detail> details);
  Future<void> updateDetail(Detail detail);
  Future<void> deleteDetail(int id);
  Future<Detail?> readDetail(int id);
  Future<List<Detail>> readAllDetails();
  Future<void> clearDetails();
}
