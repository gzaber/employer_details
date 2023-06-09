import 'package:app_ui/app_ui.dart';
import 'package:details_repository/details_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_repository/settings_repository.dart';

import '../../details_overview/view/view.dart';
import '../../settings/settings.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.detailsRepository,
    required this.settingsRepository,
  }) : super(key: key);

  final DetailsRepository detailsRepository;
  final SettingsRepository settingsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: detailsRepository),
        RepositoryProvider.value(value: settingsRepository),
      ],
      child: BlocProvider(
        create: (context) =>
            SettingsCubit(settingsRepository: settingsRepository)
              ..readSettings(),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.select((SettingsCubit cubit) => cubit.state);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EmployerDetails',
      theme: AppTheme.themeData(
        brightness:
            settingsState.isDarkTheme ? Brightness.dark : Brightness.light,
        colorScheme: Color(settingsState.colorSchemeCode),
      ),
      home: BlocListener<SettingsCubit, SettingsState>(
        listenWhen: (previous, current) =>
            previous.hasFailure != current.hasFailure,
        listener: (context, state) {
          if (state.hasFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Something went wrong with settings'),
                ),
              );
          }
        },
        child: const DetailsOverviewPage(),
      ),
    );
  }
}
