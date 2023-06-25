import 'dart:convert';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:details_api/details_api.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';

class DetailsRepository {
  DetailsRepository(
    this._detailsApi, {
    FileSystem? fileSystem,
  }) : _fileSystem = fileSystem ?? LocalFileSystem();

  final DetailsApi _detailsApi;
  final FileSystem _fileSystem;

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

  Future<void> writeDetailsToFile({
    required String pathToFile,
    required List<Detail> details,
  }) async {
    final jsonDetails = details.map((d) => d.toJson()).toList();
    final jsonString = jsonEncode(jsonDetails);
    await _fileSystem.file(pathToFile).writeAsString(jsonString);
  }

  Future<List<Detail>> readDetailsFromFile({required String pathToFile}) async {
    final data = await _fileSystem.file(pathToFile).readAsString();
    final List<dynamic> jsonDetails = jsonDecode(data);
    final details = jsonDetails.map((d) => Detail.fromJson(d)).toList();
    return details;
  }

  XFile convertAllDetailsToXFile(List<Detail> details) {
    final jsonDetails = details.map((d) => d.toJson()).toList();
    final jsonString = jsonEncode(jsonDetails);
    return XFile.fromData(
      Uint8List.fromList(jsonString.codeUnits),
      name: 'shared_details.json',
      mimeType: 'application/json',
    );
  }
}
