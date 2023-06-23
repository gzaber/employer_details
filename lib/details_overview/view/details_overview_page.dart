import 'package:app_ui/app_ui.dart';
import 'package:details_repository/details_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../edit_mode/edit_mode.dart';
import '../../settings/settings.dart';
import '../details_overview.dart';

class DetailsOverviewPage extends StatelessWidget {
  const DetailsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailsOverviewCubit(
        detailsRepository: context.read<DetailsRepository>(),
      )..getDetails(),
      child: const DetailsOverviewView(),
    );
  }
}

class DetailsOverviewView extends StatelessWidget {
  const DetailsOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EmployerDetails'),
        actions: [
          MenuButton(
            menuItems: [
              MenuItem(
                key: const Key('detailsOverviewPageEditModeMenuItemKey'),
                icon: Icons.edit,
                text: 'Edit mode',
                onTap: () {
                  Navigator.push(
                    context,
                    EditModePage.route(),
                  ).then(
                    (_) => context.read<DetailsOverviewCubit>().getDetails(),
                  );
                },
              ),
              MenuItem(
                key: const Key('detailsOverviewPageSettingsMenuItemKey'),
                icon: Icons.settings,
                text: 'Settings',
                onTap: () => Navigator.push(context, SettingsPage.route()),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<DetailsOverviewCubit, DetailsOverviewState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == DetailsOverviewStatus.failure) {
            CustomSnackBar.show(
              context: context,
              text: 'Something went wrong',
              backgroundColor: Theme.of(context).colorScheme.error,
            );
          }
        },
        builder: (context, state) {
          if (state.status == DetailsOverviewStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.status == DetailsOverviewStatus.success) {
            return state.details.isEmpty
                ? const Center(
                    child: HintCard(
                      title: 'No details yet',
                      upperText: 'Go to:',
                      hintMenuVisualisations: [
                        HintMenuVisualisation(
                            icon: Icons.more_vert, text: 'Menu'),
                        HintMenuVisualisation(
                            icon: Icons.edit, text: 'Edit mode'),
                      ],
                      lowerText: 'to add new details',
                    ),
                  )
                : _DetailsList(details: state.details);
          }
          return Container();
        },
      ),
    );
  }
}

class _DetailsList extends StatelessWidget {
  const _DetailsList({
    Key? key,
    required this.details,
  }) : super(key: key);

  final List<Detail> details;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: details.length,
      itemBuilder: (_, index) {
        final detail = details[index];
        return _DetailItem(detail: detail);
      },
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({required this.detail});
  final Detail detail;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(
            IconData(detail.iconData, fontFamily: 'MaterialIcons'),
          ),
        ),
        title: Text(detail.title),
        subtitle: Text(detail.description),
      ),
    );
  }
}
