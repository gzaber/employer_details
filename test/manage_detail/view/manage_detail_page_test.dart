import 'package:bloc_test/bloc_test.dart';
import 'package:details_repository/details_repository.dart';
import 'package:employer_details/manage_detail/manage_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

extension PumpWidgetX on WidgetTester {
  Future<void> pumpView({
    required ManageDetailCubit manageDetailCubit,
    Widget view = const ManageDetailView(),
  }) {
    return pumpWidget(
      BlocProvider.value(
        value: manageDetailCubit,
        child: MaterialApp(
          home: view,
        ),
      ),
    );
  }
}

class MockDetailsRepository extends Mock implements DetailsRepository {}

class MockManageDetailCubit extends MockCubit<ManageDetailState>
    implements ManageDetailCubit {}

void main() {
  group('ManageDetailPage', () {
    late DetailsRepository detailsRepository;

    setUp(() {
      detailsRepository = MockDetailsRepository();
    });

    testWidgets('is routable', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: detailsRepository,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context, ManageDetailPage.route());
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(ManageDetailPage), findsOneWidget);
    });

    testWidgets('renders ManageDetailView', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: detailsRepository,
          child: const MaterialApp(
            home: ManageDetailPage(),
          ),
        ),
      );

      expect(find.byType(ManageDetailView), findsOneWidget);
    });
  });

  group('ManageDetailView', () {
    late ManageDetailCubit manageDetailCubit;

    final detail = Detail(
      id: 1,
      title: 'detailTitle',
      description: 'detailDescription',
      iconData: 58136,
      position: 1,
    );

    setUp(() {
      manageDetailCubit = MockManageDetailCubit();
    });

    testWidgets('renders correct AppBar text when id is null', (tester) async {
      when(() => manageDetailCubit.state).thenReturn(ManageDetailState());

      await tester.pumpView(manageDetailCubit: manageDetailCubit);

      expect(
        find.descendant(
            of: find.byType(AppBar), matching: find.text('Create detail')),
        findsOneWidget,
      );
    });

    testWidgets('renders CircularProgressIndicator when loading data',
        (tester) async {
      when(() => manageDetailCubit.state)
          .thenReturn(ManageDetailState(status: ManageDetailStatus.loading));

      await tester.pumpView(manageDetailCubit: manageDetailCubit);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders correct AppBar text when id is not null',
        (tester) async {
      when(() => manageDetailCubit.state).thenReturn(
        ManageDetailState(
          status: ManageDetailStatus.success,
          detail: detail,
        ),
      );

      await tester.pumpView(manageDetailCubit: manageDetailCubit);

      expect(
        find.descendant(
            of: find.byType(AppBar), matching: find.text('Update detail')),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders correct icon, title and description when detail id is not null',
        (tester) async {
      when(() => manageDetailCubit.state).thenReturn(
        ManageDetailState(
          status: ManageDetailStatus.success,
          detail: detail,
        ),
      );

      await tester.pumpView(manageDetailCubit: manageDetailCubit);

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.text('detailTitle'), findsOneWidget);
      expect(find.text('detailDescription'), findsOneWidget);
    });

    testWidgets('shows SnackBar with info when exception occurs',
        (tester) async {
      when(() => manageDetailCubit.state)
          .thenReturn(ManageDetailState(status: ManageDetailStatus.loading));
      whenListen(
        manageDetailCubit,
        Stream.fromIterable(
          [ManageDetailState(status: ManageDetailStatus.failure)],
        ),
      );

      await tester.pumpView(manageDetailCubit: manageDetailCubit);
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text('Something went wrong'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows dialog when select icon button is tapped',
        (tester) async {
      when(() => manageDetailCubit.state).thenReturn(ManageDetailState());

      await tester.pumpView(manageDetailCubit: manageDetailCubit);

      await tester
          .tap(find.byKey(const Key('manageDetailPageSelectIconButtonKey')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('invokes cubit method when pops from dialog with icon',
        (tester) async {
      when(() => manageDetailCubit.state).thenReturn(
        ManageDetailState(detail: detail),
      );

      await tester.pumpView(manageDetailCubit: manageDetailCubit);

      await tester
          .tap(find.byKey(const Key('manageDetailPageSelectIconButtonKey')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('selectIconDialogIconKey0')));
      await tester.pumpAndSettle();

      verify(() => manageDetailCubit.onIconChanged(detail.iconData)).called(1);
    });

    testWidgets('invokes cubit method when title changes', (tester) async {
      when(() => manageDetailCubit.state).thenReturn(ManageDetailState());

      await tester.pumpView(manageDetailCubit: manageDetailCubit);

      await tester.enterText(
        find.byKey(const Key('manageDetailPageTitleTextFieldKey')),
        'newTitle',
      );

      verify(() => manageDetailCubit.onTitleChanged('newTitle')).called(1);
    });

    testWidgets('invokes cubit method when description changes',
        (tester) async {
      when(() => manageDetailCubit.state).thenReturn(ManageDetailState());

      await tester.pumpView(manageDetailCubit: manageDetailCubit);

      await tester.enterText(
        find.byKey(const Key('manageDetailPageDescriptionTextFormFieldKey')),
        'newDescription',
      );

      verify(() => manageDetailCubit.onDescriptionChanged('newDescription'))
          .called(1);
    });

    testWidgets('pops with true when detail saved successfully',
        (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.pop()).thenAnswer((_) async {});
      when(() => manageDetailCubit.state).thenReturn(
        ManageDetailState(
          status: ManageDetailStatus.loading,
          detail: detail,
        ),
      );
      whenListen(
          manageDetailCubit,
          Stream.fromIterable([
            ManageDetailState(
                status: ManageDetailStatus.saveSuccess, detail: detail)
          ]));

      await tester.pumpView(
          manageDetailCubit: manageDetailCubit,
          view: MockNavigatorProvider(
            navigator: navigator,
            child: const ManageDetailView(),
          ));
      await tester.pump();

      verify(() => navigator.pop<bool>(true)).called(1);
    });
  });
}
