import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../cubit/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const SettingsPage(),
      settings: const RouteSettings(name: '/settings'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: BlocListener<SettingsCubit, SettingsState>(
        listenWhen: (previous, current) =>
            previous.hasFailure != current.hasFailure,
        listener: (context, state) {
          if (state.hasFailure) {
            CustomSnackBar.show(
              context: context,
              text: AppLocalizations.of(context)!.failureMessage,
              backgroundColor: Theme.of(context).colorScheme.error,
            );
          }
        },
        child: const Column(
          children: [
            _ThemeSelector(),
            _ColorSchemeSelector(),
          ],
        ),
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context) {
    final settingsState = context.select((SettingsCubit cubit) => cubit.state);

    return ListTile(
      title: Text(AppLocalizations.of(context)!.theme),
      subtitle: settingsState.isDarkTheme
          ? Text(AppLocalizations.of(context)!.dark)
          : Text(AppLocalizations.of(context)!.light),
      leading: const Icon(Icons.contrast),
      trailing: ElevatedButton(
        key: const Key('settingsPageToggleThemeButtonKey'),
        onPressed: () {
          context.read<SettingsCubit>().toggleTheme();
        },
        child: Icon(
          settingsState.isDarkTheme ? Icons.dark_mode : Icons.light_mode,
          color: Color(settingsState.colorSchemeCode),
        ),
      ),
    );
  }
}

class _ColorSchemeSelector extends StatelessWidget {
  const _ColorSchemeSelector();

  @override
  Widget build(BuildContext context) {
    final settingsState = context.select((SettingsCubit cubit) => cubit.state);

    return ListTile(
      title: Text(AppLocalizations.of(context)!.colorScheme),
      subtitle: Text(AppColors.colors[settingsState.colorSchemeCode] ??
          AppLocalizations.of(context)!.unknown),
      leading: const Icon(Icons.color_lens),
      trailing: ElevatedButton(
        key: const Key('settingsPageSelectColorButtonKey'),
        onPressed: () async {
          SelectColorDialog.show(
            context,
            title: AppLocalizations.of(context)!.selectColor,
            declineButtonText: AppLocalizations.of(context)!.cancel,
            colors: AppColors.colors.keys.map((c) => Color(c)).toList(),
          ).then((color) {
            if (color != null) {
              context.read<SettingsCubit>().updateColorScheme(color.value);
            }
          });
        },
        child: Icon(
          Icons.square,
          color: Color(settingsState.colorSchemeCode),
        ),
      ),
    );
  }
}
