import 'package:app_ui/app_ui.dart';
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
    late DetailsRepository mockDetailsRepository;

    setUp(() {
      mockDetailsRepository = MockDetailsRepository();
    });

    testWidgets('is routable', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: mockDetailsRepository,
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
          value: mockDetailsRepository,
          child: const MaterialApp(
            home: ManageDetailPage(),
          ),
        ),
      );

      expect(find.byType(ManageDetailView), findsOneWidget);
    });
  });

  group('ManageDetailView', () {
    late ManageDetailCubit mockManageDetailCubit;

    final detail = Detail(
      id: 1,
      title: 'detailTitle',
      description: 'detailDescription',
      iconData: 58136,
      position: 1,
    );

    setUp(() {
      mockManageDetailCubit = MockManageDetailCubit();
    });

    testWidgets('renders correct AppBar text when id is null', (tester) async {
      when(() => mockManageDetailCubit.state).thenReturn(ManageDetailState());

      await tester.pumpView(manageDetailCubit: mockManageDetailCubit);

      expect(
        find.descendant(
            of: find.byType(AppBar), matching: find.text('Create detail')),
        findsOneWidget,
      );
    });

    testWidgets('renders CircularProgressIndicator when loading data',
        (tester) async {
      when(() => mockManageDetailCubit.state)
          .thenReturn(ManageDetailState(status: ManageDetailStatus.loading));

      await tester.pumpView(manageDetailCubit: mockManageDetailCubit);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders correct AppBar text when id is not null',
        (tester) async {
      when(() => mockManageDetailCubit.state).thenReturn(
        ManageDetailState(
          status: ManageDetailStatus.success,
          detail: detail,
        ),
      );

      await tester.pumpView(manageDetailCubit: mockManageDetailCubit);

      expect(
        find.descendant(
            of: find.byType(AppBar), matching: find.text('Update detail')),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders correct icon, title and description when detail id is not null',
        (tester) async {
      when(() => mockManageDetailCubit.state).thenReturn(
        ManageDetailState(
          status: ManageDetailStatus.success,
          detail: detail,
        ),
      );

      await tester.pumpView(manageDetailCubit: mockManageDetailCubit);

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.text('detailTitle'), findsOneWidget);
      expect(find.text('detailDescription'), findsOneWidget);
    });

    testWidgets('shows SnackBar with info when failure occured',
        (tester) async {
      when(() => mockManageDetailCubit.state)
          .thenReturn(ManageDetailState(status: ManageDetailStatus.loading));
      whenListen(
        mockManageDetailCubit,
        Stream.fromIterable(
          [ManageDetailState(status: ManageDetailStatus.failure)],
        ),
      );

      await tester.pumpView(manageDetailCubit: mockManageDetailCubit);
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text('Something went wrong'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows SelectIconDialog when select icon button is tapped',
        (tester) async {
      when(() => mockManageDetailCubit.state).thenReturn(ManageDetailState());

      await tester.pumpView(manageDetailCubit: mockManageDetailCubit);

      await tester
          .tap(find.byKey(const Key('manageDetailPageSelectIconButtonKey')));
      await tester.pumpAndSettle();

      expect(find.byType(SelectIconDialog), findsOneWidget);
    });

    testWidgets(
        'invokes cubit method when pops from SelectIconDialog with icon',
        (tester) async {
      when(() => mockManageDetailCubit.state).thenReturn(
        ManageDetailState(detail: detail),
      );

      await tester.pumpView(manageDetailCubit: mockManageDetailCubit);

      await tester
          .tap(find.byKey(const Key('manageDetailPageSelectIconButtonKey')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('selectIconDialogIconKey0')));
      await tester.pumpAndSettle();

      verify(() => mockManageDetailCubit.onIconChanged(detail.iconData))
          .called(1);
    });

    testWidgets('invokes cubit method when title changes', (tester) async {
      when(() => mockManageDetailCubit.state).thenReturn(ManageDetailState());

      await tester.pumpView(manageDetailCubit: mockManageDetailCubit);

      await tester.enterText(
        find.byKey(const Key('manageDetailPageTitleTextFieldKey')),
        'newTitle',
      );

      verify(() => mockManageDetailCubit.onTitleChanged('newTitle')).called(1);
    });

    testWidgets('invokes cubit method when description changes',
        (tester) async {
      when(() => mockManageDetailCubit.state).thenReturn(ManageDetailState());

      await tester.pumpView(manageDetailCubit: mockManageDetailCubit);

      await tester.enterText(
        find.byKey(const Key('manageDetailPageDescriptionTextFormFieldKey')),
        'newDescription',
      );

      verify(() => mockManageDetailCubit.onDescriptionChanged('newDescription'))
          .called(1);
    });

    testWidgets('pops with true when detail saved successfully',
        (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.pop()).thenAnswer((_) async {});
      when(() => mockManageDetailCubit.state).thenReturn(
        ManageDetailState(
          status: ManageDetailStatus.loading,
          detail: detail,
        ),
      );
      whenListen(
          mockManageDetailCubit,
          Stream.fromIterable([
            ManageDetailState(
                status: ManageDetailStatus.saveSuccess, detail: detail)
          ]));

      await tester.pumpView(
          manageDetailCubit: mockManageDetailCubit,
          view: MockNavigatorProvider(
            navigator: navigator,
            child: const ManageDetailView(),
          ));
      await tester.pump();

      verify(() => navigator.pop<bool>(true)).called(1);
    });
  });
}
