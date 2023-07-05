import 'package:app_ui/app_ui.dart';
import 'package:details_repository/details_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

import '../../manage_detail/manage_detail.dart';
import '../edit_mode.dart';

class EditModePage extends StatelessWidget {
  const EditModePage({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const EditModePage(),
      settings: const RouteSettings(name: '/edit_mode'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditModeCubit(
        detailsRepository: context.read<DetailsRepository>(),
      )..getDetails(),
      child: const EditModeView(),
    );
  }
}

class EditModeView extends StatelessWidget {
  const EditModeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editMode),
        actions: [
          IconButton(
            key: const Key('editModePageCreateDetailButtonKey'),
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => Navigator.push<bool>(
              context,
              ManageDetailPage.route(),
            ).then(
              (value) {
                if (value == true) {
                  context.read<EditModeCubit>().getDetails();
                }
              },
            ),
          ),
          MenuButton(
            key: const Key('editModePageMenuButtonKey'),
            menuItems: [
              MenuItem(
                key: const Key('editModePageShareButtonKey'),
                icon: Icons.share,
                text: AppLocalizations.of(context)!.shareConfig,
                onTap: () async {
                  context.read<EditModeCubit>().convertAllDetailsToXFile();
                  final xFileAllDetails =
                      context.read<EditModeCubit>().state.xFileAllDetails;
                  if (xFileAllDetails != null) {
                    await Share.shareXFiles([xFileAllDetails]);
                  }
                },
              ),
              MenuItem(
                key: const Key('editModePageExportButtonKey'),
                icon: Icons.upload,
                text: AppLocalizations.of(context)!.exportConfig,
                onTap: () async {
                  ExportDetailsDialog.show(
                    context,
                    title: AppLocalizations.of(context)!.exportDetails,
                    selectPathText: AppLocalizations.of(context)!.selectFolder,
                    pathLabel: AppLocalizations.of(context)!.path,
                    fileNameLabel: AppLocalizations.of(context)!.fileName,
                    declineButtonText: AppLocalizations.of(context)!.cancel,
                    approveButtonText: AppLocalizations.of(context)!.approve,
                  ).then((value) {
                    if (value != null) {
                      context
                          .read<EditModeCubit>()
                          .exportDetails(path: value.$1, fileName: value.$2);
                    }
                  });
                },
              ),
              MenuItem(
                key: const Key('editModePageImportButtonKey'),
                icon: Icons.download,
                text: AppLocalizations.of(context)!.importConfig,
                onTap: () async {
                  ImportDetailsDialog.show(
                    context,
                    title: AppLocalizations.of(context)!.importDetails,
                    selectFileText: AppLocalizations.of(context)!.selectFile,
                    fileLabel: AppLocalizations.of(context)!.filePath,
                    declineButtonText: AppLocalizations.of(context)!.cancel,
                    approveButtonText: AppLocalizations.of(context)!.approve,
                  ).then((value) {
                    if (value != null) {
                      context
                          .read<EditModeCubit>()
                          .importDetails(pathToFile: value);
                    }
                  });
                },
              ),
              MenuItem(
                key: const Key('editModePageDeleteAllButtonKey'),
                icon: Icons.delete_forever,
                text: AppLocalizations.of(context)!.deleteAll,
                onTap: () {
                  DeleteDialog.show(
                    context,
                    title: AppLocalizations.of(context)!.deleteAllDetails,
                    contentText:
                        AppLocalizations.of(context)!.whetherToDeleteAll,
                    declineButtonText: AppLocalizations.of(context)!.cancel,
                    approveButtonText: AppLocalizations.of(context)!.approve,
                  ).then((value) {
                    if (value == true) {
                      context.read<EditModeCubit>().deleteAllDetails();
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<EditModeCubit, EditModeState>(
        listener: (context, state) {
          if (state.status == EditModeStatus.failure) {
            CustomSnackBar.show(
              context: context,
              text: AppLocalizations.of(context)!.failureMessage,
              backgroundColor: Theme.of(context).colorScheme.error,
            );
          }
          if (state.isExported == true) {
            CustomSnackBar.show(
              context: context,
              text: AppLocalizations.of(context)!.successfullyExported,
              backgroundColor: Theme.of(context).colorScheme.primary,
            );
          }
        },
        builder: (context, state) {
          if (state.status == EditModeStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return state.details.isEmpty
              ? const _EmptyListInfo()
              : _DetailsReorderableList(details: state.details);
        },
      ),
    );
  }
}

class _EmptyListInfo extends StatelessWidget {
  const _EmptyListInfo();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
        child: HintCard(
          title: AppLocalizations.of(context)!.noDetailsYet,
          children: [
            Text(AppLocalizations.of(context)!.goTo),
            HintMenuVisualisation(
              icon: Icons.add_circle_outline,
              text: AppLocalizations.of(context)!.createDetail,
            ),
            Text(AppLocalizations.of(context)!.toCreate),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.goTo),
            HintMenuVisualisation(
              icon: Icons.more_vert,
              text: AppLocalizations.of(context)!.menu,
            ),
            HintMenuVisualisation(
              icon: Icons.download,
              text: AppLocalizations.of(context)!.importConfig,
            ),
            Text(AppLocalizations.of(context)!.toImport),
          ],
        ),
      ),
    );
  }
}

class _DetailsReorderableList extends StatelessWidget {
  const _DetailsReorderableList({
    Key? key,
    required this.details,
  }) : super(key: key);

  final List<Detail> details;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: details.length,
      itemBuilder: (_, index) {
        final detail = details[index];
        return _DetailItem(
          key: Key('editModePageDetailItemKey$index'),
          detail: detail,
        );
      },
      onReorder: (oldIndex, newIndex) {
        context.read<EditModeCubit>().updateDetailPosition(
              oldIndex: oldIndex,
              newIndex: newIndex,
            );
      },
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({
    Key? key,
    required this.detail,
  }) : super(key: key);

  final Detail detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Icon(
              IconData(detail.iconData, fontFamily: 'MaterialIcons'),
            ),
          ),
          title: Text(
            detail.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            detail.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MenuButton(
                key: Key('editModePageEditMenuButtonKey${detail.id}'),
                menuItems: [
                  MenuItem(
                    key: Key('editModePageShareAsTextMenuItemKey${detail.id}'),
                    icon: Icons.share,
                    text: AppLocalizations.of(context)!.shareAsText,
                    onTap: () async {
                      await Share.share(
                        '${detail.title}\n${detail.description}',
                      );
                    },
                  ),
                  MenuItem(
                    key: Key('editModePageEditMenuItemKey${detail.id}'),
                    icon: Icons.edit,
                    text: AppLocalizations.of(context)!.edit,
                    onTap: () {
                      Navigator.push(
                        context,
                        ManageDetailPage.route(id: detail.id),
                      ).then(
                        (value) {
                          if (value == true) {
                            context.read<EditModeCubit>().getDetails();
                          }
                        },
                      );
                    },
                  ),
                  MenuItem(
                      key: Key('editModePageDeleteMenuItemKey${detail.id}'),
                      icon: Icons.delete,
                      text: AppLocalizations.of(context)!.delete,
                      onTap: () {
                        DeleteDialog.show(
                          context,
                          title: AppLocalizations.of(context)!.deleteDetail,
                          contentText:
                              AppLocalizations.of(context)!.whetherToDeleteThis,
                          declineButtonText:
                              AppLocalizations.of(context)!.cancel,
                          approveButtonText:
                              AppLocalizations.of(context)!.approve,
                        ).then((value) {
                          if (value == true) {
                            if (detail.id != null) {
                              context
                                  .read<EditModeCubit>()
                                  .deleteDetail(id: detail.id!);
                            }
                          }
                        });
                      }),
                ],
              ),
              const Icon(Icons.drag_handle),
            ],
          ),
        ),
      ),
    );
  }
}
