import 'package:isar/isar.dart';
import 'package:isar_details_api/isar_details_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockIsarCollection extends Mock implements IsarCollection<DetailModel> {}

class MockQuery extends Mock implements Query<DetailModel> {}

class MockQueryBuilderInternal extends Mock
    implements QueryBuilderInternal<DetailModel> {}

class FakeDetailModel extends Fake implements DetailModel {}

class FakeIsar extends Fake implements Isar {
  FakeIsar(this.isarCollection);

  final IsarCollection<DetailModel> isarCollection;

  @override
  IsarCollection<T> collection<T>() {
    return isarCollection as IsarCollection<T>;
  }

  @override
  Future<T> writeTxn<T>(Future<T> Function() callback, {bool silent = false}) {
    callback();
    return Future.value();
  }
}

void main() {
  group('IsarDetailsApi', () {
    late IsarDetailsApi isarDetailsApi;
    late Isar fakeIsar;
    late IsarCollection<DetailModel> mockIsarCollection;

    final detail1 = Detail(
      id: 1,
      title: 'title1',
      description: 'description1',
      iconData: 12345,
      position: 1,
    );

    final detail2 = Detail(
      id: 2,
      title: 'title2',
      description: 'description2',
      iconData: 54321,
      position: 2,
    );

    setUpAll(() {
      registerFallbackValue(FakeDetailModel());
    });

    setUp(() async {
      mockIsarCollection = MockIsarCollection();
      fakeIsar = FakeIsar(mockIsarCollection);
      isarDetailsApi = IsarDetailsApi(fakeIsar);

      when(
        () => mockIsarCollection.put(any()),
      ).thenAnswer((_) async => 1);

      when(
        () => mockIsarCollection.putAll(any()),
      ).thenAnswer((_) async => [1]);

      when(
        () => mockIsarCollection.delete(any()),
      ).thenAnswer((_) async => true);

      when(
        () => mockIsarCollection.get(any()),
      ).thenAnswer((_) async => DetailModel.fromDetail(detail1));

      when(() => mockIsarCollection.clear()).thenAnswer((_) async {});
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => IsarDetailsApi(fakeIsar), returnsNormally);
      });
    });

    group('saveDetail', () {
      test('saves detail into database', () async {
        expect(
          isarDetailsApi.saveDetail(detail1),
          completes,
        );

        verify(
          () => mockIsarCollection.put(DetailModel.fromDetail(detail1)),
        ).called(1);
      });
    });

    group('saveAllDetails', () {
      test('saves list of details into database', () {
        expect(isarDetailsApi.saveAllDetails([detail1, detail2]), completes);

        verify(() => mockIsarCollection.putAll([
              DetailModel.fromDetail(detail1),
              DetailModel.fromDetail(detail2),
            ])).called(1);
      });
    });

    group('updateDetail', () {
      test('updates existing detail', () async {
        expect(
          isarDetailsApi.updateDetail(detail1),
          completes,
        );

        verify(
          () => mockIsarCollection.put(DetailModel.fromDetail(detail1)),
        ).called(1);
      });
    });

    group('deleteDetail', () {
      test('deletes detail from database', () async {
        expect(
          isarDetailsApi.deleteDetail(1),
          completes,
        );

        verify(
          () => mockIsarCollection.delete(1),
        ).called(1);
      });
    });

    group('readDetail', () {
      test('reads detail from database', () async {
        expect(
          isarDetailsApi.readDetail(1),
          completes,
        );

        verify(
          () => mockIsarCollection.get(1),
        ).called(1);
      });
    });

    group('readAllDetails', () {
      late QueryBuilder<DetailModel, DetailModel, QWhere> mockQueryBuilder;
      late QueryBuilderInternal<DetailModel> mockQueryBuilderInternal;
      late Query<DetailModel> mockQuery;

      setUp(() {
        mockQueryBuilderInternal = MockQueryBuilderInternal();
        mockQueryBuilder = QueryBuilder<DetailModel, DetailModel, QWhere>(
          mockQueryBuilderInternal,
        );
        mockQuery = MockQuery();

        when(() => mockIsarCollection.where()).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.build()).thenReturn(mockQuery);
        when(() => mockQuery.findAll()).thenAnswer((_) async =>
            [DetailModel.fromDetail(detail1), DetailModel.fromDetail(detail2)]);
      });

      test('reads all details from database', () {
        expect(isarDetailsApi.readAllDetails(), completes);

        verify(() => mockIsarCollection.where()).called(1);
      });
    });

    group('clearDetails', () {
      test('clears all data in collection', () {
        expect(isarDetailsApi.clearDetails(), completes);

        verify(
          () => mockIsarCollection.clear(),
        ).called(1);
      });
    });
  });
}
