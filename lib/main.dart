import 'package:details_repository/details_repository.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:isar_details_api/isar_details_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings_repository/settings_repository.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([DetailModelSchema], directory: dir.path);
  final detailsApi = IsarDetailsApi(isar);
  final detailsRepository = DetailsRepository(detailsApi);
  final prefs = await SharedPreferences.getInstance();
  final settingsRepository = SettingsRepository(prefs);

  runApp(
    App(
      detailsRepository: detailsRepository,
      settingsRepository: settingsRepository,
    ),
  );
}
