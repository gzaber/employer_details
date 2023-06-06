import 'package:isar/isar.dart';
import 'package:isar_details_api/isar_details_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockIsarCollection extends Mock implements IsarCollection<DetailModel> {}

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
        () => mockIsarCollection.delete(any()),
      ).thenAnswer((_) async => true);

      when(
        () => mockIsarCollection.get(any()),
      ).thenAnswer((_) async => DetailModel.fromDetail(detail1));
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => IsarDetailsApi(fakeIsar), returnsNormally);
      });
    });

    group('createDetail', () {
      test('saves Detail into database', () async {
        expect(
          isarDetailsApi.createDetail(detail1),
          completes,
        );

        verify(
          () => mockIsarCollection.put(DetailModel.fromDetail(detail1)),
        ).called(1);
      });
    });

    group('updateDetail', () {
      test('updates existing Detail', () async {
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
      test('deletes Detail from database', () async {
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
      test('reads Detail from database', () async {
        expect(
          isarDetailsApi.readDetail(1),
          completes,
        );

        verify(
          () => mockIsarCollection.get(1),
        ).called(1);
      });
    });
  });
}
