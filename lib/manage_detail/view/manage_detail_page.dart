import 'package:app_ui/app_ui.dart';
import 'package:details_repository/details_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manage_detail.dart';

class ManageDetailPage extends StatelessWidget {
  const ManageDetailPage({
    Key? key,
    this.detail,
  }) : super(key: key);

  final Detail? detail;

  static Route<bool> route({Detail? detail}) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => ManageDetailCubit(
          detailsRepository: context.read<DetailsRepository>(),
          detail: detail,
        ),
        child: ManageDetailPage(detail: detail),
      ),
      settings: const RouteSettings(name: '/manage_detail'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(detail == null ? 'Create detail' : 'Update detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => context.read<ManageDetailCubit>().saveDetail(),
          ),
        ],
      ),
      body: BlocConsumer<ManageDetailCubit, ManageDetailState>(
        listener: (context, state) {
          if (state.status == ManageDetailStatus.failure) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Something went wrong'),
                ),
              );
          }
          if (state.status == ManageDetailStatus.success) {
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          if (state.status == ManageDetailStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const _DetailForm();
        },
      ),
    );
  }
}

class _DetailForm extends StatelessWidget {
  const _DetailForm();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Row(
          children: [
            Text(
              'Icon',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(width: 20),
            const _SelectIconButton(),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Title',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        TextField(
          controller: TextEditingController(
            text: context.read<ManageDetailCubit>().state.detail.title,
          ),
          onChanged: (value) =>
              context.read<ManageDetailCubit>().onTitleChanged(value),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Description',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        TextFormField(
          controller: TextEditingController(
            text: context.read<ManageDetailCubit>().state.detail.description,
          ),
          onChanged: (value) =>
              context.read<ManageDetailCubit>().onDescriptionChanged(value),
          maxLines: 5,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class _SelectIconButton extends StatelessWidget {
  const _SelectIconButton();

  @override
  Widget build(BuildContext context) {
    final iconData = context
        .select((ManageDetailCubit cubit) => cubit.state.detail.iconData);

    return OutlinedButton(
      onPressed: () async {
        SelectIconDialog.show(
          context,
          title: 'Select icon',
          declineButtonText: 'Cancel',
          icons: AppIcons.icons,
        ).then((iconData) {
          if (iconData != null) {
            context.read<ManageDetailCubit>().onIconChanged(iconData.codePoint);
          }
        });
      },
      child: Icon(
        IconData(iconData, fontFamily: 'MaterialIcons'),
      ),
    );
  }
}
