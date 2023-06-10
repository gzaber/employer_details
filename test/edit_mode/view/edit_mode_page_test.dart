import 'package:bloc_test/bloc_test.dart';
import 'package:details_repository/details_repository.dart';
import 'package:employer_details/edit_mode/edit_mode.dart';
import 'package:employer_details/manage_detail/manage_detail.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

extension PumpWidgetX on WidgetTester {
  Future<void> pumpView({
    required EditModeCubit editModeCubit,
    DetailsRepository? detailsRepository,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: detailsRepository,
        child: BlocProvider.value(
          value: editModeCubit,
          child: const MaterialApp(
            home: EditModeView(),
          ),
        ),
      ),
    );
  }
}

class MockDetailsRepository extends Mock implements DetailsRepository {}

class MockEditModeCubit extends MockCubit<EditModeState>
    implements EditModeCubit {}

class FakeDetail extends Fake implements Detail {}

void main() {
  group('EditModePage', () {
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
                    Navigator.push(context, EditModePage.route());
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(EditModePage), findsOneWidget);
    });

    testWidgets('renders EditModeView', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: detailsRepository,
          child: const MaterialApp(
            home: EditModePage(),
          ),
        ),
      );

      expect(find.byType(EditModeView), findsOneWidget);
    });
  });

  group('NewTimerView', () {
    late EditModeCubit editModeCubit;

    final details = [
      Detail(
          id: 1,
          title: 'title1',
          description: 'description1',
          iconData: 11111,
          position: 1),
      Detail(
          id: 2,
          title: 'title2',
          description: 'description2',
          iconData: 22222,
          position: 2),
    ];

    setUpAll(() {
      registerFallbackValue(FakeDetail());
    });

    setUp(() {
      editModeCubit = MockEditModeCubit();
    });

    testWidgets('renders CircularProgressIndicator when loading data',
        (tester) async {
      when(() => editModeCubit.state)
          .thenReturn(const EditModeState(status: EditModeStatus.loading));

      await tester.pumpView(editModeCubit: editModeCubit);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'renders ReorderableListView with Cards when loaded successfully',
        (tester) async {
      when(() => editModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(editModeCubit: editModeCubit);

      expect(
        find.descendant(
            of: find.byType(ReorderableListView), matching: find.byType(Card)),
        findsNWidgets(2),
      );
    });

    testWidgets('renders info when there are no details', (tester) async {
      when(() => editModeCubit.state).thenReturn(
        const EditModeState(
          status: EditModeStatus.success,
          details: [],
        ),
      );

      await tester.pumpView(editModeCubit: editModeCubit);

      expect(find.text('No details yet'), findsOneWidget);
    });

    testWidgets('shows SnackBar with info when exception occurs',
        (tester) async {
      when(() => editModeCubit.state)
          .thenReturn(const EditModeState(status: EditModeStatus.loading));
      whenListen(
        editModeCubit,
        Stream.fromIterable(
          const [EditModeState(status: EditModeStatus.failure)],
        ),
      );

      await tester.pumpView(editModeCubit: editModeCubit);
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text('Something went wrong'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('navigates to ManageDetailPage when edit menu item is tapped',
        (tester) async {
      final detailsRepository = MockDetailsRepository();
      when(() => editModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(
        editModeCubit: editModeCubit,
        detailsRepository: detailsRepository,
      );

      await tester.tap(find.byKey(const Key('editModePageEditMenuButtonKey1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('editModePageEditMenuItemKey1')));
      await tester.pumpAndSettle();

      expect(find.byType(ManageDetailPage), findsOneWidget);
    });

    testWidgets(
        'navigates to ManageDetailPage when create detail button is tapped',
        (tester) async {
      final detailsRepository = MockDetailsRepository();
      when(() => editModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(
        editModeCubit: editModeCubit,
        detailsRepository: detailsRepository,
      );

      await tester
          .tap(find.byKey(const Key('editModePageCreateDetailButtonKey')));
      await tester.pumpAndSettle();

      expect(find.byType(ManageDetailPage), findsOneWidget);
    });

    testWidgets(
        'reads details when pops with true from ManageDetailPage after creating detail',
        (tester) async {
      final detailsRepository = MockDetailsRepository();
      when(() => detailsRepository.readAllDetails())
          .thenAnswer((_) async => []);
      when(() => detailsRepository.createDetail(any()))
          .thenAnswer((_) async => {});
      when(() => editModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(
        editModeCubit: editModeCubit,
        detailsRepository: detailsRepository,
      );

      await tester
          .tap(find.byKey(const Key('editModePageCreateDetailButtonKey')));
      await tester.pumpAndSettle();

      expect(find.byType(ManageDetailPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      expect(find.byType(EditModeView), findsOneWidget);

      verify(() => editModeCubit.getDetails()).called(1);
    });

    testWidgets(
        'reads details when pops with true from ManageDetailPage after updating detail',
        (tester) async {
      final detailsRepository = MockDetailsRepository();
      when(() => detailsRepository.readDetail(any()))
          .thenAnswer((_) async => details.first);
      when(() => detailsRepository.updateDetail(any()))
          .thenAnswer((_) async => {});
      when(() => editModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(
        editModeCubit: editModeCubit,
        detailsRepository: detailsRepository,
      );

      await tester.tap(find.byKey(const Key('editModePageEditMenuButtonKey1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('editModePageEditMenuItemKey1')));
      await tester.pumpAndSettle();

      expect(find.byType(ManageDetailPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      expect(find.byType(EditModeView), findsOneWidget);

      verify(() => editModeCubit.getDetails()).called(1);
    });

    testWidgets('shows dialog when delete menu item is tapped', (tester) async {
      when(() => editModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(editModeCubit: editModeCubit);

      await tester.tap(find.byKey(const Key('editModePageEditMenuButtonKey1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('editModePageDeleteMenuItemKey1')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets(
        'deletes detail and reads list of details when pops from dialog with true',
        (tester) async {
      when(() => editModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(editModeCubit: editModeCubit);

      await tester.tap(find.byKey(const Key('editModePageEditMenuButtonKey1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('editModePageDeleteMenuItemKey1')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(
          find.byKey(const Key('editModePageDeleteDialogApproveButtonKey')));
      await tester.pumpAndSettle();

      verify(() => editModeCubit.deleteDetail(id: details.first.id!)).called(1);
    });

    testWidgets(
        'doesn\'t invoke any cubit methods when pops from dialog with false',
        (tester) async {
      when(() => editModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(editModeCubit: editModeCubit);

      await tester.tap(find.byKey(const Key('editModePageEditMenuButtonKey1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('editModePageDeleteMenuItemKey1')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(
          find.byKey(const Key('editModePageDeleteDialogCancelButtonKey')));
      await tester.pumpAndSettle();

      verifyNever(() => editModeCubit.deleteDetail(id: details.first.id!));
      verifyNever(() => editModeCubit.getDetails());
    });

    testWidgets(
        'reorders details when detail item is dragged to a new position',
        (tester) async {
      when(() => editModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(editModeCubit: editModeCubit);

      final TestGesture drag = await tester.startGesture(tester
          .getCenter(find.byKey(const Key('editModePageDetailItemKey0'))));
      await tester.pump(kLongPressTimeout + kPressTimeout);
      await drag.moveTo(tester
          .getCenter(find.byKey(const Key('editModePageDetailItemKey1'))));
      await drag.up();
      await tester.pumpAndSettle();

      verify(() => editModeCubit.updateDetailPosition(oldIndex: 0, newIndex: 1))
          .called(1);
    });
  });
}
