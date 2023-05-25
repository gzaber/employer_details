import 'models/models.dart';

abstract class DetailsApi {
  Future<void> createDetail(Detail detail);
  Future<void> updateDetail(Detail detail);
  Future<void> deleteDetail(int id);
  Future<Detail?> readDetail(int id);
  Future<List<Detail>> readAllDetails();
}
