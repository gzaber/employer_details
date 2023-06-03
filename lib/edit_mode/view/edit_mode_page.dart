import 'package:app_ui/app_ui.dart';
import 'package:details_repository/details_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../manage_detail/manage_detail.dart';
import '../edit_mode.dart';

class EditModePage extends StatelessWidget {
  const EditModePage({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => EditModeCubit(
          detailsRepository: context.read<DetailsRepository>(),
        )..getDetails(),
        child: const EditModePage(),
      ),
      settings: const RouteSettings(name: '/edit_mode'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit mode'),
        actions: [
          IconButton(
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
            menuItems: [
              MenuItem(
                icon: Icons.import_export,
                text: 'Import',
                onTap: () {},
              ),
              MenuItem(
                icon: Icons.import_export,
                text: 'Export',
                onTap: () {},
              ),
              MenuItem(
                icon: Icons.share,
                text: 'Share',
                onTap: () {},
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
          if (state.status == EditModeStatus.success) {
            return state.details.isEmpty
                ? const Center(child: Text('No details yet'))
                : _DetailsReorderableList(details: state.details);
          }
          return Container();
        },
      ),
    );
  }
}

class _DetailsReorderableList extends StatefulWidget {
  const _DetailsReorderableList({
    Key? key,
    required this.details,
  }) : super(key: key);

  final List<Detail> details;

  @override
  State<_DetailsReorderableList> createState() =>
      _DetailsReorderableListState();
}

class _DetailsReorderableListState extends State<_DetailsReorderableList> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: widget.details.length,
      itemBuilder: (_, index) {
        final detail = widget.details[index];
        return _DetailItem(
          key: Key('$index'),
          detail: detail,
        );
      },
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final detail = widget.details.removeAt(oldIndex);
          widget.details.insert(newIndex, detail);
        });
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
    return Card(
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
              menuItems: [
                MenuItem(
                  icon: Icons.edit,
                  text: 'Edit',
                  onTap: () {
                    Navigator.push(
                      context,
                      ManageDetailPage.route(detail: detail),
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
                    icon: Icons.delete,
                    text: 'Delete',
                    onTap: () {
                      _showDeleteDialog(context).then((value) {
                        if (value == true) {
                          context
                              .read<EditModeCubit>()
                              .deleteDetail(id: detail.id!);
                          context.read<EditModeCubit>().getDetails();
                        }
                      });
                    }),
              ],
            ),
            const Icon(Icons.drag_handle),
          ],
        ),
      ),
    );
  }
}

Future<bool?> _showDeleteDialog(BuildContext context) async {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete detail'),
          content: const Text('Are you sure you want to delete the detail?'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: const Text('Approve'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      });
}
