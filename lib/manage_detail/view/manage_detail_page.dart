import 'package:app_ui/app_ui.dart';
import 'package:details_repository/details_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../manage_detail.dart';

class ManageDetailPage extends StatelessWidget {
  const ManageDetailPage({
    Key? key,
    this.id,
  }) : super(key: key);

  final int? id;

  static Route<bool> route({int? id}) {
    return MaterialPageRoute(
      builder: (_) => ManageDetailPage(id: id),
      settings: const RouteSettings(name: '/manage_detail'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageDetailCubit(
        detailsRepository: context.read<DetailsRepository>(),
      )..getDetail(id),
      child: const ManageDetailView(),
    );
  }
}

class ManageDetailView extends StatelessWidget {
  const ManageDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageDetailCubit, ManageDetailState>(
      listener: (context, state) {
        if (state.status == ManageDetailStatus.failure) {
          CustomSnackBar.show(
            context: context,
            text: AppLocalizations.of(context)!.failureMessage,
            backgroundColor: Theme.of(context).colorScheme.error,
          );
        }
        if (state.status == ManageDetailStatus.saveSuccess) {
          Navigator.pop(context, true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              context.read<ManageDetailCubit>().state.detail.id == null
                  ? AppLocalizations.of(context)!.createDetail
                  : AppLocalizations.of(context)!.updateDetail,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  context.read<ManageDetailCubit>().state.detail.id == null
                      ? context.read<ManageDetailCubit>().saveDetail()
                      : context.read<ManageDetailCubit>().updateDetail();
                },
              ),
            ],
          ),
          body: state.status == ManageDetailStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : const _DetailForm(),
        );
      },
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
            const _SelectIconButton(
              key: Key('manageDetailPageSelectIconButtonKey'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        TextField(
          key: const Key('manageDetailPageTitleTextFieldKey'),
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
          AppLocalizations.of(context)!.description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        TextFormField(
          key: const Key('manageDetailPageDescriptionTextFormFieldKey'),
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
  const _SelectIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final iconData = context
        .select((ManageDetailCubit cubit) => cubit.state.detail.iconData);

    return OutlinedButton(
      onPressed: () async {
        SelectIconDialog.show(
          context,
          title: AppLocalizations.of(context)!.selectIcon,
          declineButtonText: AppLocalizations.of(context)!.cancel,
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
