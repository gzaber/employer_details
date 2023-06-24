import 'package:app_ui/app_ui.dart';
import 'package:employer_details/settings/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final settingsState = context.select((SettingsCubit cubit) => cubit.state);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Theme'),
            subtitle: settingsState.isDarkTheme
                ? const Text('dark')
                : const Text('light'),
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
          ),
          ListTile(
            title: const Text('Color scheme'),
            subtitle: Text(
                AppColors.colors[settingsState.colorSchemeCode] ?? 'unknown'),
            leading: const Icon(Icons.color_lens),
            trailing: ElevatedButton(
              key: const Key('settingsPageSelectColorButtonKey'),
              onPressed: () async {
                SelectColorDialog.show(
                  context,
                  title: 'Select color',
                  declineButtonText: 'Cancel',
                  colors: AppColors.colors.keys.map((c) => Color(c)).toList(),
                ).then((color) {
                  if (color != null) {
                    context
                        .read<SettingsCubit>()
                        .updateColorScheme(color.value);
                  }
                });
              },
              child: Icon(
                Icons.square,
                color: Color(settingsState.colorSchemeCode),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
