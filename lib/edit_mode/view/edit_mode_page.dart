import 'dart:convert';
import 'dart:typed_data';

import 'package:app_ui/app_ui.dart';
import 'package:details_repository/details_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        title: const Text('Edit mode'),
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
                key: const Key('editModePageExportButtonKey'),
                icon: Icons.upload,
                text: 'Export',
                onTap: () async {
                  ExportDetailsDialog.show(
                    context,
                    title: 'Export details',
                    selectPathText: 'Select folder',
                    pathLabel: 'Path',
                    fileNameLabel: 'File name',
                    declineButtonText: 'Cancel',
                    approveButtonText: 'Approve',
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
                text: 'Import',
                onTap: () async {
                  ImportDetailsDialog.show(
                    context,
                    title: 'Import details',
                    selectFileText: 'Select file',
                    fileLabel: 'File path',
                    declineButtonText: 'Cancel',
                    approveButtonText: 'Approve',
                  ).then((value) {
                    if (value != null) {
                      context.read<EditModeCubit>().importDetails(path: value);
                    }
                  });
                },
              ),
              MenuItem(
                key: const Key('editModePageShareButtonKey'),
                icon: Icons.share,
                text: 'Share',
                onTap: () async {
                  final details = context.read<EditModeCubit>().state.details;
                  final jsonDetails = details.map((d) => d.toJson()).toList();
                  final jsonString = jsonEncode(jsonDetails);
                  await Share.shareXFiles([
                    XFile.fromData(
                      Uint8List.fromList(jsonString.codeUnits),
                      name: 'shared_details.json',
                      mimeType: 'application/json',
                    )
                  ]);
                },
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<EditModeCubit, EditModeState>(
        listener: (context, state) {
          if (state.status == EditModeStatus.failure) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Something went wrong'),
                ),
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
              ? const Center(
                  child: HintCard(
                    title: 'No details yet',
                    upperText: 'Go to:',
                    hintMenuVisualisations: [
                      HintMenuVisualisation(
                          icon: Icons.add_circle_outline,
                          text: 'Create detail'),
                    ],
                    lowerText: 'to create a new detail',
                  ),
                )
              : _DetailsReorderableList(details: state.details);
        },
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
                    key: Key('editModePageEditMenuItemKey${detail.id}'),
                    icon: Icons.edit,
                    text: 'Edit',
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
                      text: 'Delete',
                      onTap: () {
                        DeleteDetailDialog.show(context,
                                title: 'Delete detail',
                                contentText:
                                    'Are you sure you want to delete the detail?',
                                declineButtonText: 'Decline',
                                approveButtonText: 'Approve')
                            .then((value) {
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
